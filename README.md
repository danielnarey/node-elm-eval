# visotype/node-elm-eval

**A promise API for executing Elm function calls in JavaScript (experimental)**

This package includes an Elm port module that wraps
[visotype/elm-eval](https://github.com/visotype/elm-eval) and a Node module
that provides a JavaScript interface to the compiled Elm program. It is
designed for use with the ES2017 async/await syntax.

## Usage

```
const { expr } = require('node-elm-eval');

(async () => {
  try {
    const result = await expr('(+)', 1, 2);
    console.log(result);
  } catch (error) {
    console.log(error.message);
  }
})();

```

## API

### expr(f, ...args)

Returns a promise for the JavaScript value type corresponding to the Elm function's return value.

**f**

*Type: string*

The name of an Elm function. The module name should be included, as in
`'String.length'` or `'List.append'`, but may be omitted for functions in the
Basics module like `'always'` or `'round'`. Operators should be enclosed in
parentheses like `'(+)'` or `'(::)'`.

**args**

Arguments to *f*. Types must correspond to the Elm function's type signature.
Will return a rejected promise if there are too many or too few arguments or
type decoding fails.

### call({ f, args })

Same as `expr`, but takes a call object as its argument.

**f**

*Type: string*

Same as above.

**args**

*Type: array*

Same as with `expr`, but given as an array.

### partialExpr(f, args)

Returns a function that will evaluate to a promise when the missing argument is supplied.

**f**

*Type: string*

Same as above.

**args**

Same as with `expr`, but missing the last (rightmost) argument

### partialCall({ f, args })

Same as `partialExpr`, but takes a call object as its argument.

**f**

*Type: string*

Same as above.

**args**

Same as with `partialExpr`, but given as an array.
