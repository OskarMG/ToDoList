//
//  CategoryListVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

class CategoryListVC: UIViewController {
    
    let tableView       = UITableView()
    var categoryList    = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureAddButton()
    }
    
    
    private func configure() {
        title                   = "Category"
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
    }
    
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addCategory() {
        DispatchQueue.main.async {
            let addCategoryVC = AddCategoryCV(title: "Category", message: "Add a new category.")
            addCategoryVC.modalPresentationStyle    = .overFullScreen
            addCategoryVC.modalTransitionStyle      = .crossDissolve
            self.present(addCategoryVC, animated: true)
        }
    }
}


extension CategoryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID) as! CategoryCell
        let category    = categoryList[indexPath.row]
        cell.set(name: category.name)
        return cell
    }
}
