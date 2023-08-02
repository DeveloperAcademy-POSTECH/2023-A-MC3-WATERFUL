//
//  Option+CoreDataProperties.swift
//  GitSetKit
//
//  Created by 송재훈 on 2023/07/19.
//
//

import Foundation
import CoreData


extension Option {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Option> {
        return NSFetchRequest<Option>(entityName: "Option")
    }

    @NSManaged public var value: String?
    @NSManaged public var shortDesc: String?
    @NSManaged public var detailDesc: String?

}

extension Option : Identifiable {

}
