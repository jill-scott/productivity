//
//  BasicTableCell.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/9/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit

class BasicTableCell: UITableViewCell, AppTableCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
            
            let textColor = isEnabled ? UIColor.black : UIColor.gray
            titleLabel.textColor = textColor
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //showDisclosureIndicator(true)
        titleLabel.text = ""
        isEnabled = true
    }
    
    // MARK: - Instance
    
//    func showDisclosureIndicator(_ show: Bool) {
//        showDisclosureIndicator(show)
//    }
    
    func updateColor(color: UIColor) {
        backgroundColor = color
    }
}

