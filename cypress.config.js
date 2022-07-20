const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
     setupNodeEvents(on, config) {
      require("cypress-fail-fast/plugin")(on, config);
      return config;
    },
    baseUrl: "http://localhost:4000",
    video: false,
    supportFile: "cypress/support/index.js"
  }
})
