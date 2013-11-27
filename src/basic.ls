# # Basic monad operations

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


# ## Function: sequence
#
# Evaluates each action in sequence, left to right, collecting the
# results.
#  
# + type: (Monad m) => m -> [m a] -> m [a]
export sequence = (m, ms) --> return ms.reduce-right perform, m.of []
                            # where:
                              function perform(m1, m2) => do
                                                          x  <- m1.chain
                                                          xs <- m2.chain
                                                          xs.push x
                                                          m.of xs


# ## Function: map-m
#
# Evaluates each action in sequence, left to right, collecting the
# results mapped by the given function.
#
# Equivalent to `compose(sequence, map(f))`.
#
# + type: (Monad m) => m -> (a -> m b) -> [m a] -> m [b]
export map-m = (m, f, ms) --> return ms.reduce-right perform, m.of []
                            # where:
                              function perform(m1, m2) => do
                                                          x  <- m1.chain
                                                          xs <- m2.chain
                                                          xs.push (f x)
                                                          m.of xs


# ## Function: compose
#
# Left-to-right Kleisli composition of monads.
#  
# + type: (Monad m) => (a -> m b) -> (b -> m c) -> a -> m c
export compose = (f, g, a) --> (f a).chain g


# ## Function: right-compose
#
# Right-to-left Kleisli composition of monads.
#
# + type: (Monad m) => (b -> m c) -> (a -> m b) -> a -> m c
export right-compose = (g, f, a) --> (f a).chain g


# ## Function: join
#
# Removes one level of a nested monad.
#
# + type: (Monad m) => m (m a) -> m a
export join = (m) -> m.chain (a) -> a

