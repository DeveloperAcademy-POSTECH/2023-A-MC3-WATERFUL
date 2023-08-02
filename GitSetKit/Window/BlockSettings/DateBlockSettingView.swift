//
//  DateBlockSettingView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/21.
//

import SwiftUI

struct DateBlockSettingView: View {
    @Binding var field: Field?
    @State var bindedField: Field?
    @State private var value = 0
    var dateFormat = ["YYYY-MM-dd", "YY-MM-dd", "MM-dd"]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Colors.Gray.quaternary)
            .overlay(
                VStack(alignment: .leading) {
                    Text("date_block_field_text".localized + formattedDate(format: dateFormat[value]))
                        .foregroundColor(Colors.Gray.tertiary)
                        .padding(.leading, 16)
                        .padding(.top, 16)
                    
                    Picker(selection: $value) {
                        ForEach(0..<dateFormat.count, id: \.self) { idx in
                            Text("\(formattedDate(format: dateFormat[idx]))")
                                .foregroundColor(Colors.Gray.primary)
                                .padding(.top)
                        }
                    } label: { }
                        .pickerStyle(.radioGroup)
                        .padding(.leading, 8)
                        .onChange(of: value) { newValue in
                            self.field = PersistenceController.shared.updateField(field: bindedField!, typeBasedString: dateFormatter(value: value))
                        }
                }
                , alignment: .topLeading
            )
            .onAppear {
                guard let string = field?.typeBasedString else { return }
                bindedField = field
                value = dateConverter(typeBasedString: string)
            }
    }
    
    func formattedDate(format: String) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: Locale.current.identifier)
        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        date.dateFormat = format
        
        return date.string(from: Date())
    }
    
    func dateFormatter(value: Int) -> String {
        switch value {
        case 0:
            return "YYYY-MM-dd"
        case 1:
            return "YY-MM-dd"
        case 2:
            return "MM-dd"
        default:
            return "MM-dd"
        }
        
//        let date = DateFormatter()
//        date.locale = Locale(identifier: Locale.current.identifier)
//        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
//
//        switch value {
//        case 0:
//            date.dateFormat = "YYYY-MM-dd"
//        case 1:
//            date.dateFormat = "YY-MM-dd"
//        case 2:
//            date.dateFormat = "MM-dd"
//        default:
//            date.dateFormat = "YYYY-MM-dd"
//        }
//
//        return date.string(from: Date())
    }
    
    func dateConverter(typeBasedString: String) -> Int {
        switch typeBasedString {
        case "YYYY-MM-dd":
            return 0
        case "YY-MM-dd":
            return 1
        case "MM-dd":
            return 2
        default:
            return 0
        }
    }
}
