#!groovy
@Library(['github.com/cloudogu/dogu-build-lib@ff65ba3', 'github.com/cloudogu/zalenium-build-lib@30923630']) _
import com.cloudogu.ces.dogubuildlib.*

node('vagrant') {

    timestamps{
        properties([
                // Keep only the last x builds to preserve space
                buildDiscarder(logRotator(numToKeepStr: '10')),
                // Don't run concurrent builds for a branch, because they use the same workspace directory
                disableConcurrentBuilds()
        ])

        EcoSystem ecoSystem = new EcoSystem(this, "gcloud-ces-operations-internal-packer", "jenkins-gcloud-ces-operations-internal")

        stage('Checkout') {
            checkout scm
            sh 'git submodule update --init'
        }

        stage('Lint') {
            lintDockerfile()
        }

        try {

            stage('Provision') {
                ecoSystem.provision("/dogu")
            }

            stage('Setup') {
                ecoSystem.loginBackend('cesmarvin-setup')
                ecoSystem.setup()

            }

            stage('Build') {
                ecoSystem.build("/dogu")
            }

            stage('Verify') {
                ecoSystem.verify("/dogu")
            }

            stage('Integration Tests') {

                String externalIP = ecoSystem.externalIP

                if (fileExists('integrationTests/it-results.xml')) {
                    sh 'rm -f integrationTests/it-results.xml'
                }

                timeout(time: 15, unit: 'MINUTES') {

                    try {

                        withZalenium { zaleniumIp ->

                            dir('integrationTests') {

                                docker.image('node:10.19.0-stretch').inside("-e WEBDRIVER=remote -e CES_FQDN=${externalIP} -e SELENIUM_BROWSER=chrome -e SELENIUM_REMOTE_URL=http://${zaleniumIp}:4444/wd/hub") {
                                    sh 'yarn install'
                                    sh 'yarn run ci-test'
                                }

                            }

                        }
                    } finally {
                        // archive test results
                        junit allowEmptyResults: true, testResults: 'integrationTests/it-results.xml'
                    }
                }
            }

        } finally {
            stage('Clean') {
                ecoSystem.destroy()
            }
        }
    }
}