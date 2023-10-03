import Lake
open Lake DSL

-- FierceNerdsUtil brings mathlib, std, aesop, doc-gen4, Qq as dependencies
require FierceNerdsUtil from git "https://github.com/fierce-nerds/Util.lean.git" @ "main"

package FierceNerdsCodeActions {
  -- add package configuration options here
}

lean_lib FierceNerdsCodeActions {
  -- add library configuration options here
}

@[default_target]
lean_exe FierceNerdsCodeActionsMain {
  root := `FierceNerdsCodeActions.Main
  exeName := "fnca"
}
