//
//  File.swift
//
//
//  Created by standard on 3/6/23.
//

import Foundation

public extension String {
    func patched(with patch: String) -> String? {
        return try? SwiftDiffPatch.apply(patch, original: self)
    }
}
