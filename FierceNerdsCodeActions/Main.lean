import FierceNerdsUtil.IO_fun_basic
import Init.System.IO
import FierceNerdsCodeActions.Lean.Server.Snapshots
import FierceNerdsCodeActions.FierceNerds.CodeActions_readwrite

open Lean Server Snapshots
open FierceNerds CodeActions

def awaitAll (tasks : Array (BaseIO (Task (Except IO.Error Unit)))) : IO Unit := do
  sorry

def readwrite : List String → IO UInt32
  | dir :: args => do
    let dir := System.FilePath.mk dir
    if ← dir.pathExists then
      let tasks ← readwriteDir dir
      awaitAll tasks
      return 0
    else
      IO.halt 2 [s!"Path to directory required"]
  | nil => IO.halt 2 [s!"Path to directory required"]

def main : List String → IO UInt32
  | subcommand :: args => match subcommand with
    | "readwrite" => readwrite args
    | _ => IO.halt 1 [s!"Unknown subcommand: '{subcommand}'"]
  | nil => IO.halt 1 [s!"Subcommand required"]
