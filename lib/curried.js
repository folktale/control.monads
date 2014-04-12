// Copyright (c) 2013-2014 Quildreen Motta <quildreen@gmail.com>
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/**
 * Curried versions of monadic methods
 *
 * @module lib/curried
 */

// -- Dependencies -----------------------------------------------------
var Lambda = require('core.lambda')


// -- Aliases ----------------------------------------------------------
var curry = Lambda.curry


// -- Implementation ---------------------------------------------------

/**
 * Concatenates two semigroups.
 *
 * @method
 * @summary s:Semigroup[_] => s[α] → s[α] → s[α]
 */
exports.concat = curry(2, concat)
function concat(a, b) {
  return a.concat(b)
}


/**
 * Constructs a new empty semigroup.
 *
 * @method
 * @summary s:Semigroup[_] => s → s[α]
 */
exports.empty = empty
function empty(a) {
  return a.empty?         a.empty()
  :      /* otherwise */  a.constructor.empty()
}


/**
 * Maps over a functor instance.
 *
 * @method
 * @summary f:Functor[_] => (α → β) → f[α] → f[β]
 */
exports.map = curry(2, map)
function map(f, a) {
  return a.map(f)
}


/**
 * Constructs a new applicative instance.
 *
 * @method
 * @summary f:Applicative[_] => α → f→ f[α]
 */
exports.of = curry(2, of)
function of(a, f) {
  return f.of?            f.of(a)
  :      /* otherwise */  f.constructor.of(a)
}


/**
 * Applies the function of an Applicative to the value of another Applicative.
 *
 * @method
 * @summary f:Applicative[_] => f[α → β] → f[α] → f[β]
 */
exports.ap = curry(2, ap)
function ap(a, b) {
  return a.ap(b)
}


/**
 * Transforms the value of a monad.
 *
 * @method
 * @summary c:Chain => (α → c[β]) → c[α] → c[β]
 */
exports.chain = curry(2, chain)
function chain(f, a) {
  return a.chain(f)
}