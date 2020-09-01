//
//  AddCategoryVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class AddCategoryCV: TDAddVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    private func configureUIElements() {
        self.cancelButton.set(backgroundColor: .systemPurple, title: "Cancel")
        self.saveButton.set(backgroundColor: .systemGreen, title: "Save")
    }
    
    override func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    override func saveButtonTapped() {
        if isTextEntered {
            dismiss(animated: true)
            let category = Category(name: textField.text!, items: [])
            delegate?.save(category: category)
        }
    }
}
