//
//  PersistenceManager.swift
//  ToDoList
//
//  Created by Oscar Martinez on 8/31/20.
//  Copyright © 2020 oscmg. All rights reserved.
//

import UIKit

enum PersistenceType {
    case add, remove, update
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let categories = "categories"
    }
    
    
    static func update(category: Category, actionType: PersistenceType, completed: @escaping(TDError?)->Void) {
        retriveCategories { result in
            switch result {
                case .success(let categories):
                    var retrievedCategories = categories
                    
                    switch actionType {
                    case .add:
                        guard !retrievedCategories.contains(category) else {
                            completed(.categoryAlreadyExists)
                            return
                        }
                        retrievedCategories.append(category)
                    case .update:
                        retrievedCategories.removeAll { $0.name == category.name }
                        retrievedCategories.append(category)
                    case .remove:
                        retrievedCategories.removeAll { $0.name == category.name }
                    }
                    
                    completed(save(category: retrievedCategories))
                    
                case .failure(let error):
                    completed(error)
            }
        }
    }
    
    static func retriveCategories(completed: @escaping(Result<[Category], TDError>)->Void) {
        guard let categoriesData = defaults.object(forKey: Keys.categories) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let categories = try decoder.decode([Category].self, from: categoriesData)
            completed(.success(categories))
        } catch {
            completed(.failure(.couldNotRetriveData))
        }
    }
    
    static func save(category: [Category]) -> TDError? {
        do {
            let coder = JSONEncoder()
            let category = try coder.encode(category)
            defaults.set(category, forKey: Keys.categories)
            return nil
        } catch { return .couldNotSave }
    }
    
}
