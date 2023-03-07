//
//  File.swift
//
//
//  Created by standard on 3/7/23.
//

import Foundation

private func prependedLines(lines: [String], prefix: String, spaces: Int = 1) -> String {
    return lines.map {
        prefix + String(repeating: " ", count: spaces) + $0
    }.joined(separator: "\n")
}

extension PatchCommand: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .change(origStart, outStart, origLines, outLines):
            return "\(origStart)c\(outStart)\n" +
                prependedLines(lines: origLines, prefix: "<") + "\n---\n" +
                prependedLines(lines: outLines, prefix: ">")
        case let .add(origStart, outStart, outEnd, outLines):
            return "\(origStart)a\(outStart),\(outEnd)\n" +
                prependedLines(lines: outLines, prefix: ">")
        case let .delete(origStart, origEnd, outStart, origLines):
            return "\(origStart),\(origEnd)d\(outStart)\n" +
                prependedLines(lines: origLines, prefix: "<")
        }
    }
}

public extension Array where Element == PatchCommand {
    var description: String {
        map {
            $0.description
        }.joined(separator: "\n")
    }
}
