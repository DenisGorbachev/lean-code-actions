import FierceNerdsCodeActions.Scaffold
import Init.System.FilePath
import Lean.Server.Snapshots
import Lean.Parser.Types

namespace FierceNerds.CodeActions

open Lean System IO Parser Server Snapshots

structure FileInfoV2 where
  context: InputContext -- assuming that `fileName` contains a full file name (equivalent to `path : FilePath`)
  cmds : Array Snapshot
-- deriving Repr, Inhabited
