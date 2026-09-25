
@Library([
  'pipe-build-lib',
  'ces-build-lib',
  'dogu-build-lib'
]) _

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "swaggerui",
    updateSubmodules    : false,
    shellScripts        : "./resources/startup.sh",
    dependencies        : ["nginx"],
    runIntegrationTests : true,
    // Default cypress/included:13.17.0 bundles Node 22.13, too old for
    // cosmiconfig@10 (pulled in by @badeball/cypress-cucumber-preprocessor@28,
    // required for cypress@16 compatibility). Override to an image with a
    // newer bundled Node until the shared pipeline lib's own default catches up.
    cypressImage        : "cypress/included:16.0.0",
])

pipe.setBuildProperties()
pipe.addDefaultStages()
pipe.run()