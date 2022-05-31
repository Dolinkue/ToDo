//
//  CategoryTableViewController.swift
//  Todo
//
//  Created by Nicolas Dolinkue on 31/05/2022.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
     
        loadCategory()
      
    }



   
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
       
        var texField = UITextField()
        
        let alert = UIAlertController(title: "Add new items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // let context es para acceder al context del appdelegate
         //   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoryArray.count
    }
    
    // MARK: - Table view Delegate
    
    
    
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
