//
//  NSFileManger+Helpers.swift
//  MVVMCoreData
//
//  Created by Cory Sullivan on 10/4/15.
//  Copyright © 2015 Cory Sullivan. All rights reserved.
//

import Foundation

extension NSFileManager {
    
    enum FileManagerError: ErrorType {
        case DirectoryNotFound
        case ExcutableNameNotFound
    }
    
    func findOrCreateDirectory(searchPath: NSSearchPathDirectory, inDomain: NSSearchPathDomainMask, appendPathComponent: String?) throws -> NSURL {
        
        let urls = URLsForDirectory(searchPath, inDomains: inDomain)
        //Normally you just need the first path
        let resolvedURLPath = urls.first
        guard var path = resolvedURLPath else {
            throw FileManagerError.DirectoryNotFound
        }
        if let appendPath = appendPathComponent {
            path = path.URLByAppendingPathComponent(appendPath)
        }
        try createDirectoryAtURL(path, withIntermediateDirectories: true, attributes: nil)
        return path
    }
    
    func applicationSupportDirectory() throws -> NSURL {
        let executableName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleExecutable")
        guard let exName = executableName as? String else {
            throw FileManagerError.ExcutableNameNotFound
        }
        let applicationDirectory = try findOrCreateDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appendPathComponent: exName )
        return applicationDirectory
    }
}
