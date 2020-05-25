//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    //let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //File path to the document folder
        
        searchBar.delegate = self
    }
    
    //MARK - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let categoryHexColor = selectedCategory!.categoryColor
            let cellColor = UIColor(hexString: categoryHexColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count))
            cell.backgroundColor = cellColor
            cell.textLabel?.textColor = ContrastColorOf(cellColor!, returnFlat: true)
        } else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let selectedItem = itemArray?[indexPath.row]{
            do{
                try realm.write{
                    selectedItem.done = !selectedItem.done
                }}catch{
                    print("Error changing status, Error:\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Item
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving item")
                }
            }
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField  = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadData()  {
        itemArray = selectedCategory?.items.sorted(byKeyPath:"date", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let selectedItem = self.itemArray?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(selectedItem)
                }
            }catch{
                print("Error deleting category. Error: \(error)")
            }
        }
        
    }
    
    
}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            DispatchQueue.main.async {
                self.loadData()
            }
        }
    }
}
