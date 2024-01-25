//
//  TodosManager.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 20/01/2024.
//

import Foundation

final class TodosManager {
    static let instance = TodosManager()
    
    private init() {}
    
    var todos = [
        Todo(title: "Football", items: [
            TodoItem(todoItemID: 1, title: "Take a shower", isDone: true),
            TodoItem(todoItemID: 2,title: "Go And Play Ball", isDone: false),
            
        ], todoID: 1),
        Todo(title: "Groceries", items: [
            TodoItem(todoItemID: 1,title: "Go to the store", isDone: true)
        ], todoID: 2),
        Todo(title: "Cinema", items: [
            TodoItem(todoItemID: 1,title: "Go watch a movie")
        ], todoID: 3),
        Todo(title: "Gym", items: [], todoID: 4),
    ]
    
    var nextID: Int { (todos.last?.todoID ?? 1) + 1 }
    
    func add(_ todo: Todo) {
        todos.append(todo)
    }
    
    func add(item: TodoItem, to todo: Todo) {
        todo.items.append(item)
    }
}
