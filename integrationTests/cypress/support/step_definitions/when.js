const {When} = require("cypress-cucumber-preprocessor/steps");
const env = require("@cloudogu/dogu-integration-test-library/lib/environment_variables");

When("a person visits fqdn of the swaggerui dogu the Web UI shows up", function () {
    cy.visit("/" + env.GetDoguName(), {failOnStatusCode: false})
});

