//
//  Teammate.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/15/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit
import RealmSwift

final class Teammate: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colorName: String = "white"
    
    convenience public init(name: String, colorName: String) {
        self.init()
        self.name = name
        self.colorName = colorName
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

