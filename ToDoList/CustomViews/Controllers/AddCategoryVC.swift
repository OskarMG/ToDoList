//
//  AddCategoryVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class AddCategoryCV: TDAddVC {
    
    weak var delegate: CategoryListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    private func configureUIElements() {
        self.cancelButton.set(backgroundColor: .systemPurple, title: "Cancel")
        self.saveButton.set(backgroundColor: .systemGreen, title: "Save")
        self.textField.placeholder = "New category"
    }
    
    override func saveButtonTapped() {
        if isTextEntered {
            dismiss(animated: true)
            let category = Category(name: textField.text!, items: [])
            delegate?.save(category: category)
            return
        }
        
        self.presentTDAlertOnMainThread(title: "TextField is Empty", message: "Please introduce a new category.", buttonTitle: "Ok")
    }
}
