//
//  AppData.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/19/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import Foundation
import RealmSwift

/// A class used to hold arbitrary information for the application.
/// Should only be one

class AppData: Object {
    
    @objc dynamic var id: String = "1"
    
    let allTeams = List<Team>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
