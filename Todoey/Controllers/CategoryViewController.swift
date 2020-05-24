//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Smit Kamal on 4/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        loadData()
    }
    
    // MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "Category Does not Exist"
        let cellColor = category?.categoryColor ?? "#FFFFFF"
        cell.backgroundColor = UIColor(hexString: cellColor)
        return cell
    }
    
    
    
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK:- Data Manipulation Methods
    func loadData()  {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category:Category) {
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let selectedCategory = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(selectedCategory)
                }
            }catch{
                print("Error deleting category. Error: \(error)")
            }
        }
        
    }
    // MARK:- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newcategory = Category()
            newcategory.name = textField.text!
            let colorHex = UIColor.randomFlat().hexValue()
            newcategory.categoryColor = colorHex
            self.save(category: newcategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField  = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


