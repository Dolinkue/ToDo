//
//  ViewController.swift
//  Todo
//
//  Created by Nicolas Dolinkue on 27/05/2022.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = [DataModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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
        
        

            
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            
         
 
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    // MARK: add new Item

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            var newItem = DataModel()
            newItem.title = texField.text ?? ""
            
            self.itemArray.append(newItem)
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertText in
            alertText.placeholder = "Create new item"
            texField = alertText
        }
        
        alert.addAction(action)
            
        present(alert, animated: true, completion: nil)
        
    }
    
}


