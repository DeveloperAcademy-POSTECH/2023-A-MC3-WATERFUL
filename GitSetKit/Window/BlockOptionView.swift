//
//  BlockOptionView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/28.
//

import SwiftUI

fileprivate struct BlockTypeObject: Identifiable {
    var title: LocalizedStringKey
    var hint: LocalizedStringKey
    var icon: Image?
    var type: Field.FieldType
    
    var id: Field.FieldType {
        return type
    }
}

fileprivate struct BlockTypeSelectView: View {
    @Binding var selected: Field.FieldType
    @Binding var hint: LocalizedStringKey
    
    @State private var hover: [Field.FieldType : Bool] = [.constant : false, .date : false, .input : false, .option : false]
    
    private var blockTypeObjects: [Field.FieldType : BlockTypeObject] {
        return [
            .option : BlockTypeObject(title: "option_block_type_option", hint: "option_block_type_option_desc", icon: Image(systemName: "square.grid.2x2"), type: .option),
            .input : BlockTypeObject(title: "option_block_type_text", hint: "option_block_type_text_desc", icon: Image(systemName: "text.alignleft"), type: .input),
            .date : BlockTypeObject(title: "option_block_type_date", hint: "option_block_type_date_desc", icon: Image(systemName: "calendar"), type: .date),
            .constant : BlockTypeObject(title: "option_block_type_constant", hint: "option_block_type_constant_desc", type: .constant)
        ]
    }
    
    var body: some View {
        HStack(spacing: 8) {
            makeCell(object: blockTypeObjects[.option]!)
            makeCell(object: blockTypeObjects[.input]!)
            makeCell(object: blockTypeObjects[.date]!)
            Divider()
                .frame(height: 36)
            makeCell(object: blockTypeObjects[.constant]!)
        }
        .onAppear {
            hint = blockTypeObjects[selected]!.hint
        }
        .onChange(of: selected) { newValue in
            hint = blockTypeObjects[selected]!.hint
        }
    }
    
    @ViewBuilder private func makeCell(object: BlockTypeObject) -> some View {
            HStack {
                Spacer()
                if let icon = object.icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
                Text(object.title)
                    .font(.system(size: 16))
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .foregroundColor(selected == object.type ? .accentColor : Colors.Text.primary)
            .background {
                if selected == object.type {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                Colors.Background.selected
                                    .shadow(.inner(color: .accentColor.opacity(0.5), radius: 4, x: 0, y: 2))
                            )
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor, lineWidth: 2)
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Colors.Background.primary)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                        
                        if hover[object.type] ?? false {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.accentColor, lineWidth: 2)
                        }
                    }
                }
            }
            .onTapGesture {
                self.selected = object.type
            }
            .onHover { hover in
                self.hover[object.type] = hover
                self.hint = object.hint
            }
    }
}

struct BlockOptionView: View {
    @Binding var selectedTeam: Team?
    @Binding var selectedField: Field?
    
    @Binding var hint: LocalizedStringKey
    
    @State private var title: String = ""
    @State private var fieldChanged: Bool = false
    
    @State private var blockType: Field.FieldType = .input
    
    var body: some View {
        VStack {
            BlockTypeSelectView(selected: $blockType, hint: $hint)
                .onAppear(perform: {
                    if let selectedField = selectedField {
                        blockType = selectedField.wrappedType
                    }
                    fieldChanged = false
                })
                .onChange(of: self.selectedField) { newValue in
                    if blockType != newValue?.wrappedType {
                        fieldChanged = true
                    }
                    
                    if let selectedField = selectedField {
                        blockType = selectedField.wrappedType
                    }
                }
                .onChange(of: blockType) { newValue in
                    if let selectedField = selectedField, !fieldChanged {
                        let field = PersistenceController.shared.updateField(field: selectedField, type: blockType.rawValue, typeBasedString: "")
                        self.selectedField = nil
                        self.selectedField = field
                        
                    }
                    fieldChanged = false
                }
                .padding(.top, 8)
        }
    }
    //: - Block Option View
}
