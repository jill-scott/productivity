//
//  EditTeammateViewController.swift
//  Chorganizer
//
//  Created by Jill Scott on 8/15/18.
//  Copyright © 2018 Jill. All rights reserved.
//

import UIKit

protocol EditTeammateViewControllerDelegate: class {
    func didSaveDetails(_ name: String, colorName: String)
}

class EditTeammateViewController: UIViewController {
    weak var delegate: EditTeammateViewControllerDelegate?
    
    @IBOutlet var colorPicker: UIPickerView!
    @IBOutlet var nameField: UITextField!
    
    var name: String?
    var selectedColor: String?
    var colorNames: [String] = [] {
        didSet {
            if colorPicker != nil {
                colorPicker.reloadComponent(0)
            }
        }
    }
    var colorSelected: ((Int, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let option = selectedColor, let row = colorNames.index(of: option) {
            colorPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        let selectedRow = colorPicker.selectedRow(inComponent: 0)
        colorSelected?(selectedRow, colorNames[selectedRow])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate

extension EditTeammateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorNames[row]
    }
}
