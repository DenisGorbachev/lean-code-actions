import FierceNerdsCodeActions.Scaffold
import Init.System.FilePath
import FierceNerdsCodeActions.FileContent.Basic
import Lean.Server.Snapshots
import Lean.Parser.Types

namespace FierceNerdsCodeActions

open Lean System IO Parser Server Snapshots

structure FileInfoV2 where
  context: InputContext -- assuming that `fileName` contains a full file name (equivalent to `path : FilePath`)
  cmds : Array Snapshot
-- deriving Repr, Inhabited
