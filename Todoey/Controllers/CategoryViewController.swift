//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Smit Kamal on 4/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }

    // MARK:- Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    

    
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK:- Data Manipulation Methods
    func loadData(with request:NSFetchRequest<Category> = Category.fetchRequest())  {
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        }catch{
            print("Error Decoding")
        }
        tableView.reloadData()
    }
    
    func saveCategory() {
        
        do{
            try context.save()
        }catch{
            print("Error saving context")
        }
        self.tableView.reloadData()
    }
    
    // MARK:- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newcategory = Category(context: self.context)
            newcategory.name = textField.text!
            self.categoryArray.append(newcategory)
            self.saveCategory()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField  = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
