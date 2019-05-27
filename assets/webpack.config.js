const path = require('path');
const glob = require('glob');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  entry: {
      './js/app.js': ['./js/app.js']
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: [/node_modules/, /vendor/],
        use: {
          loader: 'babel-loader'
        }
      },
    ]
  },
  plugins: [
    new CopyWebpackPlugin([{ from: 'static/', to: '../' }])
  ]
});
