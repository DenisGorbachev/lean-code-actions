import FierceNerdsCodeActions.Scaffold
import FierceNerdsCodeActions.Addon.System.FilePath.Fun
import FierceNerdsUtil.Array.Fun.Sep

namespace Lean.Elab.Frontend

open Lean System FilePath
open FierceNerdsUtil


/--
Notes:
- Does not print errors (they can be accessed as (state : Frontend.State).commandState.messages)
-/
def loadFile
    (fileName : String)
    (mainModuleName : Name)
    (input : String)
    (opts : Options)
    (trustLevel : UInt32 := 0)
    : IO (Frontend.State) := do
  let inputCtx := Parser.mkInputContext input fileName
  let (header, parserState, messages) ← Parser.parseHeader inputCtx
  let (env, messages) ← processHeader header opts messages inputCtx trustLevel
  let env := env.setMainModule mainModuleName
  let mut commandState := Command.mkState env messages opts
  IO.processCommands inputCtx parserState commandState

def loadFileByName
  (fileName : String)
  (opts : Options)
  (trustLevel : UInt32 := 0)
  : IO (Frontend.State)
:= do
  let mainModuleName ← moduleNameOfFileName fileName .none
  let content ← IO.FS.readFile fileName
  loadFile fileName mainModuleName content opts trustLevel

def loadDir (dir : FilePath) : IO Frontend.State := do
  let paths ← getLeanFilePaths dir
  let imports := paths.map (· |> FilePath.moduleNameOfFileName dir |> (s!"import {·}"))
  let contents := imports.joinWith "\n"
  loadFile "<generated>" default contents default default

