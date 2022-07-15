import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import {terser} from "rollup-plugin-terser";

export default {
  input: "js/app.js",
  output: {
    file: "../priv/static/js/app.js",
    format: "esm"
  },
  plugins: [resolve(), commonjs(), terser()]
};
