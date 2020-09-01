//
//  TaskItemListVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 9/1/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

protocol TaskItemListVCDelegate: class {
    func saveNew(item: Item)
}

class TaskItemListVC: UIViewController {
    
    let tableView       = UITableView()
    var taskItemList    = [Item]()
    var parentCategory: Category!
    
    init(Category: Category) {
        super.init(nibName: nil, bundle: nil)
        self.parentCategory = Category
        self.taskItemList   = Category.items
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureTableView()
        configureAddButton()
    }

    private func configure() {
        title = parentCategory.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 70
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseID)
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    @objc func addNewItem() {
        DispatchQueue.main.async {
            let addTaskItemVC = AddTaskItemVC(title: "Task item", message: "Add a new task item.")
            addTaskItemVC.delegate                  = self
            addTaskItemVC.modalPresentationStyle    = .overFullScreen
            addTaskItemVC.modalTransitionStyle      = .crossDissolve
            self.present(addTaskItemVC, animated: true)
        }
    }
    
    func updateExistingItem() {
        parentCategory.items = taskItemList
        PersistenceManager.update(category: parentCategory, actionType: .update) {[weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.updateItemList()
                return
            }
            self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func updateItemList() {
        PersistenceManager.retriveCategories {[weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                
                let categoryResult = categories.filter { (Category) -> Bool in
                    return Category.name == self.parentCategory.name
                }
                
                guard let items = categoryResult.first?.items else { return }
                self.taskItemList = items
                
                DispatchQueue.main.async { self.tableView.reloadData() }
                
            case .failure(_):
                self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: "Could not refresh task items.", buttonTitle: "Ok")
            }
        }
    }
}



extension TaskItemListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.taskItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseID) as! ItemCell
        
        let itemTask = taskItemList[indexPath.row]
        cell.set(item: itemTask)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        taskItemList[indexPath.row].done.toggle()
        updateExistingItem()
    }
    
}


extension TaskItemListVC: TaskItemListVCDelegate {
    func saveNew(item: Item) {
    
        guard !taskItemList.contains(item) else {
            presentTDAlertOnMainThread(title: "Something wen't wrong 😅", message: TDError.taskITemAlreadyExists.rawValue, buttonTitle: "Ok")
            return
        }
        
        parentCategory.items.append(item)
        
        PersistenceManager.update(category: parentCategory, actionType: .update) {[weak self] (error) in
            guard let self = self else { return }
            guard let error = error else {
                self.updateItemList()
                return
            }
            self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
        }

    }
    
    
}
