import Lake
open Lake DSL

-- mathlib brings std, aesop, doc-gen4, Qq as dependencies
require mathlib from git "https://github.com/leanprover-community/mathlib4" @ "e70f8800f70f89b102ad7469128ace674213e1e5"

meta if get_config? doc = some "on" then -- do not download and build doc-gen4 by default
require «doc-gen4» from git "https://github.com/leanprover/doc-gen4" @ "main"

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
