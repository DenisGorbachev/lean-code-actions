import FierceNerdsCodeActions.Scaffold
import Lean.Server.References
import FierceNerdsCodeActions.GlobalRefInfoDef
import Lean.Data.Lsp.Internal
import Lean.Elab.Import
import FierceNerdsCodeActions.FilePath.Fun
import FierceNerdsUtil.Array.Fun.Sep

namespace FierceNerdsCodeActions

open Lean Lsp Elab Command
open System
open FilePath
open FierceNerdsUtil

def readwrite (dir : FilePath) : IO Unit :=
  