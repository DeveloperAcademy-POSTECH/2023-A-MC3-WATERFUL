//
//  TeamView.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/09.
//

import SwiftUI


struct TeamCell: View {
    // 수정 모드에서 TextField 표시를 위한 필드
    enum Field {
        case edit
    }
    
    // 팀
    @State var team: Team
    
    @Binding var selected: Team?
    
    // 팀 이름 수정 모드 토글
    @State private var editing: Bool = false
    // 팀 이름 수정 임시 변수
    @State private var newName: String = ""
    // 팀 이모티콘 수정 Popover 호출 변수
    @State private var showEmoticonPicker: Bool = false
    
    // TextField 포커스 변수
    @FocusState private var field: Field?
    
    @Binding var renderId: UUID
    
    var body: some View {
        // 팀 이름 수정 모드
        if editing {
            HStack {
                // 이름 수정 필드
                TextField("", text: $newName)
                    .focused($field, equals: .edit)
                    .onSubmit {
//                        PersistenceController.shared.updateTeam(team: team, emoticon: newEmoticon.isEmpty ? (team.emoticon ?? "😀") : newEmoticon)
                        PersistenceController.shared.updateTeam(team: team, name: newName.isEmpty ? (team.name ?? "Unknown") : newName)
                        
                        editing = false
                        
                        renderId = UUID()
                    }
            }
        } else {
            HStack {
                HStack {
                    Button {
                        showEmoticonPicker = true
                        
                    } label: {
                        Text(team.emoticon ?? " ")
                    }
                    .popover(isPresented: $showEmoticonPicker, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
                        EmoticonPickerView(team: $team, renderId: $renderId)
                    }
                    .buttonStyle(.plain)
                        
                    Text(team.name ?? "Unknown")
                        .font(.body)
                }
                
                Spacer()
                
                if team.pinned {
                    Image(systemName: "pin.fill")
                }
            }
            .contextMenu {
                // MARK: Pin Button
                if team.pinned {
                    Button(role: .none) {
                        PersistenceController.shared.updateTeam(team: team, pinned: false)
                        
                        renderId = UUID()
                        
                    } label: {
                        Label("unpin", systemImage: "pin.fill")
                    }
                } else {
                    Button(role: .none) {
                        PersistenceController.shared.updateTeam(team: team, pinned: true)
                        
                        renderId = UUID()
                        
                    } label: {
                        Label("pin", systemImage: "pin")
                    }
                }
                //: Edit Button
                
                // MARK: Edit Button
                Button(role: .none) {
                    editing = true
                    newName = team.name ?? ""
                    field = .edit
                } label: {
                    Label("edit", systemImage: "pencil")
                }
                //: Edit Button
                
                // MARK: Delete Button
                Button(role: .destructive) {
                    PersistenceController.shared.deleteTeam(team)
                    
                    renderId = UUID()
                    
                    selected = nil
                    
                } label: {
                    Label("delete", systemImage: "trash.fill")
                }
                //: Delete Button
                
            }
        }
    }
}

// MARK: - TeamView
struct TeamView: View {
    // 고정 팀
    @FetchRequest(
        entity: Team.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Team.touch, ascending: false)],
        predicate: NSPredicate(format: "pinned == true")
    ) var pinned: FetchedResults<Team>
    
    // 모든 팀
    @FetchRequest(
        entity: Team.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Team.touch, ascending: false)]
    ) var teams: FetchedResults<Team>
    
    @Binding var selected: Team?
    @StateObject var fileHelper: FileHelper = FileHelper()
    
    // 팀 데이터 수정 시 List를 다시 로드하기 위한 UUID
    @State private var renderId: UUID = UUID()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        List(selection: $selected) {
            // MARK: Pinned Team
            if !pinned.isEmpty {
                Section("section_pinned") {
                    ForEach(pinned) { team in
                        NavigationLink(value: team) {
                            TeamCell(team: team, selected: $selected, renderId: $renderId)
                        }
                    }
                }
            }
            //: Pinned Team
            
            // MARK: All Team
            Section("section_team") {
                ForEach(teams) { team in
                    NavigationLink(value: team) {
                        TeamCell(team: team, selected: $selected, renderId: $renderId)
                    }
                }
            }
            //: All Team
            
            // MARK: - Add Team
            Button {
                let generator = DefaultDataGenerator(managedObjectContext)
                let fields = generator.generateFields()
                let team = generator.generateTeam(fields)
                
                PersistenceController.shared.saveContext()
                
                selected = team
                
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                    Spacer()
                }
            }
            .buttonStyle(.plain)
            .padding(8)
            //-: Add Team
        }
        .listStyle(.sidebar)
        .id(renderId)
        .onChange(of: selected) { newValue in
            if let selected = selected {
                PersistenceController.shared.updateTeam(team: selected, touch: Date())
                FileHelper.selectTeam = selected
            }
        }
        .onLoad {
            // 최초 로드 시 첫번째 팀 선택
            if let team = teams.first {
                self.selected = team
            }
        }
        
    }
}
//: - TeamView
