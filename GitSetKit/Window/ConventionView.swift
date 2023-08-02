//
//  ConventionView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/09.
//

import SwiftUI

struct ConventionView: View {
    
    @Binding var selectedTeam: Team?
    @State var selectedField: Field?
    
    @State private var blockOptionHint: LocalizedStringKey = ""
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("convention_section_title")
                    .font(.title2.bold())
                Spacer()
            }
            // MARK: - Template View
            // Field들이 나열되는 View
            GroupBox {
                TemplateView(team: $selectedTeam, selected: $selectedField)
            } label: {
                Text("convention_section_template")
                    .font(.title3)
            }
            .groupBoxStyle(TransparentGroupBox())
            .frame(height: 160)
            // : - Template View
            
            // MARK: - Block Option View
            if selectedTeam != nil && selectedField != nil {
                GroupBox {
                    VStack {
                        BlockOptionView(selectedTeam: $selectedTeam, selectedField: $selectedField, hint: $blockOptionHint)
                        BlockSettingView(selected: $selectedField)
                    }
                } label: {
                    HStack(spacing: 16) {
                        Text("convention_section_block")
                            .font(.title3)
                        
                        Text(blockOptionHint)
                            .foregroundColor(Colors.Text.secondary)
                    }
                }
                .groupBoxStyle(TransparentGroupBox())
                .padding(.top, 8)
            }
            // : - Inspector View
            
            Spacer()
        }
        .onChange(of: selectedTeam, perform: { newValue in
            selectedField = nil
        })
        .padding()
        .background(
            Colors.Background.primary
        )
        .navigationTitle(Text(selectedTeam?.wrappedName ?? "app_name".localized))
    }
}
