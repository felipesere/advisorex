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
//
const people = {
    "Ben Wyatt": "ben@parks.com",
    "April Ludgate": "april@parks.com",
    "Donna Meagle": "donna@parks.com",
    "Ann Perkins": "ann@parks.com"
}

Cypress.Commands.add("loginAs", (name) => {
    cy.visit('/auth/login')

    cy.get('#user_email').type(people[name])
    cy.get('#user_password').type("test")

    cy.contains(`Login`).click()
})

Cypress.Commands.add("answerWith", (answers) => {
    cy.get('textarea').each((answerBox, i) => {
      cy.wrap(answerBox).type(answers[i])
    })
})

Cypress.Commands.add("openQuestionnaireFor", (name) => {
    cy.get('[data-testid=open-advice-requests]').contains(name).parent().contains('Give advice now').click()
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
