//
//  EmojiSelectionView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/31.
//

import SwiftUI
import WrappingHStack

struct EmoticonPickerView: View {
    @Binding var team: Team
    @Binding var renderId: UUID
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            WrappingHStack(0x1f601...0x1f64f, id: \.self, spacing: .dynamic(minSpacing: 8), lineSpacing: 8) { u in
                Text("\(String(UnicodeScalar(u) ?? "-"))")
                    .font(.system(size: 16))
                    .onTapGesture {
                        let emoticon = String(UnicodeScalar(u) ?? "-")
                        PersistenceController.shared.updateTeam(team: team, emoticon: emoticon)
                        renderId = UUID()
                        
                        dismiss()
                    }
            }
            .padding()
        }
        .frame(width: 320, height: 240)
    }
}
