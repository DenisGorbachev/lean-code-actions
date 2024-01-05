import FierceNerdsCodeActions.Scaffold
import FierceNerdsCodeActions.System.FilePath_fun
import Mathlib.Tactic.SlimCheck

namespace System.FilePath

open FierceNerds Util

def rootDir := "/home/username/project"
def testPath1 := "/home/username/project/FierceNerdsCodeActions/FilePath.lean"
def testName1 := `FierceNerdsCodeActions.FilePath

example : moduleNameOfFileName rootDir testPath1 = testName1 := by slim_check
