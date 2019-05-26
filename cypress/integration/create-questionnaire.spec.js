describe('Creating a new questionnaire', () => {
  const loginAs = (name) => {
    cy.visit('/')

    cy.contains(`Login as ${name}`).click()
  }

  const goToYourDashboard = () => {
    cy.contains('Go to your Dashboard').click()
  }

  const answerWith = (answers) => {
    cy.get('.advice-question textarea').each((answerBox, i) => {
      cy.wrap(answerBox).type(answers[i])
    })
  }

  const openQuestionnaireFor = (name) => {
    cy.get('.open-advice-requests').contains(name).parent().contains('Give advice now').click()
  }

  before(() => {
    cy.request('/test/questionnaire/delete-all')
  })

  it('for Ben Wyatt', () => {
    loginAs('Ben Wyatt')

    cy.contains("Ask for advice").click()

    cy.contains('April Ludgate').parent().click()

    cy.get('.context-of-advice').type('Something')

    cy.contains('How could this person become a better pair?').click()
    cy.contains('How has this person contributed to the success of their client?').click()
    cy.contains('How has this person helped individuals at 8th Light improve?').click()

    cy.get('#advisors').contains('Ann Perkins').parent().click()
    cy.get('#advisors').contains('Donna Meagle').parent().click()

    cy.contains('Ask for advice').click()
  })

  it('can be seen in Bens dashboard', () => {
    loginAs('Ben Wyatt')

    goToYourDashboard()

    cy.contains('Status of your own request for advice')
  })

  it('can be seen in Aprils dashboard', () => {
    loginAs('April Ludgate')

    goToYourDashboard()

    cy.contains('Advice for Ben Wyatt');
  })

  it('is filled out by Donna Meagle', () => {
    loginAs('Donna Meagle')

    goToYourDashboard()

    openQuestionnaireFor('Ben Wyatt');

    answerWith(["Something", "Important", "To Say"])

    cy.get('button').contains('Submit your advice').click()
  })

  it('is filled out by Ann Perkins', () => {
    loginAs('Ann Perkins')

    goToYourDashboard()

    openQuestionnaireFor('Ben Wyatt');

    answerWith(["Other", "Key", "Thing"])

    cy.get('button').contains('Submit your advice').click()
  })
})
