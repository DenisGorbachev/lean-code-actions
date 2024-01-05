import FierceNerdsCodeActions.Scaffold
import Lean.Server.FileWorker.Utils
import Lean.Server.AsyncList
import Lean.Server.FileWorker
import FierceNerdsUtil.System.FileContent_fun
import Init.System.FilePath

namespace Lean.Server.Snapshots

open Lean Server IO FileWorker
open System FilePath FileContent
open FierceNerds Util

def asElabTask {α} := @EIO.asTask (ε := ElabTaskError) (α := α) (prio := .dedicated)

def compileHeader
  (cancel : CancelToken)
  (opts : Options)
  (inputCtx : Parser.InputContext)
  : EIO ElabTaskError Snapshot
  := do
    cancel.check
    let (stx, mpState, msgLog) ← Parser.parseHeader inputCtx
    let (headerEnv, msgLog) ← Elab.processHeader stx opts msgLog inputCtx
    let cmdState := Elab.Command.mkState headerEnv msgLog opts
    let headerSnap : Snapshot := {
      beginPos := 0
      stx
      mpState
      cmdState
      interactiveDiags := {}
      tacticCache := (← IO.mkRef {})
    }
    return headerSnap

def nextCmdSnap
  (cancel : CancelToken)
  (inputCtx : Parser.InputContext)
  : AsyncElabM (Option Snapshot)
  := do
    cancel.check
    let s ← get
    let .some lastSnap := s.snaps.back? | panic! "empty snapshots"
    if lastSnap.isAtEnd then return none
    let snap ← compileNextCmd inputCtx lastSnap false
    set { s with snaps := s.snaps.push snap }
    return some snap

def unfoldCmdSnaps
  (cancel : CancelToken)
  (inputCtx : Parser.InputContext)
  (header : Snapshot)
  : IO (AsyncList ElabTaskError Snapshot)
  := do
    let task ← asElabTask do AsyncList.unfoldAsync (nextCmdSnap cancel inputCtx) { snaps := #[header] }
    return .cons header $ .delayed task

def loadFile
  (cancel : CancelToken)
  (opts : Options)
  (content : FileContent)
  : IO (AsyncList ElabTaskError Snapshot)
  := do
    let inputCtx : Parser.InputContext := ⟨content, "<generated>", String.toFileMap content⟩
    let headerTask ← EIO.asTask do compileHeader cancel opts inputCtx
    let header : Snapshot := sorry
    unfoldCmdSnaps cancel inputCtx header

def loadDir
  (cancel : CancelToken)
  (opts : Options)
  (dir : FilePath)
  : IO (AsyncList ElabTaskError Snapshot)
  := do
    let content ← getUmbrellaFileContent dir
    loadFile cancel opts content
