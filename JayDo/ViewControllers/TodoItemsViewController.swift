//
//  TodoItemsViewController.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 23/01/2024.
//

import UIKit

protocol TodoItemDelegate: AnyObject {
    func didFinish(_ controller: TodoItemsViewController, editing todo: Todo)
}

final class TodoItemsViewController: UITableViewController {
    var todo: Todo!
    
    let cellIdentifier = "cellIdentifier"
    
    let manager = TodosManager.instance
    
    weak var delegate: TodoItemDelegate?
    
    private var insertAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = todo.title
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tintColor = .systemRed
        
        addButton.target = self
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        insertAction?()
        insertAction = nil
    }
    
    private let addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .add)
        button.style = .plain
        button.action = #selector(addItemHandler)
        return button
    }()
    
    @objc func addItemHandler() {
        navigateToEditTodo { controller in
            controller.lastItemID = self.todo.items.last?.todoItemID ?? 0
        }
    }
    
    private func navigateToEditTodo(_ action: ((EditTodoItemViewController)->Void)? = nil) {
        let controller = EditTodoItemViewController()
        controller.delegate = self
        action?(controller)
        navigationController?.show(controller, sender: self)
    }
}

//MARK: - Table View data source & Delegates
extension TodoItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoItemCell
        let item = todo.items[indexPath.row]
        cell.todoItemTitle.text = item.title
        cell.isDone = item.isDone
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = todo.items[indexPath.row]
        item.isDone.toggle()
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoItemCell else { return }
        cell.isDone = item.isDone
        delegate?.didFinish(self, editing: todo)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        navigateToEditTodo { [weak self] controller in
            controller.item = self?.todo.items[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        todo.items.remove(at: indexPath.row)
        tableView.performBatchUpdates {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
        delegate?.didFinish(self, editing: todo)
    }
    
}

//MARK: - Edit todo delegates
extension TodoItemsViewController: EditTodoItemDelegate {
    func didCancelEditing(_ controller: EditTodoItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func didFinishAdding(_ controller: EditTodoItemViewController, with item: TodoItem) {
        navigationController?.popViewController(animated: true)
        manager.add(item: item, to: todo)
       
        insertAction = { [weak self] in
            guard let self else {return}
            guard let index = self.todo.items.firstIndex(where: {$0.todoItemID == item.todoItemID}) else {return}
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.performBatchUpdates {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        delegate?.didFinish(self, editing: todo)
    }
    
    func didFinishEditing(_ controller: EditTodoItemViewController, with item: TodoItem) {
        navigationController?.popViewController(animated: true)
        
        guard let index = todo.items.firstIndex(where: {$0.todoItemID == item.todoItemID}) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoItemCell else {return}
        cell.todoItemTitle.text = item.title
    }
    
}
