//
//  CategoryCell.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    static let reuseID = "CategoryCell"
    
    let categoryName = TDTitleLabel(textAlignment: .left, fontSize: 20)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(name: String) {
        categoryName.text = name
    }

    
    private func configure() {
        addSubview(categoryName)
        
        tintColor               = .systemGreen
        accessoryType           = .disclosureIndicator
        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            categoryName.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            categoryName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            categoryName.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}
