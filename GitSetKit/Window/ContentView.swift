//
//  ContentView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/09.
//

import SwiftUI

struct ContentView: View {
    
    // 선택된 팀
    @State private var selected: Team?
    
    // SideBar, Detail 보이기 설정
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // MARK: Side Bar
            TeamView(selected: $selected)
                .frame(minWidth: 240)
            
            //: Side Bar
        } detail: {
            // MARK: Detail
            // 팀 선택된 경우
            if let _ = selected {
                ConventionView(selectedTeam: $selected)
                    .frame(minWidth: 600, minHeight: 560)
                
            } else {
                // 팀 선택이 없는 경우 (= 팀이 없는 경우)
                VStack(spacing: 24) {
                    Image("GitSetKitLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86)
                    Text("not_selected")
                        .font(.title3.bold())
                    
                    Button("add_team") {
                        let generator = DefaultDataGenerator(managedObjectContext)
                        let fields = generator.generateFields()
                        let team = generator.generateTeam(fields)
                        
                        self.selected = team
                        
                        PersistenceController.shared.saveContext()
                    }
                }
                .frame(minWidth: 600, minHeight: 560)
            }
            //: - Detail
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
