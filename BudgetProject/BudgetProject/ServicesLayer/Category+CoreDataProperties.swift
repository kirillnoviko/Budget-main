//
//  Category+CoreDataProperties.swift
//  
//
//  Created by User on 26.07.24.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var icon: Data?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
