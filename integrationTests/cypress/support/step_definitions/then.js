const {Then} = require("cypress-cucumber-preprocessor/steps");

Then("the page is shown without requiring authentication", function () {
    cy.url().should('contain', Cypress.config().baseUrl)
    cy.get('.download-url-button').contains('Explore')
});

Then("the warp menu exists", function () {
    cy.get('#warp-menu-warpbtn').should('exist')
});

