import FierceNerdsCodeActions.Scaffold
import FierceNerdsCodeActions.System.FilePath_fun
import FierceNerdsUtil.System.FileContent_fun
import FierceNerdsUtil.Array_fun_sep

namespace Lean.Elab.Frontend

open Lean System FilePath FileContent
open FierceNerds Util

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
  let content ← getUmbrellaFileContent dir
  loadFile "<generated>" default content default default
