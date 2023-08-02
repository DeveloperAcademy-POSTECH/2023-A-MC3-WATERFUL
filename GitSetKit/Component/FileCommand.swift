//
//  FileCommand.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/23.
//

import SwiftUI

struct FileCommand: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var exportIsPresented: Bool = false
    @State var importIsPresented: Bool = false
    
    @StateObject var fileHelper: FileHelper = FileHelper()
    
    var body: some View {
        // New Project
        Button("command_file_new_team") {
            let generator = DefaultDataGenerator(managedObjectContext)
            let fields = generator.generateFields()
            let _ = generator.generateTeam(fields)
            
            PersistenceController.shared.saveContext()
        }
        .keyboardShortcut("n")
        
        Divider()
        
        // MARK: Import Team
        Button("command_file_import") {
            importIsPresented = true
        }
        .keyboardShortcut("i")
        .fileImporter(isPresented: $importIsPresented, allowedContentTypes: [.json]) { result in
            switch result {
            case .success(let success):
                fileHelper.selectUrl = success
                fileHelper.importTeam()
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            importIsPresented = false
        } //: Import Team
        
        // MARK: Export Team
        Button("command_file_export") {
            if FileHelper.selectTeam != nil {
                exportIsPresented = true
            }
        }
        .keyboardShortcut("e")
        .fileImporter(isPresented: $exportIsPresented, allowedContentTypes: [.folder]) { result in
            switch result {
            case .success(let success):
                fileHelper.selectUrl = success
                fileHelper.exportTeam()
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            importIsPresented = false
        } //: Export Team
    }
}
