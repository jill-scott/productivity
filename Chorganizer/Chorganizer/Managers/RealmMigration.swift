//
//  RealmMigration.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/19/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit
import RealmSwift

// For each new migration, follow these steps:
// 1. Add a new case at the bottom of the SchemaVersion enum
// 2. Change latestSchemaVersion to equal the newly added enum, e.g.,
//    "latestSchemaVersion = SchemaVersion.newSchemaCase.rawValue"
// 3. Add a new "if" block that performs the necessary migration behaviors using
//    the pattern "if oldSchemaVersion < SchemaVersion.newSchemaCase.rawValue"

class RealmMigration {
    enum SchemaVersion: UInt64 {
        case realmSetup = 1
        case realmSetup2 = 2
        
        static var latestSchemaVersion = SchemaVersion.realmSetup2.rawValue
    }
    
    static func performRealmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used version
            schemaVersion: SchemaVersion.latestSchemaVersion,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                
                if oldSchemaVersion < SchemaVersion.realmSetup.rawValue {
                    // Set up initial realm data
                }
                
                if oldSchemaVersion < SchemaVersion.realmSetup2.rawValue {
                    
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
