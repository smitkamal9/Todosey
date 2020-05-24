//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Smit Kamal on 5/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
           guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
//               if let selectedCategory = self.categoryArray?[indexPath.row]{
//                   do{
//                       try self.realm.write{
//                           self.realm.delete(selectedCategory)
//                       }
//                   }catch{
//                       print("Error deleting category. Error: \(error)")
//                   }
//               }
           }

           // customize the action appearance
           deleteAction.image = UIImage(named: "delete")

           return [deleteAction]
       }
       
       func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
           var options = SwipeOptions()
           options.expansionStyle = .destructive
           return options
       }
    
    func updateModel(at indexPath:IndexPath){
        
    }
    
}

