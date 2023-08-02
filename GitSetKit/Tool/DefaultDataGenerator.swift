//
//  DefaultData.swift
//  GitSetKit
//
//  Created by 최명근 on 2023/07/20.
//

import Foundation
import CoreData

class DefaultDataGenerator {
    
    let viewContext: NSManagedObjectContext
    
    init(_ viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    // MARK: - Default Team
    func generateTeam(_ fields: [Field]) -> Team {
        let team = Team(context: viewContext)
        team.name = "default_team_name".localized
        team.emoticon = "default_team_emoticon".localized
        team.pinned = false
        team.touch = Date()
        team.fields = NSOrderedSet(array: fields)
        
        return team
    }
    //: - Default Team
    
    // MARK: - Default Fields
    func generateFields() -> [Field] {
        var fields: [Field] = Array()
        fields.append(typeField)
        fields.append(constantField)
        fields.append(editField)
        
        return fields
    }
    
    // MARK: Field: Type
    private var typeField: Field {
        let field = Field(context: viewContext)
        field.name = "default_field_type_name".localized
        field.type = Field.FieldType.option.rawValue
//        field.order = 0
        field.options = NSOrderedSet(array: typeOptions)
        
        return field
    }
    
    // MARK: Option: Type
    private var typeOptions: [Option] {
        var options: [Option] = Array()
        
        let feat = Option(context: viewContext)
        feat.value = "Feat"
        feat.shortDesc = "default_field_type_option_feat".localized
        feat.detailDesc = ""
        options.append(feat)
        
        let fix = Option(context: viewContext)
        fix.value = "Fix"
        fix.shortDesc = "default_field_type_option_fix".localized
        fix.detailDesc = ""
        options.append(fix)
        
        let refactor = Option(context: viewContext)
        refactor.value = "Refactor"
        refactor.shortDesc = "default_field_type_option_refactor".localized
        refactor.detailDesc = ""
        options.append(refactor)
        
        let docs = Option(context: viewContext)
        docs.value = "Docs"
        docs.shortDesc = "default_field_type_option_docs".localized
        docs.detailDesc = ""
        options.append(docs)
        
        let style = Option(context: viewContext)
        style.value = "Style"
        style.shortDesc = "default_field_type_option_style".localized
        style.detailDesc = ""
        options.append(style)
        
        let test = Option(context: viewContext)
        test.value = "Test"
        test.shortDesc = "default_field_type_option_test".localized
        test.detailDesc = ""
        options.append(test)
        
        let chore = Option(context: viewContext)
        chore.value = "Chore"
        chore.shortDesc = "default_field_type_option_chore".localized
        chore.detailDesc = ""
        options.append(chore)
        
        return options
    }
    
    // MARK: Field: Constant
    private var constantField: Field {
        let field = Field(context: viewContext)
        field.name = ": "
        field.type = Field.FieldType.constant.rawValue
//        field.order = 2
        field.typeBasedString = ": "
        
        return field
    }
    
    // MARK: Field: Edit Detail
    private var editField: Field {
        let field = Field(context: viewContext)
        field.name = "default_field_edit_name".localized
        field.type = Field.FieldType.input.rawValue
//        field.order = 2
        field.typeBasedString = "default_field_edit_placeholder".localized
        
        return field
    }
    
    //: - Default Fields
    
}
