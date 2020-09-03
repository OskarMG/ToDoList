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
    
    let tableView               = UITableView()
    var categoryList            = [Category]()
    var filteredCategoryList    = [Category]()
    var isSearching             = false
    
    var numberOfRowInSection: Int {
        get { isSearching ? filteredCategoryList.count : categoryList.count }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        configureAddButton()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCategoryList()
        print(numberOfRowInSection, categoryList.count, isSearching)
    }
    
    
    private func configure() {
        title                   = "Category"
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.delegate     = self
        searchController.searchBar.placeholder  = "Seach for a category"
        navigationItem.searchController         = searchController
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame             = view.bounds
        tableView.tableFooterView   = UIView(frame: CGRect.zero)
        tableView.rowHeight         = 70
        tableView.delegate          = self
        tableView.dataSource        = self
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
    
    func refreshCategoryList() {
        PersistenceManager.retriveCategories {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categoryList = categories
                DispatchQueue.main.async { self.tableView.reloadData() }
            case .failure(let error):
                self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
                break
            }
        }
    }
}


extension CategoryListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID) as! CategoryCell
        
        let activeArray = isSearching ? filteredCategoryList : categoryList
        let category    = activeArray[indexPath.row]
        
        cell.set(name: category.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let activeArray     = isSearching ? filteredCategoryList : categoryList
        let category        = activeArray[indexPath.row]
        let taskItemListVC  = TaskItemListVC(Category: category)
        navigationController?.pushViewController(taskItemListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        var category: Category!
        
        switch isSearching {
            case true:
                category = filteredCategoryList[indexPath.row]
                filteredCategoryList.remove(at: indexPath.row)
            case false:
                category = categoryList[indexPath.row]
                categoryList.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .left)
        guard category != nil else { return }
        
        PersistenceManager.update(category: category, actionType: .remove) {[weak self] (error) in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}

extension CategoryListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredCategoryList = categoryList.filter { $0.name.lowercased().contains(filter.lowercased()) }
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        refreshCategoryList()
    }
}

extension CategoryListVC: CategoryListVCDelegate {
    func save(category: Category) {
        PersistenceManager.update(category: category, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.refreshCategoryList()
                return
            }
            self.presentTDAlertOnMainThread(title: "Ups something wen't wrong 😅", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
