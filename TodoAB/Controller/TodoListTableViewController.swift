//
//  MainTableViewController.swift
//  TodoAB
//
//  Created by Lore P on 11/04/2023.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListTableViewController: SwipeTableViewController {
  
  
  // MARK: - Properties
  let realm = try! Realm()
  
  var todoItems: Results<ListItem>?
  
  @IBOutlet weak var searchBar: UISearchBar!
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  
  
  
  
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let color = selectedCategory?.color {
      guard let navBar = navigationController?.navigationBar else {
        fatalError("Navigation Controller does not exist")
      }
      
      title = selectedCategory!.name
      
      searchBar.barTintColor = HexColor(color)

      if let navBarColor =  UIColor(hexString: color) {
        
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navBarColor
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = navBar.standardAppearance
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
      }
    }
  }
  
  // MARK: - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { action in
      
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            
            let newItem = ListItem()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            
            currentCategory.listItems.append(newItem)
          }
        } catch {
          print("Error writing realm : \(error)")
        }
      }
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create New Item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  
  // MARK: - Load, Delete
  func loadItems() {
    todoItems = selectedCategory?.listItems.sorted(byKeyPath: "title", ascending: true)
    
    tableView.reloadData()
  }
  
  override func updateModel(at indexPath: IndexPath) {
    
    if let itemToDelete = todoItems?[indexPath.row] {
      
      do {
        try self.realm.write {
          self.realm.delete(itemToDelete)
        }
      } catch {
        print("Error deleting todoItem: \(error)")
      }
    }
  }
}
  


// MARK: - DS and Delegate
extension TodoListTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    
    
    
    if let item = todoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      cell.accessoryType = item.done ? .checkmark : .none
      
      if let categoryColor = HexColor(selectedCategory!.color),
          let color = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
      }
      
    } else {
      cell.textLabel?.text = "No Items Added Yet"
    }
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done.toggle()
        }
      } catch {
        print("Error saving checkmark: \(error)")
      }
    }
    
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
  


// MARK: - Search Bar Delegate
extension TodoListTableViewController: UISearchBarDelegate {


  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?
      .filter("title CONTAINS[cd] %@", searchBar.text!)
      .sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
  }


  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()

      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}
