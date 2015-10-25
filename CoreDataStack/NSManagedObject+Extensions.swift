//
//  NSManagedObject+Extensions.swift
//  CoreDataStack
//
//  Created by Cory Sullivan on 10/25/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    class var entityName : String {
        let components = NSStringFromClass(self).componentsSeparatedByString(".")
        return components[1]
    }
    
    class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName:self.entityName)
    }
    
    class func fetchRequestWithKey(key: String, ascending: Bool = true) -> NSFetchRequest {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        return request
    }
}