//
//  PersistenceContainer.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/12.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    // MARK: - Initializer
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GitSetKit")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print(#function, error)
            }
        }
    } //: - Initializer
    
    // MARK: - Save Function
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(#function, error)
            }
        }
    } //: - Save Function
}

// MARK: - Team CRUD
extension PersistenceController {
    func createTeam(emoticon: String, name: String
                    , pinned: Bool, touch: Date) {
        let newTeam = Team(context: container.viewContext)
        newTeam.emoticon = emoticon
        newTeam.name = name
        newTeam.pinned = pinned
        newTeam.touch = touch
        
        saveContext()
    }
    
    func readTeam() -> [Team] {
        var results: [Team] = []
        
        let request = NSFetchRequest<Team>(entityName: "Team")
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch teams from Core Data.")
        }
        
        return results
    }
    
    func updateTeam(team: Team, emoticon: String? = nil, name: String? = nil
                    , pinned: Bool? = nil, touch: Date? = nil, fields: [Field]? = nil) {
        var hasChanges: Bool = false
        
        if emoticon != nil {
            team.emoticon = emoticon!
            hasChanges = true
        }
        if name != nil {
            team.name = name!
            hasChanges = true
        }
        if pinned != nil {
            team.pinned = pinned!
            hasChanges = true
        }
        if touch != nil {
            team.touch = touch!
            hasChanges = true
        }
        if fields != nil {
            team.fields = NSOrderedSet(array: fields!)
            hasChanges = true
        }
        
        if hasChanges {
            saveContext()
        }
    }
    
    func deleteTeam(_ team: Team) {
        container.viewContext.delete(team)
        saveContext()
    }
    
    func addTeamField(team: Team, field: Field) {
        var teamFields: [Field] = team.wrappedFields
        
        teamFields.append(field)
        updateTeam(team: team, fields: teamFields)
        saveContext()
    }
} //: - Team CRUD

// MARK: Field CRUD
extension PersistenceController {
    func createField(name: String, type: Int16, typeBasedString: String? = nil, options: [Option]? = nil) -> Field {
        let newField = Field(context: container.viewContext)
        
        newField.name = name
        newField.type = type
        if typeBasedString != nil {
            newField.typeBasedString = typeBasedString!
        }
        if options != nil {
            newField.options = NSOrderedSet(array: options!)
        }
        
        return newField
    }
    
    func readField(_ team: Team) -> [Field] {
        var results: [Field] = []
        
        let request = NSFetchRequest<Field>(entityName: "Field")
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch fields from Core Data.")
        }
        
        return results
    }
    
    func updateField(field: Field, name: String? = nil, type: Int16? = nil, typeBasedString: String? = nil, options: [Option]? = nil) -> Field {
        var hasChanges: Bool = false
        
        if name != nil {
            field.name = name!
            hasChanges = true
        }
        if type != nil {
            field.type = type!
            hasChanges = true
        }
        if typeBasedString != nil {
            field.typeBasedString = typeBasedString!
            hasChanges = true
        }
        if options != nil {
            field.options = NSOrderedSet(array: options!)
            hasChanges = true
        }
        
        if hasChanges {
            saveContext()
        }
        
        return field
    }
    
    func deleteField(_ field: Field) {
        container.viewContext.delete(field)
        saveContext()
    }
} //: - Field CRUD

// MARK: Option CRUD
extension PersistenceController {
    func createOption(value: String, shortDesc: String? = nil, detailDesc: String? = nil) -> Option {
        let newOption = Option(context: container.viewContext)
        
        newOption.value = value
        if shortDesc != nil {
            newOption.shortDesc = shortDesc
        }
        if detailDesc != nil {
            newOption.detailDesc = detailDesc
        }
        
        return newOption
    }
    
    func readOption() -> [Option] {
        var results: [Option] = []
        
        let request = NSFetchRequest<Option>(entityName: "Option")
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            print("Could not fetch options from Core Data.")
        }
        
        return results
    }
    
    func updateOption(option: Option, value: String? = nil, shortDesc: String? = nil
                      , detailDesc: String? = nil) {
        var hasChanges: Bool = false
        
        if value != nil {
            option.value = value!
            hasChanges = true
        }
        if shortDesc != nil {
            option.shortDesc = shortDesc!
            hasChanges = true
        }
        if detailDesc != nil {
            option.detailDesc = detailDesc!
            hasChanges = true
        }
        
        if hasChanges {
            saveContext()
        }
    }
    
    func deleteOption(_ option: Option) {
        container.viewContext.delete(option)
        saveContext()
    }
    
} //: - Option CRUD
