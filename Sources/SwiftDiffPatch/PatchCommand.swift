//
//  File.swift
//
//
//  Created by standard on 3/7/23.
//

import Foundation

public enum PatchCommand {
    case change(Int, Int, [String], [String])
    case add(Int, Int, Int, [String])
    case delete(Int, Int, Int, [String])

    func addingLines(orig: [String], out: [String]) -> PatchCommand {
        switch self {
        case let .change(origStart, outStart, origLines, outLines):
            return .change(origStart, outStart, origLines + orig, outLines + out)
        case let .add(origStart, outStart, outEnd, outLines):
            return .add(origStart, outStart, outEnd, outLines + out)
        case let .delete(origStart, origEnd, outStart, origLines):
            return .delete(origStart, origEnd, outStart, origLines + orig)
        }
    }
}

extension PatchCommand: Equatable {}
