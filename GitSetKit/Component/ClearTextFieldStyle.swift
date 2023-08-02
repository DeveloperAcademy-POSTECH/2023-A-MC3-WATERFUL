//
//  ClearTextFieldStyle.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/17.
//

import SwiftUI

struct ClearTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            configuration.body
                .textFieldStyle(.plain)
        }
    }
    
}
