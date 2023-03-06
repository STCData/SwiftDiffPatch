[![Swift](https://github.com/STCData/SwiftDiffPatch/actions/workflows/swift.yml/badge.svg)](https://github.com/STCData/SwiftDiffPatch/actions/workflows/swift.yml)

# SwiftDiffPatch

```
import SwiftDiffPatch

let patch = """
    1c1
    < Hello
    ---
    > Hi
    """
    
let original = """
    Hello
    World
    """

let patched = original.patched(with: patch)

print(patched ?? "Unable to apply patch.")
```

