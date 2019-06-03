// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
Cypress.Commands.add("loginAs", (name) => {
    cy.visit('/')

    cy.contains(`Login as ${name}`).click()
})

Cypress.Commands.add("answerWith", (answers) => {
    cy.get('.advice-question textarea').each((answerBox, i) => {
      cy.wrap(answerBox).type(answers[i])
    })
})

Cypress.Commands.add("openQuestionnaireFor", (name) => {
    cy.get('.open-advice-requests').contains(name).parent().contains('Give advice now').click()
})


//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })
