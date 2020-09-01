//
//  CategoryListVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

protocol CategoryListVCDelegate: class {
    func save(category: Category)
}

class CategoryListVC: UIViewController {
    
    let tableView       = UITableView()
    var categoryList    = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCategoryList()
    }
    
    
    private func configure() {
        title                   = "Category"
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 70
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
            addCategoryVC.delegate                  = self
            addCategoryVC.modalPresentationStyle    = .overFullScreen
            addCategoryVC.modalTransitionStyle      = .crossDissolve
            self.present(addCategoryVC, animated: true)
        }
    }
    
    func updateCategoryList() {
        PersistenceManager.retriveCategories {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categoryList = categories
                DispatchQueue.main.async { self.tableView.reloadData() }
            case .failure(let error):
                print(error)
                break
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category =  categoryList[indexPath.row]
        
        let taskItemListVC      = TaskItemListVC(itemList: category.items)
        taskItemListVC.title    = category.name
        
        navigationController?.pushViewController(taskItemListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let category = categoryList[indexPath.row]
        categoryList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.update(category: category, actionType: .remove) {[weak self] (error) in
            guard let _ = self else { return }
            guard let error = error else { return }
            print(error)
        }
    }
}

extension CategoryListVC: CategoryListVCDelegate {
    
    func save(category: Category) {
        PersistenceManager.update(category: category, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.updateCategoryList()
                return
            }
            
            print(error)
        }
    }
    
}
