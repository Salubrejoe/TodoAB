//
//  Item.swift
//  TodoAB
//
//  Created by Lore P on 13/04/2023.
//

import Foundation
import RealmSwift

class ListItem: Object {
  @objc dynamic var title = ""
  @objc dynamic var done = false
  @objc dynamic var dateCreated: Date?
  
  // Inverse relationship
  var parentCategory = LinkingObjects(fromType: Category.self, property: "listItems")
}
