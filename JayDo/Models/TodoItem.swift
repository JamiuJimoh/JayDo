//
//  TodoItem.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import Foundation

struct TodoItem {
    let title: String
    let isDone: Bool
    
    
    init(title: String, isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
    }
}
