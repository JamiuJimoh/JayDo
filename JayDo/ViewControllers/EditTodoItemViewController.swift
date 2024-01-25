//
//  EditTodoItemItemViewController.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 24/01/2024.
//

import UIKit

protocol EditTodoItemDelegate: AnyObject {
    func didCancelEditing(_ controller: EditTodoItemViewController)
    func didFinishAdding(_ controller: EditTodoItemViewController, with item: TodoItem)
    func didFinishEditing(_ controller: EditTodoItemViewController, with item: TodoItem)
}

class EditTodoItemViewController: UITableViewController {
    weak var delegate: EditTodoItemDelegate?
    
    var item: TodoItem?
    var lastItemID: Int?
    
    let manager = TodosManager.instance
    
    private let cellIdentifier = "cellIdentifier"
    
    private var pageTitle: String {
        item == nil ? "Add Item" : "Edit Item"
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
        
        tableView.separatorStyle = .none
        tableView.register(EditTodoTextFieldCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        
        if let item {
            textfield.text = item.title
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
        
        if let item {
            item.title = textfield.text!
            delegate?.didFinishEditing(self, with: item)
        } else {
            guard let id = lastItemID else {return}
            let newItem = TodoItem(todoItemID: id+1, title: textfield.text!)
            delegate?.didFinishAdding(self, with: newItem)
        }
    }
}

//MARK: - Table View Data Source
extension EditTodoItemViewController {
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

extension EditTodoItemViewController: UITextFieldDelegate {
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


