
@Library([
  'pipe-build-lib',
  'ces-build-lib',
  'dogu-build-lib'
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
pipe.run()