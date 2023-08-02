//
//  FieldView.swift
//  GitSetKit
//
//  Created by Cho Chaewon on 2023/07/18.
//

import Foundation
import SwiftUI
import WrappingHStack
import CoreData

struct FieldView: View {
    @Binding var selectedTeam: Team?
    @Binding var selectedFields: [Field]
    @Binding var selectedField: Field?
    @Binding var outputMessage: [String]
    @Binding var selectedFieldIndex: Int
    @Binding var selectedOptions: [Option]
    @Binding var selectedDate: String
    
    @State private var inputText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Colors.Background.primary
                        .opacity(0.48)
                    
                    if selectedFieldIndex >= 0 && selectedFieldIndex < selectedFields.count {
                        let currentField = selectedFields[selectedFieldIndex].wrappedType.rawValue
                        
                        switch currentField {
                        case 2:
                            OptionFieldView(outputMessage: $outputMessage, selectedFieldIndex: $selectedFieldIndex, selectedField: $selectedField, selectedOptions: $selectedOptions)
                        case 3:
                            InputFieldView(inputText: $inputText, outputMessage: $outputMessage, selectedFieldIndex: $selectedFieldIndex)
                        case 4:
                            DateFieldView(outputMessage: $outputMessage, selectedFieldIndex: $selectedFieldIndex, selectedDate: $selectedDate)
                        default:
                            InputFieldView(inputText: $inputText, outputMessage: $outputMessage, selectedFieldIndex: $selectedFieldIndex)
                        }
                    } else {
                        Text("Field 찾을 수 없음")
                    }
                    
                }//ZStack
                .onChange(of: selectedTeam){ newValue in
                    selectedFieldIndex = 0
                    if selectedFields[selectedFieldIndex].wrappedType.rawValue == 2 {
                        selectedOptions = selectedFields[selectedFieldIndex].wrappedOptions
                    } else if selectedFields[selectedFieldIndex].wrappedType.rawValue == 3 {
                        inputText = selectedField?.wrappedName ?? ""
                    }
                    selectedFields = newValue!.wrappedFields
                    outputMessage = addOutput(selectedFields: selectedFields)
                }
                .onChange(of: selectedFieldIndex){ [selectedFieldIndex] newValue in
                    if newValue >= 0 && newValue < selectedFields.count{
                        if selectedFields[newValue].wrappedType.rawValue == 1 {
                            if newValue > selectedFieldIndex {
                                self.selectedFieldIndex += 1
                            } else if newValue < selectedFieldIndex {
                                self.selectedFieldIndex -= 1
                            }
                        }
                        
                        else if selectedFields[newValue].wrappedType.rawValue == 2 {
                            selectedOptions = selectedFields[newValue].wrappedOptions
                        }
                        else if selectedFields[newValue].wrappedType.rawValue == 3 {
                            inputText = selectedField?.wrappedName ?? ""
                            
                        }
                    }
                }
            }//VStack
            .frame(width: 316, height: 104)
        }//navigationView
    }
    
    func addOutput(selectedFields: [Field]) -> [String] {
        var outputMessage: [String] = []
        var tmp: String
        
        for field in selectedFields {
            if field.type == 4 {
                let today = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "\(field.wrappedTypeBasedString)"
                selectedDate = "\(field.wrappedTypeBasedString)"
                let dateString = dateFormatter.string(from: today)
                
                tmp = dateString
            } else {
                tmp = "\(field.wrappedName)"
            }
            outputMessage.append(tmp)
        }
        return outputMessage
    }
    
}





