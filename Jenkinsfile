
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
pipe.run()