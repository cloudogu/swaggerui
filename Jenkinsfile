#!groovy
@Library(['github.com/cloudogu/dogu-build-lib@v3.0.0', 'github.com/cloudogu/ces-build-lib@4.0.1']) _
import com.cloudogu.ces.dogubuildlib.*
import com.cloudogu.ces.cesbuildlib.*

node('vagrant') {
    Git git = new Git(this)
    GitFlow gitflow = new GitFlow(this, git)
    doguName="swaggerui"

    timestamps{
        properties([
                // Keep only the last x builds to preserve space
                buildDiscarder(logRotator(numToKeepStr: '10')),
                // Don't run concurrent builds for a branch, because they use the same workspace directory
                disableConcurrentBuilds(),
                parameters([
                        booleanParam(defaultValue: false, description: 'Test dogu upgrade from latest release or optionally from defined version below', name: 'TestDoguUpgrade'),
                        booleanParam(defaultValue: true, description: 'Enables cypress to record video of the integration tests.', name: 'EnableVideoRecording'),
                        booleanParam(defaultValue: true, description: 'Enables cypress to take screenshots of failing integration tests.', name: 'EnableScreenshotRecording'),
                        string(defaultValue: '', description: 'Old Dogu version for the upgrade test (optional; e.g. 4.1.0-3)', name: 'OldDoguVersionForUpgradeTest'),
                        choice(name: 'TrivySeverityLevels', choices: [TrivySeverityLevel.CRITICAL, TrivySeverityLevel.HIGH_AND_ABOVE, TrivySeverityLevel.MEDIUM_AND_ABOVE, TrivySeverityLevel.ALL], description: 'The levels to scan with trivy', defaultValue: TrivySeverityLevel.CRITICAL),
                        choice(name: 'TrivyStrategy', choices: [TrivyScanStrategy.UNSTABLE, TrivyScanStrategy.FAIL, TrivyScanStrategy.IGNORE], description: 'Define whether the build should be unstable, fail or whether the error should be ignored if any vulnerability was found.', defaultValue: TrivyScanStrategy.UNSTABLE),
                ])
        ])
        EcoSystem ecoSystem = new EcoSystem(this, "gcloud-ces-operations-internal-packer", "jenkins-gcloud-ces-operations-internal")

        stage('Checkout') {
            checkout scm
            sh 'git submodule update --init'
        }

        stage('Lint') {
            lintDockerfile()
            shellCheck("./resources/startup.sh")
        }

        try {

            stage('Provision') {
                ecoSystem.provision("/dogu")
            }

            stage('Setup') {
                ecoSystem.loginBackend('cesmarvin-setup')
                ecoSystem.setup()
            }

            stage('Wait for dependencies') {
                timeout(15) {
                    ecoSystem.waitForDogu("nginx")
                }
            }

            stage('Build') {
                // change namespace to prerelease_namespace if in develop-branch
                if (gitflow.isPreReleaseBranch()) {
                    ecoSystem.vagrant.ssh "cd /dogu && make prerelease_namespace"
                }
                ecoSystem.build("/dogu")
            }

            stage('Trivy scan') {
                ecoSystem.copyDoguImageToJenkinsWorker("/dogu")
                Trivy trivy = new Trivy(this)
                trivy.scanDogu(".", params.TrivySeverityLevels, params.TrivyStrategy)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.TABLE)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.JSON)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.HTML)
            }

            stage('Verify') {
                ecoSystem.verify("/dogu")
            }

            stage('Wait for swagger dogu') {
                timeout(15) {
                    ecoSystem.waitForDogu("swaggerui")
                }
            }


            stage('Integration Tests') {
                echo "run integration tests."
                ecoSystem.runCypressIntegrationTests([
                        cypressImage     : "cypress/included:13.15.2",
                        enableVideo      : params.EnableVideoRecording,
                        enableScreenshots: params.EnableScreenshotRecording,
                ])
            }

            if (params.TestDoguUpgrade != null && params.TestDoguUpgrade) {
                stage('Upgrade dogu') {
                    // Remove new dogu that has been built and tested above
                    ecoSystem.purgeDogu(doguName)

                    if (params.OldDoguVersionForUpgradeTest != '' && !params.OldDoguVersionForUpgradeTest.contains('v')) {
                        println "Installing user defined version of dogu: " + params.OldDoguVersionForUpgradeTest
                        ecoSystem.installDogu("official/" + doguName + " " + params.OldDoguVersionForUpgradeTest)
                    } else {
                        println "Installing latest released version of dogu..."
                        ecoSystem.installDogu("official/" + doguName)
                    }
                    installTestPlugin(ecoSystem, testPluginName)
                    ecoSystem.startDogu(doguName)
                    ecoSystem.waitForDogu(doguName)
                    ecoSystem.upgradeDogu(ecoSystem)

                    // Wait for upgraded dogu to get healthy
                    ecoSystem.waitForDogu(doguName)
                    ecoSystem.waitUntilAvailable(doguName)
                }

                stage('Integration Tests - After Upgrade') {
                    // Run integration tests again to verify that the upgrade was successful
                    runIntegrationTests(ecoSystem)
                }
            }

            if (isReleaseBranch()) {
                stage('Finish Release') {
                    String releaseVersion = getReleaseVersion();
                    echo "Your release version is: ${releaseVersion}"

                    // Check if tag already exists
                    if (tagExists("${releaseVersion}")){
                        error("You cannot build this version, because it already exists.")
                    }

                    // Make sure all branches are fetched
                    sh "git config 'remote.origin.fetch' '+refs/heads/*:refs/remotes/origin/*'"
                    gitWithCredentials("fetch --all")

                    // Make sure there are no changes on develop
                    if (developHasChanged(env.BRANCH_NAME)){
                        error("There are changes on develop branch that are not merged into release. Please merge and restart process.")
                    }

                    // Make sure any branch we need exists locally
                    sh "git checkout ${env.BRANCH_NAME}"
                    gitWithCredentials("pull origin ${env.BRANCH_NAME}")
                    sh "git checkout develop"
                    gitWithCredentials("pull origin develop")
                    sh "git checkout master"
                    gitWithCredentials("pull origin master")

                    // Merge release branch into master
                    sh "git merge --no-ff ${env.BRANCH_NAME}"

                    // Create tag. Use -f because the created tag will persist when build has failed.
                    gitWithCredentials("tag -f -m 'release version ${releaseVersion}' ${releaseVersion}")

                    // Merge release branch into develop
                    sh "git checkout develop"
                    sh "git merge --no-ff ${env.BRANCH_NAME}"

                    // Delete release branch
                    sh "git branch -d ${env.BRANCH_NAME}"

                    // Checkout tag
                    sh "git checkout ${releaseVersion}"
                }

                stage ('Push changes to Github'){
                    // Push changes and tags
                    gitWithCredentials("push origin master")
                    gitWithCredentials("push origin develop")
                    gitWithCredentials("push origin --tags")
                    gitWithCredentials("push origin --delete ${env.BRANCH_NAME}")
                }

                stage('Push Dogu to registry') {
                    ecoSystem.push("/dogu")
                }

                //Create release on Github
                changelog = ""
                try{
                    stage ('Get Changelog'){
                        changelog = getChangelog(releaseVersion)
                    }
                } catch(Exception e){
                    echo "Failed to read changes in changelog due to error: ${e}"
                    echo "Please manually update github release."
                }
                try{
                    stage ('Add Github-Release'){
                        echo "The description of github release will be: >>>${changelog}<<<"
                        addGithubRelease(releaseVersion, changelog, git)
                    }
                } catch(Exception e) {
                    echo "Release failed due to error: ${e}"
                }
            } else if (gitflow.isPreReleaseBranch()) {
                 // push to registry in prerelease_namespace
                 stage('Push Prerelease Dogu to registry') {
                     ecoSystem.pushPreRelease("/dogu")
                 }
             }
        } finally {
            stage('Clean') {
                ecoSystem.destroy()
            }
        }
    }
}

