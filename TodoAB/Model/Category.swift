//
//  Category.swift
//  TodoAB
//
//  Created by Lore P on 13/04/2023.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name = ""
  @objc dynamic var color = ""
  
  // Relationship
  let listItems = List<ListItem>()
}
