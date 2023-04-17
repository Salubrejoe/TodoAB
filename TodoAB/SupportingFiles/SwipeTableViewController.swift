//
//  SwipeTableViewController.swift
//  TodoAB
//
//  Created by Lore P on 14/04/2023.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .none
  }

  // MARK: - Table View Datasouce
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
    
    cell.delegate = self
    
    return cell
  }
  
  // MARK: - Table View Delegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  
  
  // MARK: - SwipeCell Delegate
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
      
      self.updateModel(at: indexPath)
    }
    
    deleteAction.image = UIImage(systemName: "trash")
    
    return [deleteAction]
  }
  
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    
    return options
  }
  

  // MARK: - UpdateModel/Delete
  func updateModel(at indexPath: IndexPath) {}
}
