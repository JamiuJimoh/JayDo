//
//  Todo.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import Foundation

class Todo {
    enum Progress {
        case noTask
        case notStarted
        case inProgress(Int)
        case isCompleted
    }
    
    let todoID: Int
    var title: String
    var items: [TodoItem]
    
    var progress: Progress {
        guard !items.isEmpty else { return .noTask }
        if doneCount == items.count { return .isCompleted }
        return doneCount > 0 ? .inProgress(doneCount) : .notStarted
    }
    
    var doneCount: Int {
        items.reduce(0) { result, item in
            guard item.isDone else { return result }
            return result + 1
        }
    }
    
    var progressText: String {
        switch progress {
        case .noTask:
            "(No tasks!)"
        case .isCompleted:
            "(All done!)"
        case .notStarted:
            "(Not started)"
        case let .inProgress(doneCount):
            "(\(doneCount) completed out of \(items.count) tasks!)"
        }
    }
    
    init(title: String, items: [TodoItem], todoID: Int) {
        self.title = title
        self.items = items
        self.todoID = todoID
    }
    
    convenience init(title: String, todoID: Int) {
        self.init(title: title, items: [], todoID: todoID)
    }
    
}
