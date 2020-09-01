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
    let titleLabel      = TDTitleLabel(textAlignment: .center, fontSize: 18)
    let messageLabel    = TDBodyLabel(textAlignment: .center)
    let textField       = TDTextField()
    let stackView       = UIStackView()
    let cancelButton    = TDButton()
    let saveButton      = TDButton()
    
    var tdTitle: String?
    var tdMessage: String?
    
    var isTextEntered: Bool {
        get { !self.textField.text!.isEmpty }
    }
    
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
        configureStackView()
        configureUIElements()
        createDissmissKeyboardGesture()
    }
    
    
    private func createDissmissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureActionButtons() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func cancelButtonTapped() { dismiss(animated: true) }
    @objc func saveButtonTapped() { }
    
    private func configureStackView() {
        stackView.axis          = .horizontal
        stackView.distribution  = .fillEqually
        stackView.spacing       = 20
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
    }
    
    private func configureUIElements() {
        titleLabel.text     = tdTitle
        messageLabel.text   = tdMessage
    }
    
    private func configure() {
        view.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.70)
        
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(stackView)
        containerView.addSubview(textField)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints     = false
        
        containerView.layer.cornerRadius    = 18
        containerView.layer.borderWidth     = 2
        containerView.layer.borderColor     = UIColor.white.cgColor
        containerView.backgroundColor       = .secondarySystemBackground
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            messageLabel.heightAnchor.constraint(equalToConstant: 22),
            
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
