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
    
    let title: String
    var items: [TodoItem] {
        didSet {
            setProgress()
        }
    }
    var progress: Progress
    
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
    
    init(title: String, items: [TodoItem], progress: Progress = .notStarted) {
        self.title = title
        self.items = items
        self.progress = progress
        setProgress()
    }
    
    func setProgress() {
        guard !items.isEmpty else { return progress = .noTask }
            if doneCount == items.count { return progress = .isCompleted }
            progress = doneCount > 0 ? .inProgress(doneCount) : .notStarted
    }
    
    
}
