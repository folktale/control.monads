# # Specification for monad operations

/** ^
 * Copyright (c) 2013 Quildreen Motta
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

spec = (require 'hifive')!
{for-all, data: {Any:BigAny, Array:BigArray, Int}, sized} = require 'claire'
{ok, throws} = require 'assert'

_  = require '../../src'
{StaticIdentity:SId, Identity:Id} = require './identity'

Any  = sized (-> 10), BigAny
List = (a) -> sized (-> 10), BigArray(a)

module.exports = spec 'Monadic Ops' (o, spec) ->

  o 'concat(a, b) <=> a.concat(b)' do
     for-all(List(Any), List(Any)).satisfy (a, b) ->
       _.concat(new Id(a))(new Id(b)).is-equal new Id(a ++ b)
     .as-test!


  o 'empty(a) <=> a.empty()' do
     for-all(Any).satisfy (a) ->
       _.empty(new Id(a)).is-equal SId.empty() and \
       _.empty(new SId(a)).is-equal SId.empty()
     .as-test!

  o 'map(f, a) <=> a.map(f)' do
     for-all(Any).satisfy (a) ->
       _.map(-> [it, it])(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'of(a, f) <=> f.of(a)' do
     for-all(Any).satisfy (a) ->
       _.of(a)(new Id(a)).is-equal new Id(a) and \
       _.of(a)(SId).is-equal new SId(a)
     .as-test!

  o 'ap(a, b) <=> a.ap(b)' do
     for-all(Any).satisfy (a) ->
       _.ap(new Id(-> [it, it]))(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'chain(f, a) <=> a.chain(f)' do
     for-all(Any).satisfy (a) ->
       _.chain(-> new Id([it, it]))(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'sequence(m, ms) should chain monads in ms and collect results.' do
     for-all(Int, Int, Int).satisfy (a, b, c) ->
       _.sequence(SId, [new Id(a), new Id(b), new Id(c)]).is-equal new Id([a,b,c])
     .as-test!


