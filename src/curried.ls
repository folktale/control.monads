# # Curried versions of monadic methods

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


# ## Function: concat
#
# Concatenates two semigroups.
#  
# + type: (Semigroup s) => s(a) -> s(a) -> s(a)
export concat = (a, b) --> a ++ b


# ## Function: empty
#
# Constructs a new empty semigroup.
#
# + type: (Semigroup s) => s -> s(a)
export empty = (a) ->
  | a.empty   => a.empty!
  | otherwise => a@@empty!


# ## Function: map
#
# Maps over a Functor instance.
#
# + type: (Functor f) => (a -> b) -> f(a) -> f(b)
export map = (f, a) --> a.map f


# ## Function: of_
#
# Constructs a new applicative instance.
#
# + type: (Applicative f) => a -> f(a)
export of_ = (a, f) -->
  | f.of => f.of a
  | _    => f@@of a


# ## Function: ap
#
# Applies the function of an Applicative to the value of another
# Applicative.
#
# + type: (Applicative f) => f(a -> b) -> f(a) -> f(b)
export ap = (a, b) --> a.ap b


# ## Function: chain
#
# Extracts the value of a monad.
#  
# + type: (Chain c) => (a -> c(b)) -> c(a) -> c(b)
export chain = (f, a) --> a.chain f



