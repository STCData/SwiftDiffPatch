//
//  File.swift
//  
//
//  Created by standard on 3/7/23.
//

import Foundation

fileprivate func prependedLines(lines:[String], prefix:String, spaces:Int = 1) -> String {
    return lines.map {
        prefix + String(repeating: " ", count: spaces) + $0
    }.joined(separator: "\n")
}
extension PatchCommand: CustomStringConvertible {
    public var description: String {
        switch self {
        case .change(let origStart, let outStart, let origLines, let outLines):
            return "\(origStart)c\(outStart)\n" +
             prependedLines(lines: origLines, prefix: "<") + "\n---\n" +
             prependedLines(lines: outLines, prefix: ">")
        case .add(let origStart, let outStart, let outEnd, let outLines):
            return "\(origStart)a\(outStart),\(outEnd)\n" +
             prependedLines(lines: outLines, prefix: ">")
        case .delete(let origStart, let origEnd, let outStart, let origLines):
            return "\(origStart),\(origEnd)d\(outStart)\n" +
             prependedLines(lines: origLines, prefix: "<")
        }
    }
}


extension Array where Element == PatchCommand {
    public var description: String {
        map {
            $0.description
        }.joined(separator: "\n")
    }

}
