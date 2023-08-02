//
//  TeamSelectedView.swift
//  GitSetKit
//
//  Created by Cho Chaewon on 2023/07/24.
//

import Foundation
import SwiftUI
import CoreData

struct TeamSelectedView: View {
    
    @Binding var teamNames: [Team]
    @Binding var selectedTeam: Team?
    @Binding var outputMessage: [String]
    
    var body: some View {
        HStack{
            Image("tray_icon")
                .frame(width: 30, height: 30)
            
            Text("GitSetKit")
                .foregroundColor(.black)
                .font(.system(size: 16))
            
            Spacer()
            
            Menu {
                ForEach(teamNames, id: \.self) { team in
                    Button {
                        selectedTeam = team
                    } label: {
                        Text(team.wrappedEmoticon + team.wrappedName)
                            .foregroundColor(Color.black)
                    }
                }
            } label: {
                Text("\(selectedTeam?.wrappedEmoticon ?? "") \(selectedTeam?.wrappedName ?? "팀 선택")")
                    .foregroundColor(Color.black)
            }
            .frame(width: 120, alignment: .trailing)
            
        }//Hstack
        .frame(width: 316, height: 32)
        .padding(EdgeInsets(top: 9, leading: 9, bottom: 9, trailing: 9))
       
    }
}




