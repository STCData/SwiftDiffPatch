import Foundation

fileprivate extension String {
    var lines: [String] {
        return self.split(separator: "\n").map(String.init)
    }
}



public struct SwiftDiffPatch {

    static func apply(_ patch: String, original: String) throws -> String {
        guard let patchCommands = SwiftDiffPatch.parse(patch) else {
            throw PatchError.lineNumberNotFound
        }
        
        var originalLines = original.components(separatedBy: "\n")
        for command in patchCommands {
            switch command {
            case let .change(start, _, _, output):
                guard start < originalLines.count else {
                    throw PatchError.lineNumberNotFound
                }
                originalLines.replaceSubrange(start-1...start-1, with: output)
            case let .add(start, _, _, output):
                guard start <= originalLines.count else {
                    throw PatchError.lineNumberNotFound
                }
                originalLines.insert(contentsOf: output, at: start-1)
            case let .delete(start, end, _, _):
                guard start-1 < originalLines.count && end-1 < originalLines.count else {
                    throw PatchError.lineNumberNotFound
                }
                originalLines.removeSubrange(start-1...end-1)
            }
        }
        
        return originalLines.joined(separator: "\n")
    }


    
}
