//
//  NewOptionBlockSettingView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/08/01.
//

import SwiftUI
import WrappingHStack

struct OptionBlockCell: View {
    var option: Option
    
    @Binding var selected: Option?
    
    var body: some View {
        VStack(spacing: 4) {
            if let value = option.value, let shortDesc = option.shortDesc {
                HStack {
                    Spacer()
                    Text(value)
                        .font(.body.bold())
                        .lineLimit(1)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(shortDesc)
                        .font(.system(size: 11))
                        .foregroundColor(Colors.Text.secondary)
                        .lineLimit(1)
                    Spacer()
                }
            }
        }
        .padding(8)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.Background.primary)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                if selected == option {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
            }
        )
    }
}

struct OptionBlockSettingView: View {
    @Binding var field: Field?
    
    @State private var selected: Option? = nil
    
    @State private var renderId: UUID = UUID()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        if let field = field {
            VStack(spacing: 0) {
                if field.wrappedOptions.isEmpty {
                    VStack {
                        Spacer()
                        Text("option_block_field_empty")
                            .foregroundColor(Colors.Text.secondary)
                        Spacer()
                    }
                    .padding(.top, 8)
                } else {
                    ScrollView {
                        let item = GridItem(.adaptive(minimum: 120, maximum: 180), spacing: 8)
                        let column = [item]
                        LazyVGrid(columns: column, alignment: .leading, spacing: 8) {
                            ForEach(field.wrappedOptions) { option in
                                OptionBlockCell(option: option, selected: $selected)
                                    .onTapGesture(count: 2) {
                                        selected = option
                                        dialogObject = option
                                        dialogValue = option.value ?? ""
                                        dialogDesc = option.shortDesc ?? ""
                                        showOptionDialog = true
                                    }
                                    .onTapGesture {
                                        selected = option
                                    }
                            }
                            .id(renderId)
                        }
                        .padding()
                    }
                    .onTapGesture {
                        selected = nil
                    }
                }
                
                Divider()
                
                toolbar
            }
            .background(Colors.Background.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
        }
    }
    
    @State private var dialogObject: Option?
    @State private var showOptionDialog: Bool = false
    @State private var dialogValue: String = ""
    @State private var dialogDesc: String = ""
    
    var toolbar: some View {
        HStack(spacing: 4) {
            Button {
                showOptionDialog = true
                
                renderId = UUID()
                
            } label: {
                Image(systemName: "plus")
            }
            .buttonStyle(.plain)
            .frame(width: 24, height: 24)
            .alert("option_block_field_new", isPresented: $showOptionDialog) {
                TextField("option_block_field_new_value", text: $dialogValue)
                TextField("option_block_field_new_desc", text: $dialogDesc)
                
                Button(dialogObject == nil ? "add" : "save", role: .none) {
                    if let dialogObject = dialogObject {
                        PersistenceController.shared.updateOption(option: dialogObject, value: dialogValue, shortDesc: dialogDesc)
                        
                    } else {
                        let newOption = Option(context: managedObjectContext)
                        newOption.value = dialogValue
                        newOption.detailDesc = ""
                        newOption.shortDesc = dialogDesc
                        
                        self.field?.addToOptions(newOption)
                    }
                    
                    PersistenceController.shared.saveContext()
                    
                    clearDialog()
                    
                    renderId = UUID()
                }
                
                Button("cancel", role: .cancel) {
                    clearDialog()
                }
            }
            
            Divider()
                .frame(height: 24)
            
            Button {
                if let selected = selected {
                   deleteOption(option: selected)
                }
                
                selected = nil
            } label: {
                Image(systemName: "minus")
            }
            .buttonStyle(.plain)
            .frame(width: 24, height: 24)
            
            Spacer()
        }
        .padding(4)
        .background(
            Colors.Background.tertiary
        )
    }
    
    private func clearDialog() {
        selected = nil
        dialogObject = nil
        dialogValue = ""
        dialogDesc = ""
        showOptionDialog = false
    }
    
    private func deleteOption(option: Option) {
        if let options = field?.options, var wrappedOptions = field?.wrappedOptions {
            let index = options.index(of: option)
            wrappedOptions.remove(at: index)
            
            self.field!.options = NSOrderedSet(array: wrappedOptions)
            
            PersistenceController.shared.deleteOption(option)
        }
        
        renderId = UUID()
    }
}

fileprivate struct OptionDialogObject {
    var title: String
    var desc: String
}
