import FierceNerdsCodeActions.Scaffold
import FierceNerdsCodeActions.Addon.System.FilePath.Fun
import Mathlib.Tactic.SlimCheck

namespace System.FilePath

open FierceNerdsUtil

def rootDir := "/home/username/project"
def testPath1 := "/home/username/project/FierceNerdsCodeActions/FilePath.lean"
def testName1 := `FierceNerdsCodeActions.FilePath

example : moduleNameOfFileName rootDir testPath1 = testName1 := by slim_check
