//
//  TodoItemCell.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 23/01/2024.
//

import UIKit

final class TodoItemCell: UITableViewCell {
    var isDone: Bool! {
        didSet {
            image.isHidden = !isDone
        }
    }
    
    lazy var todoItemTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    
    
    private lazy var check: UIView = {
        let check = UIView()
        check.translatesAutoresizingMaskIntoConstraints = false
        return check
    }()
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "checkmark"))
        image.tintColor = .systemRed
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        accessoryType = .detailButton
        isDone = false
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(check)
        contentView.addSubview(todoItemTitle)
        check.addSubview(image)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: check.topAnchor, constant: -15),
            contentView.leadingAnchor.constraint(equalTo: check.leadingAnchor, constant: -16),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: todoItemTitle.trailingAnchor, constant: 20),
            
            check.widthAnchor.constraint(equalToConstant: 20),
            check.trailingAnchor.constraint(equalTo: todoItemTitle.leadingAnchor, constant: -10),
            
            todoItemTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            todoItemTitle.topAnchor.constraint(equalTo: check.topAnchor),
        ])
    }
}
