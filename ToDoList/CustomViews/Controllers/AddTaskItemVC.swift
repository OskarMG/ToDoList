//
//  AddTaskItemVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 9/1/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit


class AddTaskItemVC: TDAddVC {
    
    weak var delegate: TaskItemListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    
    private func configureUIElements() {
        self.cancelButton.set(backgroundColor: .systemPurple, title: "Cancel")
        self.saveButton.set(backgroundColor: .systemGreen, title: "Save")
        self.textField.placeholder  = "New item"
    }
    
    override func saveButtonTapped() {
        if isTextEntered {
            dismiss(animated: true)
            let item = Item(name: textField.text!, done: false)
            delegate?.saveNew(item: item)
            return
        }
        
        self.presentTDAlertOnMainThread(title: "TextField is Empty", message: "Please introduce a new item.", buttonTitle: "Ok")
    }
}
