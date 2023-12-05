//
//  ToDoList.swift
//  ToDoist
//
//  Created by Ethan Archibald on 12/4/23.
//

import Foundation

extension ToDoList {
    var itemsArray: [Item] {
        let array = items?.allObjects as? [Item]
        return array ?? []
    }
}
