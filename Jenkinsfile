
@Library([
  'pipe-build-lib@feature/include_multinodeecosystem',
  'ces-build-lib',
  'dogu-build-lib@feature/multinode_ecosystem'
]) _

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "swaggerui",
    updateSubmodules    : true,
    shellScripts        : "./resources/startup.sh",
    dependencies        : ["nginx"],
    runIntegrationTests : true,
])

pipe.setBuildProperties()
pipe.addDefaultStages()

pipe.insertStageAfter("MN-Run Integration Tests","Test: Change Global Admin Group") {
    def ctx = pipe.multiNodeEcoSystem
        ctx.changeGlobalAdminGroup("newAdminGroup")
        ctx.restartDogu("swaggerui", true)

        ctx.runCypressIntegrationTests([
            cypressImage     : "cypress/included:13.16.1",
            enableVideo      : false,
            enableScreenshots: false
        ])
}

pipe.run()