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
 * Basic monad operations.
 *
 * @module lib/basic
 */

// -- Dependencies -----------------------------------------------------
var Lambda = require('core.lambda')


// -- Aliases ----------------------------------------------------------
var curry    = Lambda.curry
var flip     = Lambda.flip
var identity = Lambda.identity


// -- Helpers ----------------------------------------------------------
function raise(e){ throw e }


// -- Implementation ---------------------------------------------------

/**
 * Evaluates each action in sequence, left to right, collecting the results.
 *
 * @method
 * @summary m:Monad[_] => m → Array[m[α]] → m[Array[α]]
 */
exports.sequence = curry(2, sequence)
function sequence(m, ms) {
  return ms.reduce(perform, m.of([]))

  function perform(mr, mx) {
    return mr.chain(function(xs) {
                      return mx.chain(function(x) {
                                        xs.push(x)
                                        return m.of(xs) })})}
}


/**
 * Evaluates each action in sequence, left to right, collecting the results
 * mapped by the given function.
 *
 * Equivalent to `compose(sequence, map(f))`.
 *
 * @method
 * @summary m:Monad[_] => m → (α → m[β]) → Array[α] → m[Array[β]]
 */
exports.mapM = curry(3, mapM)
function mapM(m, f, ms) {
  return sequence(m, ms.map(f))
}


/**
 * Left-to-right Kleisi composition of monads.
 *
 * @method
 * @summary m:Monad[_] => (α → m[β]) → (β → m[γ]) → α → m[γ]
 */
exports.compose = curry(3, compose)
function compose(f, g, a) {
  return f(a).chain(g)
}


/**
 * Right-to-left Kleisi composition of monads.
 *
 * @method
 * @summary m:Monad[_] => (β → m[γ]) → (α → m[β]) → α → m[γ]
 */
exports.rightCompose = flip(exports.compose)


/**
 * Removes one level of nesting for a nested monad.
 *
 * @method
 * @summary m:Monad[_] => m[m[α]] → m[α]
 */
exports.join = join
function join(m) {
  return m.chain(identity)
}


/**
 * Filters the contents of an array with a predicate returning a monad.
 * 
 * @method
 * @summary m:Monad[_] => m → (α → m[Boolean]) → [α] → m[α]
 */
exports.filterM = curry(3, filterM)
function filterM(m, p, xs) {
  return xs.length === 0?  m.of([])
  :      /* otherwise */   p(xs[0]).chain(function(flag) {
                             return filterM(m, p, xs.slice(1)).map(function(ys) {
                                      return flag?    [xs[0]].concat(ys)
                                      :      /* _ */  ys })})
}


/**
 * Promotes a regular binary function to a function over monads.
 *
 * @method
 * @summary m:Monad[_] => (α, β → γ) → m[α] → m[β] → m[γ]
 */
exports.liftM2 = curry(3, liftM2)
function liftM2(f, m1, m2) {
  return m1.chain(function(a) {
                    return m2.map(function(b) {
                                    return f(a, b) })})
}


/**
 * Promotes a regular function of arity N to a function over monads.
 *
 * @method
 * @summary m:Monad[_] => (α₁, α₂, ..., αₙ → β) → Array[m[α₁], m[α₂], ..., m[αₙ]] → m[β]
 */
exports.liftMN = curry(2, liftMN)
function liftMN(f, ms) {
  var len = ms.length

  return len < 0?         raise(new Error('Needs at least a singleton list to liftM.'))
  :      len === 1?       ms[0].map(f)
  :      len === 2?       liftM2(f, ms[0], ms[1])
  :      /* otherwise */  sequence(ms[len - 1], ms).map(function(xs) {
                                                          return f.apply(null, xs) })
}