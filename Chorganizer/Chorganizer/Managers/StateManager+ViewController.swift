//
//  StateManager+ViewController.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/20/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import Alamofire

// MARK: - UIViewController interaction

extension StateManager {
    func changeTeammateColor(viewController: UIViewController, teammate: Teammate, newColorName: String) {
        if let _ = viewController as? IntroScreenViewController {
            let colorNames = IntroScreenViewController.allColors.keys.map({ $0 })
            debugPrint(realm.objects(Teammate.self))
            if colorNames.contains(newColorName) {
                try! self.realm.write {
                    teammate.colorName = newColorName
                }
                //StateManager.sharedInstance.processEvent(event: .updateTeammate(teammate))
            } else {
                return
            }
            
            //let row = vc.tableView.row
            
            
//            if let row = colorNames.index(where: { $0 == newColorName }) {
//                let idxPath = IndexPath(row: row, section: 0)
//                vc.tableView.reloadRows(at: [idxPath], with: .automatic)
//            }
        }
    }
}
