//
//  UIViewController+Ext.swift
//  ToDoList
//
//  Created by Oscar Martinez on 9/1/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func presentTDAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let tdAlertVC = TDAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            tdAlertVC.modalPresentationStyle    = .overFullScreen
            tdAlertVC.modalTransitionStyle      = .crossDissolve
            self.present(tdAlertVC, animated: true)
        }
    }
    
}
