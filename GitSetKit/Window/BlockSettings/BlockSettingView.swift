//
//  BlockSettingView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/16.
//


import SwiftUI

struct BlockSettingView: View {
    @Binding var selected: Field?
    
    @State private var title: String = ""
    
    @State private var renderId: UUID = UUID()
    
    var body: some View {
        VStack {
            if let selected = selected {
                switch selected.wrappedType {
                case .constant:
                    Spacer()
                    
                case .option:
                    OptionBlockSettingView(field: $selected)
                    
                case .input:
                    InputBlockSettingView(field: $selected)
                    
                case .date:
                    DateBlockSettingView(field: $selected)
                }
            } else {
                Spacer()
            }
        }
        .id(renderId)
        .onChange(of: selected) { newValue in
            self.renderId = UUID()
        }
    }
}
