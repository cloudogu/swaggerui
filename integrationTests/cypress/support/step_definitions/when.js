const {When} = require("cypress-cucumber-preprocessor/steps");
const env = require("@cloudogu/dogu-integration-test-library/lib/environment_variables");

When("the swaggerui dogu is visited", function () {
    cy.visit("/" + env.GetDoguName(), {failOnStatusCode: false})
});

