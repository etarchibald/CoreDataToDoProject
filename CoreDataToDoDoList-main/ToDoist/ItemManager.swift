//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import CoreData
import Foundation

class ItemManager {
    static let shared = ItemManager()
    
    private let context = PersistanceController.shared.viewContext
    
    // Create
    
    func createNewList(with title: String) {
        let newList = ToDoList(context: context)
        newList.id = UUID().uuidString
        newList.title = title
        newList.createdAt = Date()
        newList.modifiedAt = Date()
        PersistanceController.shared.saveContext()
    }
    
    func createNewItem(with title: String, list: ToDoList) {
        let newItem = Item(context: PersistanceController.shared.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        newItem.items = list
        PersistanceController.shared.saveContext()
    }
    
    // Retrieve
    
    func allLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedLists = try? context.fetch(fetchRequest)
        return fetchedLists ?? []
    }
    
    func incompleteItems(of list: ToDoList) -> [Item] {
        let incomplete = list.itemsArray.filter { $0.completedAt == nil }
        return incomplete.sorted(by: { $0.sortDate >  $1.sortDate })
    }
    
    func completedItems(of list: ToDoList) -> [Item] {
        let completed = list.itemsArray.filter { $0.completedAt != nil }
        return completed.sorted(by: { $0.sortDate >  $1.sortDate })
    }
    
//    func fetchIncompleteItems() -> [Item] {
//        let fetchRequest = Item.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "completedAt == nil")
//        let context = PersistanceController.shared.viewContext
//        let fetchedItems = try? context.fetch(fetchRequest)
//        return fetchedItems ?? []
//    }
    
    // Update
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistanceController.shared.saveContext()
    }
    
    // Delete
    
    func deleteList(at indexPath: IndexPath) {
        let list = allLists()[indexPath.row]
        context.delete(list)
        PersistanceController.shared.saveContext()
    }
    
    func delete(_ item: Item) {
       let context = context
        context.delete(item)
        PersistanceController.shared.saveContext()
    }
    
//    func remove(_ item: Item) {
//        let context = PersistanceController.shared.viewContext
//        context.delete(item)
//        PersistanceController.shared.saveContext()
//    }

//    private func item(at indexPath: IndexPath) -> Item {
//        let items = indexPath.section == 0 ? fetchIncompleteItems() : completedItems(of: <#ToDoList#>)
//        return items[indexPath.row]
//    }

}
