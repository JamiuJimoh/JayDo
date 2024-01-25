//
//  TodoItem.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import Foundation

class TodoItem {
    var title: String
    var isDone: Bool
    let todoItemID: Int
    
    
    init(todoItemID: Int, title: String, isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
        self.todoItemID = todoItemID
    }
}
