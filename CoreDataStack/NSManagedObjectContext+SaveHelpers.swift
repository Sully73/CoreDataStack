//
//  NSManagedObjectContext+Extensions.swift
//  CoreDataSMS
//
//  Created by Robert Edwards on 2/23/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import CoreData

public typealias CoreDataStackSaveCompletion = SaveResult -> Void

public extension NSManagedObjectContext {

    /**
    Convenience method to synchronously save the managed object context if changes are present. 
    Method also ensures that the save is executed on the correct queue when using Main/Private queue concurrency types.
    */
    public func saveContextAndWait() throws {
        var saveError: ErrorType?
        switch concurrencyType {
        case .ConfinementConcurrencyType:
            do {
                try sharedSaveFlow()
            } catch let error {
                throw error
            }
        case .MainQueueConcurrencyType,
        .PrivateQueueConcurrencyType:
            self.performBlockAndWait { [unowned self] in
                do {
                    try self.sharedSaveFlow()
                } catch let error {
                    saveError = error
                }
            }
        }

        if let saveError = saveError {
            throw saveError
        }
    }

    /**
    Convenience method to asynchronously save the managed object context if changes are present.
    Method also ensures that the save is executed on the correct queue when using Main/Private queue concurrency types.

    :param: completion Completion closure with a SaveResult to be executed upon the completion of the save operation.
    */
    public func saveContext(completion: CoreDataStackSaveCompletion? = nil) {
        let saveFlow: (CoreDataStackSaveCompletion?) -> () = { [unowned self] completion in
            do {
                try self.sharedSaveFlow()
                completion?(.Success)
            } catch let saveError {
                completion?(.Failure(saveError))
            }
        }

        switch concurrencyType {
        case .ConfinementConcurrencyType:
            saveFlow(completion)
        case .PrivateQueueConcurrencyType,
        .MainQueueConcurrencyType:
            self.performBlock {
                saveFlow(completion)
            }
        }
    }

    private func sharedSaveFlow() throws {
        if hasChanges {
            do {
                try save()
            } catch let error {
                throw error
            }
        }
    }
    
    public func insert<T : NSManagedObject>(entity: T.Type) -> T {
        let entityName = entity.entityName
        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext:self) as! T
    }
    
    public func fetchAll<T : NSManagedObject>(entity: T.Type, key:String? = nil, ascending:Bool = true) -> [T] {
        let fetchRequest : NSFetchRequest = {
            if let key = key {
                return entity.fetchRequestWithKey(key, ascending: ascending)
            } else {
                return entity.fetchRequest()
            }
        }()
        
        do {
            guard let results = try executeFetchRequest(fetchRequest) as? [T] else {
                return [T]()
            }
            return results
        }
        catch let error as NSError {
            fatalError("Error Fetching: \(error.localizedDescription) for reason: \(error.localizedFailureReason)")
        }
    }

}
