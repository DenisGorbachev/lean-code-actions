import FierceNerdsCodeActions.Scaffold
import Lean.Server.References
import FierceNerdsCodeActions.FierceNerds.CodeActions.GlobalRefInfoDef_type
import Lean.Data.Lsp.Internal
import Lean.Elab.Import
import FierceNerdsCodeActions.System.FilePath_fun
import FierceNerdsUtil.Array_fun_sep
import FierceNerdsCodeActions.Lean.Server.Snapshots

namespace FierceNerds.CodeActions

open Lean Lsp Elab Command Server Snapshots FileWorker
open System FilePath
open FierceNerds Util

def readwriteFile (file : FilePath) : IO Unit := do
  let cancel ← CancelToken.new
  return sorry
  -- let result ← loadDir cancel default dir

def readwriteDir (dir : FilePath) : IO (Array (BaseIO (Task (Except IO.Error Unit)))) := do
  let paths ← getLeanFilePaths dir
  return paths.map (fun path => IO.asTask $ readwriteFile path)
