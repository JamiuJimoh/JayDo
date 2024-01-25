//
//  ViewController.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import UIKit

class TodoViewController: UITableViewController {
    private let cellIdentifier = "cellIdentifier"
    
    let manager = TodosManager.instance
    
    var insertAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todo"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemRed
        
        tableView.register(TodoCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tintColor = .systemRed
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        let barButton = UIBarButtonItem(systemItem: .add)
        barButton.target = self
        barButton.action = #selector(addButtonPressed)
        navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        insertAction?()
        insertAction = nil
//        tableView.reloadData()
    }
    
    @objc func addButtonPressed() { navigateToEditTodo() }
    
    private func navigateToEditTodo(_ action: ((EditTodoViewController)->())? = nil) {
        let controller = EditTodoViewController()
        controller.delegate = self
        action?(controller)
        navigationController?.show(controller, sender: self)
    }
    
    private func didFinishEditing(with todo: Todo) {
        guard let index = manager.todos.firstIndex(where: {$0.todoID == todo.todoID}) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! TodoCell
        cell.todoLabel.text = todo.title
        cell.progressLabel.text = todo.progressText
    }
}

//MARK: - Table View Data Source & Delegates
extension TodoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoCell
        let todo = manager.todos[indexPath.row]
        cell.todoLabel.text = todo.title
        cell.progressLabel.text = todo.progressText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = TodoItemsViewController()
        controller.todo = manager.todos[indexPath.row]
        controller.delegate = self
        navigationController?.show(controller, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let todo = manager.todos[indexPath.row]
        navigateToEditTodo { controller in
            controller.todo = todo
        }
    }
    
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        manager.todos.remove(at: indexPath.row)
//        tableView.performBatchUpdates {
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.manager.todos.remove(at: indexPath.row)
            tableView.performBatchUpdates {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
            completionHandler(true)
        }
        let actionConfig = UISwipeActionsConfiguration(actions: [action])
        return actionConfig
    }
    
}

//MARK: - Edit Todo Delegate
extension TodoViewController: EditTodoDelegate {
    func didCancelEditing(_ controller: EditTodoViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func didFinishAdding(_ controller: EditTodoViewController, with todo: Todo) {
        navigationController?.popViewController(animated: true)
        
        manager.add(todo)
        insertAction = { [weak self] in
            guard let self = self else { return }
            let count = self.manager.todos.count
            let indexPath = IndexPath(row: count-1, section: 0)
            let indexPaths = [indexPath]
            tableView.performBatchUpdates {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    func didFinishEditing(_ controller: EditTodoViewController, with todo: Todo) {
        navigationController?.popViewController(animated: true)
        
        didFinishEditing(with: todo)
    }
    
}

//MARK: - Mark todo item delegate
extension TodoViewController: TodoItemDelegate {
    func didFinish(_ controller: TodoItemsViewController, editing todo: Todo) {
        didFinishEditing(with: todo)
    }
}
