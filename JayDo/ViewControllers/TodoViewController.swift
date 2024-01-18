//
//  ViewController.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import UIKit

class TodoViewController: UITableViewController {
    private let cellIdentifier = "cellIdentifier"
    
    let todos = [
        Todo(title: "Football", items: [
            TodoItem(title: "Take a shower", isDone: true),
            TodoItem(title: "Go And Play Ball", isDone: false),
        ]),
        Todo(title: "Groceries", items: []),
        Todo(title: "Cinema", items: []),
        Todo(title: "Gym", items: []),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todo"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(TodoCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

//MARK: - Table View Data Source
extension TodoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoCell
        let todo = todos[indexPath.row]
        cell.todoLabel.text = todo.title
        cell.progressLabel.text = todo.progressText
        
        return cell
    }
}

