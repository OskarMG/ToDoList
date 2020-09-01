//
//  ItemCell.swift
//  ToDoList
//
//  Created by Oscar Martinez on 9/1/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    static let reuseID = "ItemCell"
    
    let itemName = TDTitleLabel(textAlignment: .left, fontSize: 20)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(item: Item) {
        itemName.text = item.name
        accessoryType = item.done ? .checkmark : .none
    }

    
    private func configure() {
        addSubview(itemName)
        
        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            itemName.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            itemName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            itemName.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

}
