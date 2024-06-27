import { defineConfig } from "cypress";

// @ts-ignore
import createBundler from "@bahmutov/cypress-esbuild-preprocessor";
import { addCucumberPreprocessorPlugin } from "@badeball/cypress-cucumber-preprocessor";
import createEsbuildPlugin from "@badeball/cypress-cucumber-preprocessor/esbuild";
import doguTestLibrary from "@cloudogu/dogu-integration-test-library";

async function setupNodeEvents(on, config) {
    // This is required for the preprocessor to be able to generate JSON reports after each run, and more,
    await addCucumberPreprocessorPlugin(on, config);

    on(
        "file:preprocessor",
        createBundler({
            plugins: [createEsbuildPlugin(config)],
        })
    );

    config = doguTestLibrary.configure(config);

    return config;
}

module.exports = defineConfig({
    e2e: {
        baseUrl: "https://192.168.56.10",
        env: {
            "DoguName": "swaggerui",
        },
        retries : {
            runMode: 2,
            openMode: 0
        },
        videoCompression: false,
        specPattern: ["cypress/e2e/**/*.feature"],
        setupNodeEvents,
    },
});

