#!groovy
@Library([
        'github.com/cloudogu/build-lib-wrapper@develop',
        'ces-build-lib', // versioning handled by Global Trusted Pipeline Libraries in Jenkins
        'dogu-build-lib' // versioning handled by Global Trusted Pipeline Libraries in Jenkins
]) _


// Now call the sharedBuildPipeline function with your custom configuration.
sharedBuildPipeline([
        // Required parameter
        doguName: "swaggerui",

        // Optional parameters – override defaults here
        preBuildAgent       : 'sos',
        buildAgent          : 'sos',
        doguDirectory       : "/dogu",
        namespace           : "official",

        // Credentials and git information
        gitUser             : "cesmarvin",
        committerEmail      : "cesmarvin@cloudogu.com",
        gcloudCredentials   : "gcloud-ces-operations-internal-packer",
        sshCredentials      : "jenkins-gcloud-ces-operations-internal",
        backendUser         : "cesmarvin-setup",
        updateSubmodules    : true,
        shellScripts        : "./resources/startup.sh",
        dependencies        : ["nginx"],
        checkMarkdown       : false,
        runIntegrationTests : true,
        doBatsTests         : false,
        cypressImage        : "cypress/included:13.15.2",
])