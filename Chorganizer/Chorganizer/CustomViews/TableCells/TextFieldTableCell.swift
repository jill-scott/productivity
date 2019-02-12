//
//  TextFieldTableCell.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/7/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit

class TextFieldTableCell: UITableViewCell, AppTableCell {
    
    @IBOutlet weak var colorButton: UIButton!
    
    func setColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    
    
}
