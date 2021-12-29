//
//  GeshtaldModel.swift
//  Geshtald
//
//  Created by Ivan Pryadchenko on 29.12.2021.
//

import SwiftUI
import OSLog
import Foundation
import CoreData

class GeshtaldModel: ObservableObject {
    
    @Published var allItems: [GeshtaldItem] = []
    @Published var searchItems: [GeshtaldItem] = []
    @Published var searchString: String = ""
    
    let context: NSManagedObjectContext
    let logger = Logger()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchItems()
    }
    
    func fetchAll() {
        fetchItems()
        fetchSearchItems()
    }
    
    func fetchItems() {
        logger.info("[GeshtaldModel] \(#function)")
        let request = GeshtaldItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \GeshtaldItem.priority, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let fetchResult = try context.fetch(request) as [GeshtaldItem]
            allItems = fetchResult
        } catch {
            logger.error("[GeshtaldModel] Error while fetching")
        }
    }
    
    func fetchSearchItems() {
        logger.info("[GeshtaldModel] \(#function)")
        let request = GeshtaldItem.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchString)
        let sortDescriptor = NSSortDescriptor(keyPath: \GeshtaldItem.priority, ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            let fetchResult = try context.fetch(request) as [GeshtaldItem]
            searchItems = fetchResult
        } catch {
            logger.error("[GeshtaldModel] Error while fetching allItems")
        }
    }
    
    func addItem(withName name: String, description: String, imageData: Data? = nil, type: Int64) {
        logger.info("[GeshtaldModel] \(#function)")
        let newItem = GeshtaldItem(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.info = description
        newItem.imageData = imageData
        newItem.type = type
        newItem.priority = Int64(allItems.count)
        
        do {
            try context.save()
            fetchAll()
        } catch {
            let nsError = error as NSError
            fatalError("[GeshtaldModel] \(#function) Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func delete(items: [GeshtaldItem]) {
        logger.info("[GeshtaldModel] \(#function)")
        let fetchRequest = GeshtaldItem.fetchRequest()
        var predicateString = ""
        for item in items {
            if items.first != item {
                predicateString += " || "
            }
            predicateString += "id == '\(item.id.uuidString)'"
        }
        fetchRequest.predicate = NSPredicate(format: predicateString)
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
            fetchAll()
        } catch {
            let nsError = error as NSError
            fatalError("[GeshtaldModel] \(#function) Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func move(items: [GeshtaldItem], source: IndexSet, destination: Int) {
        logger.info("[GeshtaldModel] \(#function)")
        var copyItems = items
        copyItems.move(fromOffsets: source, toOffset: destination)
        let priorities = getAllPrioIndexes(copyItems)
        for (index, item) in copyItems.enumerated() {
            item.priority = priorities[index]
        }
        do {
            try context.save()
            fetchAll()
        } catch {
            let nsError = error as NSError
            fatalError("[GeshtaldModel] \(#function) Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func getAllPrioIndexes(_ items: [GeshtaldItem]) -> [Int64] {
        var prio = [Int64]()
        for item in items {
            prio.append(item.priority)
        }
        return prio.sorted()
    }
}
