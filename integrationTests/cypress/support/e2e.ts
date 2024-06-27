// Loads all commands from the dogu integration library into this project
import doguTestLibrary from "@cloudogu/dogu-integration-test-library";

doguTestLibrary.registerCommands()

declare global {
    namespace Cypress {
        interface Chainable {

        }
    }
}
