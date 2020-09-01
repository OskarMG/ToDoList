//
//  TDError.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import Foundation


enum TDError: String, Error {
    case couldNotSave           = "Could not save Category."
    case couldNotRetriveData    = "Could not retrive categories."
    case categoryAlreadyExists  = "Category already exists."
    case taskITemAlreadyExists  = "Task Item already exists."
}
