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
