//
//  AppTableCell.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/7/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit

protocol AppTableCell: class {
    // Reuse Identifier to be used across all view controllers.
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension AppTableCell where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static func load(owner: Any? = nil) -> Self? {
        let topLevelObjects = Bundle.main.loadNibNamed(Self.nibName, owner: owner, options: nil)
        return topLevelObjects?.first as? Self
    }
}

// MARK: UITableView + AppTableCell Helpers

extension UITableView {
    func register(_ appCell: AppTableCell.Type) {
        register(UINib(nibName: appCell.nibName, bundle: nil), forCellReuseIdentifier: appCell.reuseIdentifier)
    }
    
    func dequeueReusableAppCell<T: AppTableCell>(_ aType: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: aType.reuseIdentifier, for: indexPath) as! T
    }
}
