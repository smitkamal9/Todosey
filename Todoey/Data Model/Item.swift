//
//  Item.swift
//  Todoey
//
//  Created by Smit Kamal on 5/16/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date = Date()
    var parentObject = LinkingObjects(fromType: Category.self, property: "items")
}
