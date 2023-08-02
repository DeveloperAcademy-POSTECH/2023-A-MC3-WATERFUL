//
//  String+Extension.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/20.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
