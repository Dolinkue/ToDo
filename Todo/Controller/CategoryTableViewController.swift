//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Nicolas Dolinkue on 31/05/2022.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // let context es para acceder al context del appdelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadCategory()
        
        tableView.rowHeight = 80.0
        
       
      
    }



   
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
       
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
 
       
            let newItem = Category(context: self.context)
            newItem.name = texField.text!
          
            
            self.categoryArray.append(newItem)
            
            self.saveCategory()
            
            
        }
        
        alert.addTextField { alertText in
            alertText.placeholder = "Create new item"
            texField = alertText
        }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoryArray.count
    }
    
    // MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destination = segue.destination as? TodoListViewController
            
        if let index = tableView.indexPathForSelectedRow {
            destination!.selectedCategory = categoryArray[index.row]
        }
    }

    
    // MARK: - Table view Manipulation Methods
    
    func saveCategory() {
        do {
           try context.save()
        } catch {
            print("error saving \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
      
        do {
           categoryArray =  try context.fetch(request)
        } catch {
            print("error saving \(error.localizedDescription)")
        }
        
    }
    
    

}

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            do {
                try self.context.save()
            } catch {
                print("error saving \(error.localizedDescription)")
            }
            
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.fill")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

    
    
}
