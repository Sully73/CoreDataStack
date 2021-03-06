//
//  Author.swift
//  CoreDataStack
//
//  Created by Robert Edwards on 4/27/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreData

@objc(Author)
class Author: NSManagedObject {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var books: Set<Book>

    class func newAuthorInContext(context: NSManagedObjectContext) -> Author {
        return NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: context) as! Author
    }

    class func allAuthorsInContext(context: NSManagedObjectContext) throws -> [Author] {
        let fr = NSFetchRequest(entityName: "Author")
        return try! context.executeFetchRequest(fr) as! [Author]
    }
}
