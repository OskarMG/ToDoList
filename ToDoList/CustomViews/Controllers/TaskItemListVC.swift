//
//  TaskItemListVC.swift
//  ToDoList
//
//  Created by Oscar Martinez on 9/1/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

protocol TaskItemListVCDelegate: class {
    func save(item: Item)
}

class TaskItemListVC: UIViewController {
    
    let tableView       = UITableView()
    var taskItemList    = [Item]()
    
    
    init(itemList: [Item]) {
        super.init(nibName: nil, bundle: nil)
        self.taskItemList = itemList
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
}


extension TaskItemListVC: TaskItemListVCDelegate {
    func save(item: Item) {
        
        print(item)
    }
    
    
}
