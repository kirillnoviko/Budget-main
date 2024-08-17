import Foundation
import CoreData
import UIKit

extension Category {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var icon: Data?
    @NSManaged public var color: Data?
   
    @NSManaged public var operations: NSSet?

    var iconImage: UIImage? {
        get {
            if let iconData = self.icon {
                return UIImage(data: iconData)
            }
            return nil
        }
        set {
            if let newIcon = newValue {
                self.icon = newIcon.pngData()
            }
        }
    }
}

// MARK: Generated accessors for operations
extension Category {
    @objc(addOperationsObject:)
    @NSManaged public func addToOperations(_ value: Operation)

    @objc(removeOperationsObject:)
    @NSManaged public func removeFromOperations(_ value: Operation)

    @objc(addOperations:)
    @NSManaged public func addToOperations(_ values: NSSet)

    @objc(removeOperations:)
    @NSManaged public func removeFromOperations(_ values: NSSet)
}
