//
//  TransparentGroupBox.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/17.
//

import SwiftUI

struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 4) {
            HStack {
                configuration.label
                Spacer()
            }
            configuration.content
                .background(
                    Color.clear
                )
        }
    }
}