def runIntegrationTests(EcoSystem ecoSystem) {
    ecoSystem.runCypressIntegrationTests([
            cypressImage         : "cypress/included:13.15.2",
            enableVideo          : params.EnableVideoRecording,
            enableScreenshots    : params.EnableScreenshotRecording
    ])
}

String getChangelog(String releaseVersion){
    start = getChangelogStartIndex(releaseVersion)
    end = getChangelogEndIndex(start)
    output = sh (
            script: "sed '${start},${end}!d' CHANGELOG.md",
            returnStdout: true
    ).trim()
    return output.replace("\"", "").replace("'", "").replace("\\", "").replace("\n", "\\n")
}

int getChangelogStartIndex(String releaseVersion){
    startLineString = "## \\[${releaseVersion}\\]"
    script = "grep -n \"${startLineString}\" CHANGELOG.md | head -1 | sed s/\"^\\([0-9]*\\)[:].*\$\"/\"\\1\"/g"
    output = sh (
            script: script,
            returnStdout: true
    ).trim()
    return (output as int) + 1
}

String getChangelogEndIndex(int start){
    script = "tail -n +${start+1} CHANGELOG.md |grep -n \"^## \\[.*\\]\" | sed s/\"^\\([0-9]*\\)[:].*\$\"/\"\\1\"/g | head -1"
    output = sh (
            script: script,
            returnStdout: true
    ).trim()
    if ((output as String).length() > 0){
        return ((output as int) + start - 1) as String
    }
    return "\$"
}

