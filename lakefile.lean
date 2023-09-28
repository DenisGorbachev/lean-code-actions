import Lake
open Lake DSL

-- FierceNerds.Util brings mathlib, std, aesop, doc-gen4, Qq as dependencies
require FierceNerds.Util from git "https://github.com/fierce-nerds/Util.lean.git" @ "main"

package CodeActions {
  -- add package configuration options here
}

lean_lib CodeActions {
  -- add library configuration options here
}

@[default_target]
lean_exe CodeActionsExe {
  root := `Main
}
