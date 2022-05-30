//
//  ViewController.swift
//  Todo
//
//  Created by Nicolas Dolinkue on 27/05/2022.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item2]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItem()
        
        
    }
    
    
    
    // MARK: TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
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
    
    func loadItem(with request: NSFetchRequest<Item2> = Item2.fetchRequest()) {
        
      
        do {
           itemArray =  try context.fetch(request)
        } catch {
            print("error saving \(error.localizedDescription)")
        }
        
    }
    
}


// MARK: SearchBar


extension TodoListViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item2> = Item2.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptr]
        
       loadItem(with: request)
        
    }
    
}

