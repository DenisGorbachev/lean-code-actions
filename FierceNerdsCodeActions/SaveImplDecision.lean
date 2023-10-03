import FierceNerdsCodeActions.Scaffold

namespace FierceNerdsCodeActions

open Lean
open FierceNerdsUtil

structure SaveImplDecision where
  name : String
  isRightWay : Bool
  notes : Thoughts := []
deriving Repr, Inhabited

namespace SaveImplDecision

def o1 : SaveImplDecision where
  name := "Convert Expr to String"
  isRightWay := true
  notes := [
    "Frontend.State does not save the commands themselves, so there is no way to write the file back" ♢ [
      "Only the snapshots have this information"
    ]
  ]

def o2 : SaveImplDecision where
  name := "Read snapshots, determine location, use string operations"
  isRightWay := false

def o3 : SaveImplDecision where
  name := "Implement our own parsing system, write the file using a combined approach"
  isRightWay := true
  notes := [
    "Implementation" ♢ [
      "Save each command text before parsing it",
      "Associate the Lsp.Range with each command",
      "Change the command",
      "Update the file content"
    ]
  ]
