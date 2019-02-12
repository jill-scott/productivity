//
//  PickerViewController.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/15/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit

class OptionPickerViewController: UIViewController {
    
    @IBOutlet var picker: UIPickerView!
    
    var options: [String] = [] {
        didSet {
            if picker != nil {
                picker.reloadComponent(0)
            }
        }
    }
    
    var optionSelected: ((Int, String) -> Void)?
    var selectedOption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let option = selectedOption, let row = options.index(of: option) {
            picker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let selectedRow = picker.selectedRow(inComponent: 0)
        optionSelected?(selectedRow, options[selectedRow])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate

extension OptionPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
}

