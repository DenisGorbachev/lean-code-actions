import FierceNerdsCodeActions.Scaffold
import Init.System.FilePath
import FierceNerdsUtil.String.Coe
import FierceNerdsUtil.Array.Fun

namespace System.FilePath

open Lean
open FierceNerdsUtil

def pathSeparatorLength := pathSeparator.toString.length

def getLeanFilePaths (dir : FilePath) : IO (Array FilePath) :=
  dir.walkDir (fun path => do pure (path.toString.endsWith ".lean"))

def moduleNameOfFileName (rootDir : FilePath) (path : FilePath) : Name :=
  let pathRelative := path.toString.drop (rootDir.toString.length + pathSeparatorLength)
  let components := pathRelative |>.splitOn pathSeparator |>.toArray
  let components := Array.modifyLast components (·.replace ".lean" "")
  components.foldl Name.mkStr Name.anonymous

def moduleNameOfRawFileName (rootDir : FilePath) (path : FilePath) : IO Name := do
  let path ← IO.FS.realPath path
  let path := path.normalize
  pure $ moduleNameOfFileName rootDir path
  