import FierceNerdsCodeActions.Scaffold
import Lean.Server.References
import FierceNerdsCodeActions.FierceNerds.CodeActions.GlobalRefInfoDef_type
import Lean.Data.Lsp.Internal
import Lean.Elab.Import
import FierceNerdsCodeActions.System.FilePath_fun
import FierceNerdsUtil.Array_fun_sep
import FierceNerdsCodeActions.Lean.Elab.Frontend.State

namespace FierceNerds.CodeActions

open Lean Lsp Elab Command Frontend
open System
open FilePath
open FierceNerds Util

namespace MoveDefinition

def printMessages (s : Frontend.State) : IO Unit := do
  for msg in s.commandState.messages.toList do
    IO.print (← msg.toString true)

def findDefinitionAndUsagesV1 (file : FilePath) (name : Name) : IO GlobalRefInfo :=
  -- use ilean files
  -- ensure every module has an ilean facet, and that it's up-to-date
  sorry

-- abbrev M := IO
abbrev M : Type → Type := sorry

inductive MoveDefinitionError where
  | locationNotFound (name : Name)
deriving Repr, Inhabited

instance : ToString MoveDefinitionError where
  toString : MoveDefinitionError → String
    | .locationNotFound name => s!"Could not find a suitable location for '{name}' (must have an equal namespace, must have a superset of opens)"

variable [Monad M]
variable [MonadExceptOf MoveDefinitionError M]

structure FileInfo where
  
deriving Repr, Inhabited

structure Cmd where
  
deriving Repr, Inhabited

variable [LT Cmd]
variable [(a b : Cmd) → Decidable (a < b)]
variable [Coe FilePath FileInfo]
variable [Coe FileInfo (Array Cmd)]
variable [Coe Cmd Import]
variable [Coe Cmd (Array Namespace)] 

def findGoodCmdV1 (name : Name) (empty : Cmd) (cmds : Array Cmd) : M Cmd := do
  let mut good := empty
  for cmd in cmds do
    if good < cmd then
      good := cmd
  return good

def findGoodCmdV2 (name : Name) (current : Cmd) (candidates : Array Cmd) : M Cmd := do
  for candidate in candidates do
    sorry
  throw (.locationNotFound name)

def getDefinitionV1 (file : FilePath) (name : Name) : M sorry := sorry

def findUsages (name : Name) : M (Array FileInfo) := do
  sorry

def updateUsage (target : FilePath) (prev next : Name) : M Unit := do
  sorry

/--
Todo:
- Use async tasks

Notes:
- Don't remove the `source` import command (the `source` may contain commands that modify the Env)
-/
def updateUsages (target : FilePath) (prev next : Name) : M Unit := do
  let usages ← findUsages prev
  for usage in usages do
    updateUsage target prev next
  return ()

def insertAfter (info : FileInfo) (cmd : Cmd) : M Unit := do
  sorry

def save (info : FileInfo) (file : FilePath) : M Unit := do
  sorry

/--
Notes:
- `source` argument is needed because the same name might exist in different files

Todo:
- Support a specific file format:
  - Progressive namespace hierarchy without the end
  - Every namespace contains opens right after the namespace command
- Handle errors after parsing the files
-/
def moveDefinitionV1 (source target : FilePath) (prev next : Name) : M Unit := do
  -- let ⟨definition, usages⟩ ← findDefinitionAndUsagesV1 source prev
  let sourceInfo : FileInfo := ↑source
  let targetInfo : FileInfo := ↑target
  let definition ← getDefinitionV1 source prev
  let empty : Cmd := sorry
  let current : Cmd := sorry
  let cmds : Array Cmd := ↑targetInfo
  let cmd ← findGoodCmdV2 next current cmds
  -- TODO: Ensure the opens match the source opens at current location, or update the names, or add new opens
  insertAfter sourceInfo cmd
  save sourceInfo source
  updateUsages target prev next
  return ()

structure Definition where
deriving Repr, Inhabited

def getModuleV1 (state : Command.State) (path : FilePath) : IO Module := sorry

def getModuleV2 (path : FilePath) : CommandElabM Module := sorry

def getDefinitionV2 (state : Command.State) (name : Name) : IO Definition := sorry

def getScopeV1 (state : Command.State) (name : Name) : IO Scope := sorry

def findGoodScopeV3 (state : Command.State) (target : Module) (d : Definition) : IO Scope := sorry

def saveV2 (state : Frontend.State) : IO Unit := sorry

inductive SaveError where
  | moduleNotFound (name : Name)
deriving Repr, Inhabited

/--
More robust
-/
def saveFromExpr (env : Environment) (moduleName : Name) : EIO SaveError Unit := do
  let some idx := env.getModuleIdx? moduleName | throw (.moduleNotFound moduleName)
  let { header, .. } := env
  sorry

/--
Requres snapshots
-/
def saveFromSnap (state : Frontend.State) : IO Unit := sorry

inductive GeneralError where
  | searchPathNotInitialized
  | ofIOError (e : IO.Error)
deriving Repr, Inhabited

-- def GeneralError.adaptIOError ()

def ensureSearchPathInitialized : EIO GeneralError Unit := do
  let .cons p ps ← searchPathRef.get | throw (.searchPathNotInitialized)

def moveDefinitionV2Core (source target : FilePath) (prev next : Name) : IO Unit := do
  let currentDir ← IO.currentDir
  let stateF ← loadDir currentDir
  let state := stateF.commandState
  let sourceM : Module ← getModuleV1 state source
  let targetM : Module ← getModuleV1 state target
  let definition ← getDefinitionV2 state prev
  let sourceS : Scope ← getScopeV1 state prev
  let targetS : Scope ← findGoodScopeV3 state targetM definition
  -- removeV2 definition sourceS
  -- insertV1 definition targetS
  -- updateUsages target prev next
  saveV2 stateF

def moveDefinitionV2 (source target : FilePath) (prev next : Name) : EIO GeneralError Unit := do
  ensureSearchPathInitialized
  let result := moveDefinitionV2Core source target prev next
  result.toEIO .ofIOError
