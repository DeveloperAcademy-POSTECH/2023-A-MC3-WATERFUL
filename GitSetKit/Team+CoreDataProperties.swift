//
//  Team+CoreDataProperties.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData


extension Team {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var name: String?
    @NSManaged public var emoticon: String?
    @NSManaged public var pinned: Bool
    @NSManaged public var touch: Date?
    @NSManaged public var fields: NSOrderedSet?

}

// MARK: Relationship Type Casting
extension Team {
    public var wrappedFields: [Field] {
        guard let fields = fields?.array as? [Field] else {
            return []
        }
        
        return fields
    }
    
    public var wrappedName: String {
        return name ?? "Unknown Name"
    }
    
    public var wrappedEmoticon: String {
        return emoticon ?? " "
    }
    
    public var wrappedTouch: Date {
        return touch ?? Date()
    }
}

// MARK: Generated accessors for fields
extension Team {

    @objc(insertObject:inFieldsAtIndex:)
    @NSManaged public func insertIntoFields(_ value: Field, at idx: Int)

    @objc(removeObjectFromFieldsAtIndex:)
    @NSManaged public func removeFromFields(at idx: Int)

    @objc(insertFields:atIndexes:)
    @NSManaged public func insertIntoFields(_ values: [Field], at indexes: NSIndexSet)

    @objc(removeFieldsAtIndexes:)
    @NSManaged public func removeFromFields(at indexes: NSIndexSet)

    @objc(replaceObjectInFieldsAtIndex:withObject:)
    @NSManaged public func replaceFields(at idx: Int, with value: Field)

    @objc(replaceFieldsAtIndexes:withFields:)
    @NSManaged public func replaceFields(at indexes: NSIndexSet, with values: [Field])

    @objc(addFieldsObject:)
    @NSManaged public func addToFields(_ value: Field)

    @objc(removeFieldsObject:)
    @NSManaged public func removeFromFields(_ value: Field)

    @objc(addFields:)
    @NSManaged public func addToFields(_ values: NSOrderedSet)

    @objc(removeFields:)
    @NSManaged public func removeFromFields(_ values: NSOrderedSet)

}

extension Team : Identifiable {

}
