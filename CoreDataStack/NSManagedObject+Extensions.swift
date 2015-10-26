//
//  NSManagedObject+Extensions.swift
//  CoreDataStack
//
//  Created by Cory Sullivan on 10/25/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    public class var entityName : String {
        let components = NSStringFromClass(self).componentsSeparatedByString(".")
        return components[1]
    }
    
    public class func fetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName:self.entityName)
    }
    
    public class func fetchRequestWithKey(key: String, ascending: Bool = true) -> NSFetchRequest {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: key, ascending: ascending)]
        return request
    }
}