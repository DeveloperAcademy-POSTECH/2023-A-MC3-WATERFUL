//
//  Team+CoreDataClass.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Team)
public class Team: NSManagedObject, Codable {
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
            throw ContextError.NoContextFound
        }
        self.init(context: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        emoticon = try values.decode(String.self, forKey: .teamEmoticon)
        name = try values.decode(String.self, forKey: .teamName)
        pinned = try values.decode(Bool.self, forKey: .teamPinned)
        touch = try values.decode(Date.self, forKey: .teamTouch)
        let newFields = try values.decode([Field].self, forKey: .teamFields)
        fields = NSOrderedSet(array: newFields)
    }
    
    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(emoticon, forKey: .teamEmoticon)
        try values.encode(name, forKey: .teamName)
        try values.encode(pinned, forKey: .teamPinned)
        try values.encode(touch, forKey: .teamTouch)
        try values.encode(wrappedFields, forKey: .teamFields)
    }
    
    enum CodingKeys: CodingKey {
        case teamEmoticon, teamName, teamPinned, teamTouch, teamFields
    }
}
