//
//  TodoCell.swift
//  JayDo
//
//  Created by Jamiu Jimoh on 18/01/2024.
//

import UIKit

final class TodoCell: UITableViewCell {
    lazy var todoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        accessoryType = .detailDisclosureButton
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        contentView.addSubview(todoLabel)
        contentView.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: todoLabel.topAnchor, constant: -15),
            contentView.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor, constant: -20),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: todoLabel.trailingAnchor, constant: 8),
            
            
            progressLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor, constant: 10),
            progressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            progressLabel.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: todoLabel.trailingAnchor),
        ])
    }
}
