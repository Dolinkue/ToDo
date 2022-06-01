//
//  ViewController.swift
//  Todo
//
//  Created by Nicolas Dolinkue on 27/05/2022.
//

import UIKit
import CoreData
import SwipeCellKit


class TodoListViewController: UITableViewController {

    
    var itemArray = [Item2]()
    
    var selectedCategory : Category? {
        didSet {
            loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = 80.0
        self.title = selectedCategory?.name
        
        
        
    }
    
    
    
    // MARK: TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

            
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
            
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: add new Item

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // let context es para acceder al context del appdelegate
         //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item2(context: self.context)
            newItem.title = texField.text!
            newItem.parentCategoty = self.selectedCategory
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            
        }
        
        alert.addTextField { alertText in
            alertText.placeholder = "Create new item"
            texField = alertText
        }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItem() {
        do {
           try context.save()
        } catch {
            print("error saving \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItem(with request: NSFetchRequest<Item2> = Item2.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategoty.name MATCHES %@", selectedCategory!.name!)
        
        
        if let addtionalpredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalpredicate])
        } else {
            request.predicate = categoryPredicate
        }
      
        do {
           itemArray =  try context.fetch(request)
        } catch {
            print("error saving \(error.localizedDescription)")
        }
        
    }
    
}


// MARK: SearchBar


extension TodoListViewController: UISearchBarDelegate {
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItem()
        } else {
            
            let request : NSFetchRequest<Item2> = Item2.fetchRequest()
            
            let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            
            loadItem(with:request, predicate: predicate)
            
            
            
        }
        
        tableView.reloadData()
    }
    
    
}
    
extension TodoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            self.saveItem()
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }
    
    
}

