//
//  CodingUserInfoKey+Extension.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/08/01.
//

import SwiftUI

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum ContextError: Error {
    case NoContextFound
}
