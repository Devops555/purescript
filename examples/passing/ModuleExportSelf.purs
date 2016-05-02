module A (module A, module Prelude) where
  import Prelude

  type Foo = Boolean

module Main where
  import Control.Monad.Eff.Console
  import A

  bar :: Foo
  bar = true

  main = do
    logShow (show bar)
    log "Done"
