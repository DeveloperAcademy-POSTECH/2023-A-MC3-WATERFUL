//
//  Option+CoreDataClass.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData

@objc(Option)
public class Option: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(String.self, forKey: .optionValue)
        shortDesc = try values.decode(String.self, forKey: .optionShortDesc)
        detailDesc = try values.decode(String.self, forKey: .optionDetailDesc)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(value, forKey: .optionValue)
        try values.encode(shortDesc, forKey: .optionShortDesc)
        try values.encode(detailDesc, forKey: .optionDetailDesc)
    }
    
    enum CodingKeys: CodingKey {
        case optionValue, optionShortDesc, optionDetailDesc
    }
}
