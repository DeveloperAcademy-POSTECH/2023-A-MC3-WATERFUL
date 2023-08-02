//
//  TemplateView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/16.
//

import SwiftUI
import WrappingHStack

// 선택 가능한 Block Cell
fileprivate struct BlockCell: View {
    
    @StateObject var field: Field
    var selected: Bool = false
    
    @State private var editMode: Bool = false
    @State private var title: String = ""
    
    var focus: FocusState<ObjectIdentifier?>.Binding
    
    var onNameChanged: ((_ updatedField: Field) -> Void)? = nil
    
    var body: some View {
        ZStack {
            if editMode {
                TextField("", text: $title)
                    .focused(focus, equals: field.id)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .frame(maxWidth: 84)
                    .onSubmit {
                        saveEditedChange()
                    }
                    .onChange(of: focus.wrappedValue) { newValue in
                        if focus.wrappedValue == nil {
                            saveEditedChange()
                        }
                    }
            } else {
                Text(field.wrappedName)
                    .font(.custom("SourceCodePro-Light", size: 17)) // FIXME: 폰트 적용 안되는 문제
                    .foregroundColor(Color.white)
                    .onTapGesture(count: 2) {
                        editMode = true
                        focus.wrappedValue = field.id
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Colors.Fill.codeBlockB)
                
                if selected {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
            }
        )
        .padding(2)
        .onAppear(perform: {
            self.title = field.name ?? ""
        })
        .onChange(of: field) { newValue in
            self.title = field.name ?? ""
        }
    }
    
    func saveEditedChange() {
        let newField = PersistenceController.shared.updateField(field: field, name: title)
        if let onNameChanged = onNameChanged {
            onNameChanged(newField)
        }
        editMode = false
    }
}

// "git commit -m" 등 선택 불가능한 Cell
fileprivate struct TextCell: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.custom("SourceCodePro-Light", size: 17)) // FIXME: 폰트 적용 안되는 문제
            .foregroundColor(.white)
    }
}

// MARK: - TemplateView
struct TemplateView: View {
    // 선택된 Team
    @Binding var team: Team?
    
    // WrappingHStack에서 사용되는 Data
    // (일반 텍스트와 선택 가능한 Block Cell, Add Button 모두 포함)
    @State private var data: [Any] = []
    
    // 선택된 Field
    @Binding var selected: Field?
    @FocusState private var focus: ObjectIdentifier?
    
    // 데이터 변경 시 ScrollView 및 WrappingHstack을 다시 랜더링하기 위한 변수
    @State private var renderId: UUID = UUID()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        if team != nil {
            VStack {
                // Field(= Block)들을 표시하는 View
                blocksView
                    .padding()
                
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.Fill.codeBG)
            )
            .onChange(of: team) { _ in
                reloadData()
            }
        } else {
            Spacer()
        }
    }
    
    // MARK: - Blocks View
    var blocksView: some View {
        ScrollView {
            // WrappingHStack이 VStack, HStack을 적절히 구분하여 줄바꿈해줄 수 있도록 하려면 ForEach문을 사용해서는 안됨
            WrappingHStack(data, id: \.self, alignment: .leading, spacing: .constant(8), lineSpacing: 4) { d in
                
                if let d = d as? String {
                    // data가 String이고, 값이 '+'이면 추가 버튼
                    if d == "+" {
                        Menu {
                            Button {
                                generateNewField(type: .option)
                            } label: {
                                Label("option_block_type_option", systemImage: "square.grid.2x2")
                            }
                            
                            Button {
                                generateNewField(type: .input)
                            } label: {
                                Label("option_block_type_text", systemImage: "text.alignleft")
                            }
                            
                            Button {
                                generateNewField(type: .date)
                            } label: {
                                Label("option_block_type_date", systemImage: "calendar")
                            }
                            
                            Button {
                                generateNewField(type: .constant)
                            } label: {
                                Text("option_block_type_constant")
                            }

                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(Color.accentColor)
                        )
                        
                    } else {
                        TextCell(text: d)
                    }
                } else if let d = d as? Field {
                    // data가 Field이면 Block으로 표시
                    BlockCell(field: d, selected: selected?.id == d.id, focus: $focus) { updatedField in
                        self.selected = updatedField
                    }
                    .onTapGesture {
                        selected = d
                    }
                    .contextMenu {
                        contextMenuBuilder(d)
                    }
                }
            }
            
        }
        .id(renderId)
        .onTapGesture {
            selected = nil
        }
        .onLoad {
            reloadData()
        }
    }
    //: - Blocks View
    
    // MARK: - Functions
    
    func generateNewField(type: Field.FieldType) {
        let field = Field(context: managedObjectContext)
        field.name = "block_new_field_name".localized
        field.type = type.rawValue
        field.typeBasedString = ""
        
        var fields = self.team!.wrappedFields
        fields.append(field)
        
        team!.fields = NSOrderedSet(array: fields)
        
        PersistenceController.shared.saveContext()
        
        reloadData()
        
        selected = field
    }
    
    func reloadData() {
        guard let fields = team?.wrappedFields else {
            return
        }
        data.removeAll()
        data.append("git commit -m \"")
        for field in fields {
            data.append(field)
        }
        data.append("+")
        data.append("\"")
        
        renderId = UUID()
    }
    //: - Functions
    
    // MARK: Context Menu
    @ViewBuilder
    func contextMenuBuilder(_ field: Field) -> some View {
        if let fields = team!.fields {
            // Move Left Button
            Button(role: .none) {
                let index = fields.index(of: field)
                let indexSet = IndexSet(integer: index)
                let newField = team!.fields?.mutableCopy() as! NSMutableOrderedSet
                newField.moveObjects(at: indexSet, to: index - 1)
                team!.fields = newField
                
                PersistenceController.shared.saveContext()
                
                reloadData()
                
            } label: {
                Label("block_context_move_left", systemImage: "arrow.left")
            }
            .disabled(fields.index(of: field) <= 0)
            
            // Move Right Button
            Button(role: .none) {
                let index = fields.index(of: field)
                let indexSet = IndexSet(integer: index)
                let newField = team!.fields?.mutableCopy() as! NSMutableOrderedSet
                newField.moveObjects(at: indexSet, to: index + 1)
                team!.fields = newField
                
                PersistenceController.shared.saveContext()
                
                reloadData()
                
            } label: {
                Label("block_context_move_right", systemImage: "arrow.right")
            }
            .disabled(fields.index(of: field) >= fields.count - 1)
            
            // Delete Button
            Button(role: .none) {
                // 실제 데이터 삭제
                PersistenceController.shared.deleteField(field)
                
                // 현재 View의 Team에서 Field 삭제
                let index = fields.index(of: field)
                var newField = team!.wrappedFields
                newField.remove(at: index)
                team!.fields = NSOrderedSet(array: newField)
                PersistenceController.shared.saveContext()
                
                // 데이터 다시 로드
                reloadData()
                
            } label: {
                Label("block_context_delete", systemImage: "trash.fill")
            }
        }
    }
    
}
//: - TemplateView


