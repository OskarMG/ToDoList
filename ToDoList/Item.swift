//
//  Item.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import Foundation

struct Item: Codable, Hashable {
    var name: String
    var done: Bool
}
