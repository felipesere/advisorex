import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";

export default {
  input: "js/app.js",
  output: {
    file: "../priv/static/js/app.js",
    format: "cjs"
  },
  plugins: [resolve(), commonjs()]
};
