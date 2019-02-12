//
//  Team.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/19/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit
import RealmSwift

final class Team: Object {
    
    let teammates = List<Teammate>()
    @objc dynamic var name: String = ""
    
    convenience public init(name: String) {
        self.init()
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
