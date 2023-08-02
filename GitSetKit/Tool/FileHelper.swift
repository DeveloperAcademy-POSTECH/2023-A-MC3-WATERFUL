//
//  FileHelper.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/10.
//

import Foundation
import CoreData

class FileHelper: ObservableObject {
    @Published var selectUrl = URL(string: "")
    static var selectTeam: Team?
    
    func importTeam() {
        do {
            let jsonData = try Data(contentsOf: selectUrl!)
            
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = PersistenceController.shared.container.viewContext
            let item = try decoder.decode(Team.self, from: jsonData)
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func exportTeam() {
        do {
            let jsonData = try JSONEncoder().encode(FileHelper.selectTeam)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                if let tempURL = selectUrl {
                    let pathURL = tempURL.appending(component: "\(String(describing: FileHelper.selectTeam!.name ?? "")).json")
                    try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