String getRepositoryName(Git git){
    scmUrl = git.getRepositoryUrl()
    start = scmUrl.lastIndexOf("/")
    repoName = scmUrl.substring(start+1).replace(".git", "")
    return repoName
}

void addGithubRelease(String releaseVersion, String changes, Git git){
    name = getRepositoryName(git);
    echo "Creating github release..."
    withCredentials([usernamePassword(credentialsId: 'cesmarvin', usernameVariable: 'GIT_AUTH_USR', passwordVariable: 'GIT_AUTH_PSW')]) {
        body = "'{\"tag_name\": \"${releaseVersion}\", \"target_commitish\": \"master\", \"name\": \"${releaseVersion}\", \"body\":\"${changes}\"}'"
        apiUrl = "https://api.github.com/repos/cloudogu/${name}/releases"
        flags = "--request POST --data ${body} --header \"Content-Type: application/json\""
        script = "curl -u ${GIT_AUTH_USR}:${GIT_AUTH_PSW} ${flags} ${apiUrl}"
        output = sh (
                script: script,
                returnStdout: true
        ).trim()
        echo output
    }
    echo "Github release created..."
}

boolean isReleaseBranch() {
    return env.BRANCH_NAME.startsWith("release/");
}

String getReleaseVersion() {
    return env.BRANCH_NAME.substring("release/".length());
}

void gitWithCredentials(String command){
    withCredentials([usernamePassword(credentialsId: 'cesmarvin', usernameVariable: 'GIT_AUTH_USR', passwordVariable: 'GIT_AUTH_PSW')]) {
        sh (
                script: "git -c credential.helper=\"!f() { echo username='\$GIT_AUTH_USR'; echo password='\$GIT_AUTH_PSW'; }; f\" " + command,
                returnStdout: true
        )
    }
}

boolean tagExists(String tag){
    withCredentials([usernamePassword(credentialsId: 'cesmarvin', usernameVariable: 'GIT_AUTH_USR', passwordVariable: 'GIT_AUTH_PSW')]) {
        tagFound = sh (
                script: "git -c credential.helper=\"!f() { echo username='\$GIT_AUTH_USR'; echo password='\$GIT_AUTH_PSW'; }; f\" ls-remote origin refs/tags/${tag}",
                returnStdout: true
        ).trim()
        if (tagFound.length() > 0) return true
        return false
    }
}

boolean developHasChanged(String releaseBranchName){
    withCredentials([usernamePassword(credentialsId: 'cesmarvin', usernameVariable: 'GIT_AUTH_USR', passwordVariable: 'GIT_AUTH_PSW')]) {
        diff = sh (
                script: "git log origin/${releaseBranchName}..origin/develop --oneline",
                returnStdout: true
        ).trim()
        if (diff.length() > 0) return true
        return false
    }
}
