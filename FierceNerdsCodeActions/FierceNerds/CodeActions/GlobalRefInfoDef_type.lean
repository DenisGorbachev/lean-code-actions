import FierceNerdsCodeActions.Scaffold

namespace FierceNerds.CodeActions

open Lean.Lsp
open FierceNerds Util

structure GlobalRefInfo where
  definition : Location
  usages : Array Location
deriving Repr, Inhabited

namespace GlobalRefInfo
