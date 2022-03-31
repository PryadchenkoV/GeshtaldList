//
//  GeshtaldItem+CoreDataProperties.swift
//  Geshtald (iOS)
//
//  Created by Work on 12.03.2021.
//
//

import Foundation
import CoreData


extension GeshtaldItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeshtaldItem> {
        return NSFetchRequest<GeshtaldItem>(entityName: "GeshtaldItem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var info: String?
    @NSManaged public var type: Int64
    @NSManaged public var priority: Int64
    @NSManaged public var imageData: Data?
    @NSManaged public var isFavorite: Bool

    static let availableTypes = [
        (NSLocalizedString("type_not_selected", comment: "Not selected"), "xmark.circle"),
        (NSLocalizedString("type_book", comment: "Book"), "book"),
        (NSLocalizedString("type_film", comment: "Film"), "film"),
        (NSLocalizedString("type_game", comment: "Game"), "gamecontroller")
    ]
    
    var convertIntTypeToString: String {
        return GeshtaldItem.availableTypes[Int(self.type)].0
    }
}

extension GeshtaldItem : Identifiable {

}
