import Lean.Server.CodeActions
import Std.CodeAction

namespace FierceNerds.CodeActions

open Lean Server Lsp

namespace HelloWorld

@[code_action_provider] def dummyCodeActionProvider : CodeActionProvider := fun params snap => do
  let dummy_action : LazyCodeAction := {
    eager := {
      title := "Dummy",
      edit? := .some {
        documentChanges := #[]
      }
    }
  }
  return #[dummy_action]

@[code_action_provider] def helloWorldCodeActionProvider : CodeActionProvider := fun params snap => do
  let { textDocument, range, .. } := params
  let { uri } := textDocument
  let textDocument : VersionedTextDocumentIdentifier := { uri }
  -- let range : Range := ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  let hello_world_action : LazyCodeAction := {
    eager := {
      title := "Hello world",
      edit? := .some {
        changes := .ofList [
            ⟨uri, #[
              {
                range
                newText := "Hello world"
              }
            ]⟩
         ]
        }
      }
    }
  return #[hello_world_action]

def test : Nat → Nat := sorry

inductive ThoughtTmp where
  | mk : String → List ThoughtTmp → ThoughtTmp
deriving Repr, Inhabited

instance : Coe String ThoughtTmp := ⟨(.mk · [])⟩

def todo : List ThoughtTmp := [
  ⟨
    "Ensure that helloWorldCodeActionProvider returns an action that inserts 'Hello world'",
    [
      "Try adding annotations",
      "Try adding `changes` instead of `documentChanges`",
      "Try tracing the changes"
    ]
  ⟩
]
