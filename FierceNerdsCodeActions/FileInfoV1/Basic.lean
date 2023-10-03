import FierceNerdsCodeActions.Scaffold
import Init.System.FilePath
import FierceNerdsCodeActions.FileContent.Basic
import Lean.Server.Snapshots

namespace FierceNerdsCodeActions

open Lean System IO Server Snapshots

abbrev CmdV1 := Snapshot

def Cmd : Type u := sorry

structure FileInfoV1 where
  path : FilePath
  content : FileContent
  cmds : Array Cmd
-- deriving Repr, Inhabited
