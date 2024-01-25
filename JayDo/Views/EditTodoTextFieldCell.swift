//
//  EditTodoTextFieldCell.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import UIKit

final class EditTodoTextFieldCell: UITableViewCell {
    var textfield: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        setUpTextfield()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
