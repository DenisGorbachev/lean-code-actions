import FierceNerdsCodeActions.Scaffold

namespace FierceNerdsCodeActions

open Lean.Lsp
open FierceNerdsUtil

structure GlobalRefInfo where
  definition : Location
  usages : Array Location
deriving Repr, Inhabited

namespace GlobalRefInfo
