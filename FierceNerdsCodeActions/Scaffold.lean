import FierceNerdsUtil.Scaffold
import Lean.Data.Lsp.Basic

namespace FierceNerdsCodeActions

open Lean.Lsp
open FierceNerdsUtil

namespace Scaffold

-- single line doesn't work for some reason
deriving instance Repr for Position
deriving instance Repr for Range
deriving instance Repr for Location

deriving instance Repr for IO.Error
