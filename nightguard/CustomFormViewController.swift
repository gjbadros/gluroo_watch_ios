//
//  CustomFormViewController.swift
//  nightguard
//
//  Created by Florian Preknya on 2/1/19.
//  Copyright © 2019 private. All rights reserved.
//

import UIKit
import Eureka

class CustomFormViewController: FormViewController {
    
    private static let dispatchOnce: Void = {
        customizeRows()
    }()
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    var reconstructFormOnViewWillAppear: Bool {
        return false
    }
    
    fileprivate var firstAppearance = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomFormViewController.dispatchOnce
        
        tableView.backgroundColor = UIColor.App.Preferences.background
        tableView.separatorColor = UIColor.App.Preferences.separator
        
        constructForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // only if the orientation is portrat we should consider reconstructing the form on view appear (otherwise it will crash!)
        if UIDevice.current.orientation == .portrait {
            reconstructFormIfNeeded()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // if did't have the chance to reconstruct the form on will appear because of the orientation, do it now!
        if UIDevice.current.orientation != .portrait {
            reconstructFormIfNeeded()
        }
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.App.Preferences.background
            header.textLabel?.textColor = UIColor.App.Preferences.headerText
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel?.textColor = UIColor.App.Preferences.footerText
        }
    }
    
    // to be implemented in subclasses
    func constructForm() {
    }
    
    private func reconstructFormIfNeeded() {
        
        if !firstAppearance {
            if reconstructFormOnViewWillAppear {
                
                // reconstruct the form if units were changed from last appearance
                UIView.performWithoutAnimation {
                    let scrollOffset = tableView.contentOffset
                    defer { tableView.contentOffset = scrollOffset }
                    form.removeAll()
                    constructForm()
                }
            }
        }
        
        firstAppearance = false
    }
    
    func playSuccessFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
    
    func displayErrorMessagePopup(message : String) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Popup Error Message Title"), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Popup Error-Ok-Button"), style: .default, handler: { (alert: UIAlertAction!) in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

/// Eureka form rows customization
extension CustomFormViewController {
    
    /// customization for all the rows used in the app
    static func customizeRows() {
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.customize()
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.App.Preferences.rowBackground
            cell.titleLabel?.textColor = UIColor.App.Preferences.text
            cell.textField?.textColor = UIColor.App.Preferences.text
//            cell.textField?.setValue(UIColor.App.Preferences.placeholderText, forKeyPath: "_placeholderLabel.textColor")
//            cell.textField?.setValue(UIFont.italicSystemFont(ofSize: 12), forKeyPath:"_placeholderLabel.font")
        }
        
        URLRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.App.Preferences.rowBackground
            cell.titleLabel?.textColor = UIColor.App.Preferences.text
            cell.textField?.textColor = UIColor.App.Preferences.text
            
            cell.textField.clearButtonMode = .whileEditing
        }
        
        SwitchRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.App.Preferences.rowBackground
            cell.textLabel?.textColor = UIColor.App.Preferences.text
        }
        
        SliderRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = UIColor.App.Preferences.rowBackground
            cell.titleLabel?.textColor = UIColor.App.Preferences.text
            cell.valueLabel?.textColor = UIColor.App.Preferences.detailText
            cell.tintColor = UIColor.App.Preferences.tint
        }
        
        PushRow<Int>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        ButtonRow.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        ButtonRowWithDynamicDetails.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        DateRow.defaultCellUpdate = { cell, row in
            cell.customize()
        }
        
        ListCheckRow<Int>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        StepperRow.defaultCellUpdate = { cell, row in
            cell.customize()
        }
        
        SegmentedRow<Int>.defaultCellUpdate = { cell, row in
            cell.customize()
        }
        
        PickerInlineRow<Int>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }

        PickerInlineRow<String>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        PickerInlineRow<Units>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
        }
        
        PickerRow<Int>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
            cell.pickerTextAttributes = [
                .foregroundColor : UIColor.App.Preferences.text
            ]
        }
        
        PickerRow<String>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
            cell.pickerTextAttributes = [
                .foregroundColor : UIColor.App.Preferences.text
            ]
        }
        
        PickerRow<Units>.defaultCellUpdate = { cell, row in
            cell.customize(selectable: true)
            cell.pickerTextAttributes = [
                .foregroundColor : UIColor.App.Preferences.text
            ]
        }
    }
}

extension BaseCell {
    
    func customize(selectable: Bool = false) {
        backgroundColor = UIColor.App.Preferences.rowBackground
        textLabel?.textColor = UIColor.App.Preferences.text
        detailTextLabel?.textColor = UIColor.App.Preferences.detailText
        
        tintColor = UIColor.App.Preferences.tint
        
        if selectable {
            let view = UIView()
            view.backgroundColor = UIColor.App.Preferences.selectedRowBackground
            selectedBackgroundView = view
        }
    }
}

/// customize the selector view controller
extension SelectorViewController {
    
    func customize(header: String? = nil, footer: String? = nil) {
        dismissOnSelection = false
        dismissOnChange = false
        enableDeselection = false

        let _ = view // TRICK to force loading the view
        tableView.backgroundColor = UIColor.App.Preferences.background
        tableView.separatorColor = UIColor.App.Preferences.separator
        
        var reload = false
        
        if let headerTitle = header {
            form.last?.header = HeaderFooterView(title: headerTitle)
            reload = true
        }
        
        if let footerTitle = footer {
            form.last?.footer = HeaderFooterView(title: footerTitle)
            reload = true
        }
        
        if reload {
            tableView?.reloadData()
        }
    }
}

extension SliderRow {
    
    class func glucoseLevelSlider(initialValue: Float, minimumValue: Float, maximumValue: Float, snapIncrementForMgDl: Float = 5.0) -> SliderRow {
        
        return SliderRow() { row in
                row.value = initialValue
            }.cellSetup { cell, row in
                
                let snapIncrement = (UserDefaultsRepository.units.value == .mgdl) ? snapIncrementForMgDl : 0.1
                
                let steps = (maximumValue - minimumValue) / snapIncrement
                row.steps = UInt(steps.rounded())
                cell.slider.minimumValue = minimumValue
                cell.slider.maximumValue = maximumValue
                row.displayValueFor = { value in
                    guard let value = value else { return "" }
                    let units = UserDefaultsRepository.units.value.description
                    
                    // Play haptic sound
                    if value.truncatingRemainder(dividingBy: snapIncrement) == 0 {
                        if let lastAssignedValue = row.lastSelectedValue {
                            if Int(lastAssignedValue * 10) != Int(value * 10) {
                                let uiImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                                uiImpactFeedbackGenerator.impactOccurred()
                            }
                        }
                    }
                    row.lastSelectedValue = value
                    
                    return String("\(value.cleanValue) \(units)")
                }
                
                // fixed width for value label
                let widthConstraint = NSLayoutConstraint(item: cell.valueLabel ?? UILabel(), attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 96)
                cell.valueLabel.addConstraints([widthConstraint])
        }
    }
}
