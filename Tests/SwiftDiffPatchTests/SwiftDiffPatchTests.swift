import XCTest
@testable import SwiftDiffPatch

final class PatchedTests: XCTestCase {
    func testParsePatchCommands() {
        let patch = """
        2c2
        < This is the old line.
        ---
        > This is the new line.
        
        1a1,3
        > This is a new line.
        > This is another new line.
        > And one more new line.
        
        5,6d4
        < This line will be deleted.
        < This line will also be deleted.
        """

        guard let patchCommands = SwiftDiffPatch.parse(patch) else {
            XCTFail("Failed to parse patch")
            return
        }

        XCTAssertEqual(patchCommands.count, 3)

        XCTAssertEqual(patchCommands[0], .change(2, 2, ["This is the old line."], ["This is the new line."]))

        XCTAssertEqual(patchCommands[1], .add(1, 1, 3, ["This is a new line.", "This is another new line.", "And one more new line."]))

        XCTAssertEqual(patchCommands[2], .delete(5, 6, 4, ["This line will be deleted.", "This line will also be deleted."]))
    }

    func testPatched() {
        let original = """
        a
        b
        c
        d
        e
        f
        """
        let patch = """
1c1
< a
---
> aa
3c3
< c
---
> cc
"""
        
        let patched = original.patched(with: patch)
        
        let expected = """
        aa
        b
        cc
        d
        e
        f
        """
        XCTAssertEqual(patched, expected)
    }
    
    func testInvalidPatch2() {
        let original = "Hello, world!"
        let invalidPatch = """
            3c3
            < Hello
            ---
            > Hi
            """

        let result = original.patched(with: invalidPatch)
        XCTAssertNil(result)
    }

    
    /*func testInvalidPatch() {
        let original = "Hello, world!"
        let patch = "invalid patch"
        
        let patched = original.patched(with: patch)
        
        XCTAssertNil(patched)
    }*/
    
    func testNoChangesPatch() {
        let original = "Hello, world!"
        let patch = ""
        
        let patched = original.patched(with: patch)
        
        XCTAssertEqual(patched, original)
    }

}


