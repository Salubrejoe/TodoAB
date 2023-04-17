//
//  CategoriesTableViewController.swift
//  TodoAB
//
//  Created by Lore P on 12/04/2023.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoriesTableViewController: SwipeTableViewController {
  
  // MARK: - Properties
  let realm = try! Realm()
  
  var categories: Results<Category>?
  
  
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let navBar = navigationController?.navigationBar {
      let appearance = UINavigationBarAppearance()
      
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .systemPink
      navBar.standardAppearance = appearance
      navBar.scrollEdgeAppearance = navBar.standardAppearance
    }
  }
  
  
  
  // MARK: - Add New Category
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { action in

      
      let newCategory = Category()
      newCategory.name = textField.text!
      newCategory.color = UIColor.randomFlat().hexValue()
      
      self.save(category: newCategory)
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { alertTextField in
      alertTextField.placeholder = "Create New Category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
  
  
  // MARK: - Save, Load, Delete
  
  func save(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving categories: \(error)")
    }
    
    tableView.reloadData()
  }
  
  func loadCategories() {

    categories = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  override func updateModel(at indexPath: IndexPath) {
    
    if let categoryToDelete = categories?[indexPath.row] {
      
      do {
        try self.realm.write{
          self.realm.delete(categoryToDelete)
        }
      } catch {
        print("Error deleting category: \(error)")
      }
    }
  }
  
}


// MARK: - DS and Delegte
extension CategoriesTableViewController {
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
    if let color = categories?[indexPath.row].color {
      let backgroundColor = HexColor(color)
      cell.backgroundColor = backgroundColor
      cell.textLabel?.textColor = ContrastColorOf(backgroundColor!, returnFlat: true)
    } else {
      cell.backgroundColor = .black
    }
    
    return cell
  }
  
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListTableViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
}
