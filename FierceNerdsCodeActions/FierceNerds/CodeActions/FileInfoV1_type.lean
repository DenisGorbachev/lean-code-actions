import FierceNerdsCodeActions.Scaffold
import Init.System.FilePath
import Lean.Server.Snapshots
import FierceNerdsUtil.System.FileContent_type

namespace FierceNerds.CodeActions

open Lean System IO Server Snapshots

abbrev CmdV1 := Snapshot

def Cmd : Type u := sorry

structure FileInfoV1 where
  path : FilePath
  content : FileContent
  cmds : Array Cmd
-- deriving Repr, Inhabited
