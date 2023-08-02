//
//  Field+CoreDataClass.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData

@objc(Field)
public class Field: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .fieldName)
        type = try values.decode(Int16.self, forKey: .fieldType)
        typeBasedString = try values.decode(String.self, forKey: .fieldTypeBasedString)
        let newOptions = try values.decode([Option].self, forKey: .fieldOptions)
        options = NSOrderedSet(array: newOptions)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(name, forKey: .fieldName)
        try values.encode(type, forKey: .fieldType)
        if typeBasedString == nil {
            try values.encode("", forKey: .fieldTypeBasedString)
        }
        else {
            try values.encode(typeBasedString, forKey: .fieldTypeBasedString)
        }
        try values.encode(wrappedOptions, forKey: .fieldOptions)
    }
    
    enum CodingKeys: CodingKey {
        case fieldName, fieldType, fieldTypeBasedString, fieldOptions
    }
}
