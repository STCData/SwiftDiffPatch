import Foundation

fileprivate extension String {
    var lines: [String] {
        return self.split(separator: "\n").map(String.init)
    }
}


public enum PatchCommand {
    case change(Int, Int, [String], [String])
    case add(Int, Int, Int, [String])
    case delete(Int, Int, Int, [String])
    
    func addingLines(orig: [String], out: [String]) -> PatchCommand{
        switch self {
        case .change(let origStart, let outStart, let origLines, let outLines):
            return .change(origStart, outStart, origLines + orig, outLines + out)
        case .add(let origStart, let outStart, let outEnd, let outLines):
            return .add(origStart, outStart, outEnd, outLines + out)
        case .delete(let origStart, let origEnd, let outStart, let origLines):
            return .delete(origStart, origEnd, outStart, origLines + orig)
        }
    }

}

extension PatchCommand: Equatable {
    
}


enum PatchError: Error {
    case lineNumberNotFound
    case textNotFound
}


public struct SwiftDiffPatch {
    public static func parse(_ patch: String) -> [PatchCommand]? {
        // Define a regular expression to match patch lines
        let pattern = #"^(\d+)(?:,(\d+))?([acd])(\d+)?(?:,(\d+))? *$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // Split the patch into lines
        let lines = patch.components(separatedBy: .newlines)
        
        // Iterate over the patch lines and parse each command
        var commands: [PatchCommand] = []
    
        var originalLines = [String]()
        var outputLines = [String]()

        func addLinesToLastCommand() {
            guard let last = commands.last else { return }
            commands[commands.count-1] = last.addingLines(orig: originalLines, out: outputLines)
        }

        for line in lines {
            if line.hasPrefix("<") {
                originalLines.append(line.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines))
                continue
            }
            if line.hasPrefix(">") {
                outputLines.append(line.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines))
                continue
            }

            if let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                guard match.range(at: 1).location != NSNotFound else {
                    continue
                }
                addLinesToLastCommand()
                originalLines.removeAll()
                outputLines.removeAll()
                
                let originalStart = Int((line as NSString).substring(with: match.range(at: 1)))!
                
                let originalEndMatch = match.range(at: 2).location != NSNotFound
                let originalEnd = originalEndMatch ? Int((line as NSString).substring(with: match.range(at: 2)))! : originalStart
                
                let commandTypeMatch = match.range(at: 3).location != NSNotFound
                let commandType = commandTypeMatch ? (line as NSString).substring(with: match.range(at: 3)) : ""
                
                let outputStartMatch = match.range(at: 4).location != NSNotFound
                let outputStart = outputStartMatch ? Int((line as NSString).substring(with: match.range(at: 4)))! : originalStart
                
                let outputEndMatch = match.range(at: 5).location != NSNotFound
                let outputEnd = outputEndMatch ? Int((line as NSString).substring(with: match.range(at: 5)))! : outputStart
                
                
                
                // Parse the command based on its type
                switch commandType {
                case "c":
                    // Change command
                    commands.append(.change(originalStart, outputStart, [], []))
                case "a":
                    // Add command
                    commands.append(.add(originalStart, outputStart, outputEnd, []))
                case "d":
                    // Delete command
                    commands.append(.delete(originalStart, originalEnd, outputStart, []))
                default:
                    continue
                }
            }
        }
        addLinesToLastCommand()
        return commands
    }

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
                originalLines.insert(contentsOf: output, at: start)
            case let .delete(start, end, _, _):
                guard start < originalLines.count && end < originalLines.count else {
                    throw PatchError.lineNumberNotFound
                }
                originalLines.removeSubrange(start...end)
            }
        }
        
        return originalLines.joined(separator: "\n")
    }


    
}
