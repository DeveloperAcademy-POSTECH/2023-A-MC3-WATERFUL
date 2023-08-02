//
//  Field+CoreDataProperties.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData


extension Field {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Field> {
        return NSFetchRequest<Field>(entityName: "Field")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: Int16
    @NSManaged public var typeBasedString: String?
    @NSManaged public var options: NSOrderedSet?

}

// MARK: Relationship Type Casting
extension Field {
    
    public var wrappedOptions: [Option] {
        guard let options = options?.array as? [Option] else {
            return []
        }
        
        return options
    }
    
    public var wrappedName: String {
        return name ?? "Unknown"
    }
    
    public var wrappedType: FieldType {
        return FieldType(rawValue: type) ?? .constant
    }
    
    public var wrappedTypeBasedString: String {
        return typeBasedString ?? ""
    }
    
    public var converted: Any {
        switch wrappedType {
        case .constant:
            return ConstantField(string: wrappedTypeBasedString)
        case .option:
            return OptionField(options: wrappedOptions)
        case .input:
            return InputField(placeholder: wrappedTypeBasedString)
        case .date:
            return DateField(format: wrappedTypeBasedString)
        }
    }
}

// MARK: Field Type
extension Field {
    public enum FieldType: Int16 {
        case constant = 1
        case option = 2
        case input = 3
        case date = 4
    }
}

// MARK: Generated accessors for options
extension Field {

    @objc(insertObject:inOptionsAtIndex:)
    @NSManaged public func insertIntoOptions(_ value: Option, at idx: Int)

    @objc(removeObjectFromOptionsAtIndex:)
    @NSManaged public func removeFromOptions(at idx: Int)

    @objc(insertOptions:atIndexes:)
    @NSManaged public func insertIntoOptions(_ values: [Option], at indexes: NSIndexSet)

    @objc(removeOptionsAtIndexes:)
    @NSManaged public func removeFromOptions(at indexes: NSIndexSet)

    @objc(replaceObjectInOptionsAtIndex:withObject:)
    @NSManaged public func replaceOptions(at idx: Int, with value: Option)

    @objc(replaceOptionsAtIndexes:withOptions:)
    @NSManaged public func replaceOptions(at indexes: NSIndexSet, with values: [Option])

    @objc(addOptionsObject:)
    @NSManaged public func addToOptions(_ value: Option)

    @objc(removeOptionsObject:)
    @NSManaged public func removeFromOptions(_ value: Option)

    @objc(addOptions:)
    @NSManaged public func addToOptions(_ values: NSOrderedSet)

    @objc(removeOptions:)
    @NSManaged public func removeFromOptions(_ values: NSOrderedSet)

}

extension Field : Identifiable {

}
