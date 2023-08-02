//
//  InputBlockSettingView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/21.
//

import SwiftUI

struct InputBlockSettingView: View {
    @Binding var field: Field?
    @State var value: String = ""
    @State var typeBasedString: String?
    @State var bindedField: Field?
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                TextEditor(text: $value)
                    .onChange(of: value, perform: { newValue in
                        self.field = PersistenceController.shared.updateField(field: bindedField!, typeBasedString: value)
                    })
                    .foregroundColor(Colors.Text.secondary)
                    .textFieldStyle(.plain)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.Background.tertiary)
                    }
                
                if value.isEmpty {
                    VStack {
                        HStack {
                            Text("input_block_field_text")
                                .foregroundColor(Colors.Text.tertiary)
                                .font(.system(size: 15))
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.leading, 8)
                }
            }
            .padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Colors.Background.secondary)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
        )
        .onAppear {
            bindedField = field
            guard let string = bindedField?.wrappedTypeBasedString else { return }
            value = string
        }
    }
}
