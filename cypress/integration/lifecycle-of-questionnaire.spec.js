describe('Lifecycle of a questionnaire', () => {
  const goToYourDashboard = () => {
    cy.contains('Go to your Dashboard').click()
  }

  before(() => {
    cy.request('/test/questionnaire/delete-all')
  })

  const questions = [
    'How could this person become a better pair?',
    'How has this person contributed to the success of their client?',
    'How has this person helped individuals at 8th Light improve?',
  ]

  it('for Ben Wyatt', () => {
    cy.loginAs('Ben Wyatt')

    cy.contains("Ask for advice").click()

    cy.contains('April Ludgate').parent().click()

    cy.get('.context-of-advice').type('Something')

    questions.forEach((question) => {
      cy.contains(question).click();
    })

    cy.get('#advisors').contains('Ann Perkins').parent().click()
    cy.get('#advisors').contains('Donna Meagle').parent().click()

    cy.contains('Ask for advice').click()
  })

  it('can be seen in Bens dashboard', () => {
    cy.loginAs('Ben Wyatt')

    goToYourDashboard()

    cy.contains('Status of your own request for advice')
  })

  it('can be seen in Aprils dashboard', () => {
    cy.loginAs('April Ludgate')

    goToYourDashboard()

    cy.contains('Advice for Ben Wyatt');
  })

  it('is filled out by Donna Meagle', () => {
    cy.loginAs('Donna Meagle')

    goToYourDashboard()

    cy.openQuestionnaireFor('Ben Wyatt');

    cy.answerWith(["Something", "Important", "To Say"])

    cy.get('button').contains('Submit your advice').click()
  })

  it('is filled out by Ann Perkins', () => {
    cy.loginAs('Ann Perkins')

    goToYourDashboard()

    cy.openQuestionnaireFor('Ben Wyatt');

    cy. answerWith(["Other", "Key", "Thing"])

    cy.get('button').contains('Submit your advice').click()
  })

  it('is presented by April Ludgate', () => {
    cy.loginAs('April Ludgate')

    goToYourDashboard()

    cy.contains('.groups-advice', 'Ben Wyatt').contains('Present').click()

    questions.forEach((question) => {
      cy.contains(question)
    })
  })

  it('is deleted afterwards by April Ludgate', () => {
    cy.loginAs('April Ludgate')

    goToYourDashboard()

    cy.contains('.groups-advice', 'Ben Wyatt').contains('Delete').click()
    cy.contains('Yes').click()

    cy.contains('Ben Wyatt').should('not.exist')
  })
})
