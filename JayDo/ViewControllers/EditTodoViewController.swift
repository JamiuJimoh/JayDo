//
//  AddTodoViewController.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import UIKit

protocol EditTodoDelegate: AnyObject {
    func didCancelEditing(_ controller: EditTodoViewController)
    func didFinishAdding(_ controller: EditTodoViewController, with todo: Todo)
    func didFinishEditing(_ controller: EditTodoViewController, with todo: Todo)
}

class EditTodoViewController: UITableViewController {
    weak var delegate: EditTodoDelegate?
    
    var todo: Todo?
    
    let manager = TodosManager.instance
    
    private let cellIdentifier = "cellIdentifier"
    
    private var pageTitle: String {
        todo == nil ? "Add Todo" : "Edit Todo"
    }
    
    private var textfield: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = .done
        textfield.clearButtonMode = .whileEditing
        textfield.autocapitalizationType = UITextAutocapitalizationType.sentences
        textfield.borderStyle = .roundedRect
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Cancel"
        button.style = .plain
        button.action = #selector(handleCancelTap)
        return button
    }()
    
    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Done"
        button.style = .done
        button.action = #selector(handleDoneTap)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.target = self
        cancelButton.target = self
        title = pageTitle
        navigationItem.largeTitleDisplayMode = .never
        
//        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.register(EditTodoTextFieldCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        
        if let todo {
            textfield.text = todo.title
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
        textfield.becomeFirstResponder()
        textfield.enablesReturnKeyAutomatically = true
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func handleCancelTap() {
        delegate?.didCancelEditing(self)
    }
    
    @objc private func handleDoneTap() {
        done()
    }
    
    private func setUpTextfield(contentView: UIView) {
        contentView.addSubview(textfield)
        
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            textfield.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            textfield.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textfield.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    private func done() {
        textfield.resignFirstResponder()
        
        if let todo {
            todo.title = textfield.text!
            delegate?.didFinishEditing(self, with: todo)
        } else {
            let newTodo = Todo(title: textfield.text!, todoID: manager.nextID)
            delegate?.didFinishAdding(self, with: newTodo)
        }
    }
}

//MARK: - Table View Data Source
extension EditTodoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EditTodoTextFieldCell
        setUpTextfield(contentView: cell.contentView)
        cell.textfield = textfield
        cell.textfield.delegate = self
        return cell
    }
}

extension EditTodoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool { 
        doneButton.isEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        done()
        return true
    }
    
}

