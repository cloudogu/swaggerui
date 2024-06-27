import {When} from "@badeball/cypress-cucumber-preprocessor";
import env from "@cloudogu/dogu-integration-test-library/lib/environment_variables"

When("the swaggerui dogu is visited", function () {
    cy.visit("/" + env.GetDoguName(), {failOnStatusCode: false})
});

