//
//  DateFieldView.swift
//  GitSetKit
//
//  Created by Cho Chaewon on 2023/07/24.
//

import Foundation
import SwiftUI
import CoreData

struct DateFieldView: View {
    
    @State var date = Date()
    @Binding var outputMessage: [String]
    @Binding var selectedFieldIndex: Int
    @Binding var selectedDate: String

    var body: some View {
        DatePicker(
            "\(Image(systemName: "calendar"))",
            selection: $date,
            displayedComponents: [.date]
        )
        .frame(width: 300, height: 88, alignment: .topLeading)
        .foregroundColor(.black)
        .datePickerStyle(.field)
        .onChange(of: date) { newValue in
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = selectedDate
            let dateString = dateFormat.string(from: newValue)
            outputMessage[selectedFieldIndex] = dateString
            
        }

    }
}
