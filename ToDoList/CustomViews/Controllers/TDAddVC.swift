//
//  TDAddVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class TDAddVC: UIViewController {
    
    let containerView   = UIView()
    let titleLabel      = TDTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel    = TDBodyLabel(textAlignment: .center)
    let stackView       = UIStackView()
    let cancelButton    = TDButton()
    let saveButton      = TDButton()
    
    var tdTitle: String?
    var tdMessage: String?
    
    let padding: CGFloat = 20
    
    init (title: String, message: String) {
        super.init(nibName: nil, bundle: nil)
        tdTitle     = title
        tdMessage   = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureActionButtons()
    }
    
    
    private func configureActionButtons() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func cancelButtonTapped() { }
    @objc func saveButtonTapped() { }
    
    
    private func configure() {
        view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.75)
    }
}
