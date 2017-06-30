//
//  SettingsViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/23/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import MessageUI

var roundedValues = true
var nightMode = false
var calculateRatio = false

var tapClose = false
var fixedPoint = false

class SettingsViewController: UIViewController, UIGestureRecognizerDelegate{
    
    fileprivate var sectionHeaderTitles = ["General", "Themes", "Application"]
    
    fileprivate var labels = [
        ["Calculate Ratio", "Round Values"], ["Bright", "Dark"],
        ["Send Feedback", "Rate Aspetica", "Share Aspetica"]
    ]
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var panImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadow: UIView!
    
    @IBOutlet weak var footerView: UILabel!
    
    fileprivate var bottomBorders: [UIView] = []
    fileprivate var topBorders: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        navBar.layer.cornerRadius = 8
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48
        nonTableColorSetup(animated: false)
        tableColorSetup(animated: false)
        
        footerView.sizeToFit()
        setVersion()
    }
    
    @IBAction func crossDragOutside(_ sender: UIButton) {
        sender.layer.opacity = 1.0
    }
    
    @IBAction func iconTouchUp(_ sender: Any) {
        (sender as! UIButton).layer.opacity = 1.0
    }
    
    @IBAction func dismiss() {
        tapClose = true
        dismiss(animated: true, completion: nil)
        closeButton.layer.opacity = 1
    }
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var interactor:Interactor? = nil
    
    var indicator = false
    
    @IBAction func panDismiss(_ sender: UIPanGestureRecognizer) {
        print("why")
        if UIApplication.shared.statusBarFrame.height == 20 {
            tapClose = false
            let percentThreshold:CGFloat = 0.25
            let velocity = sender.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x))
            var slideMultiplier = magnitude / 200
            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
            // convert y-position to downward pull progress (percentage)
            let translation = sender.translation(in: tempView)
            let verticalMovement = translation.y / tempView.bounds.height
            let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
            let downwardMovementPercent = fminf(downwardMovement, 1.0)
            let progress = CGFloat(downwardMovementPercent)
            guard let interactor = interactor else { return }
            switch sender.state {
            case .began:
                interactor.hasStarted = true
                dismiss(animated: true, completion: nil)
            case .changed:
                interactor.shouldFinish = progress > percentThreshold
                if slideMultiplier > 0.1 && velocity.y > 0{
                    interactor.shouldFinish = true
                    indicator = true
                }else if velocity.y < 0{
                    interactor.shouldFinish = false
                    
                } else if interactor.shouldFinish{
                    indicator = false
                    interactor.shouldFinish = true
                } else {
                    interactor.shouldFinish = false
                }
                interactor.update(progress)
            case .ended:
                interactor.hasStarted = false
                if slideMultiplier < 1{
                    slideMultiplier = 1
                }
                if interactor.shouldFinish {
                    if !indicator{
                        interactor.completionSpeed = slideMultiplier * 2//3
                    } else {
                        interactor.completionSpeed = slideMultiplier * 3
                    }
                    interactor.finish()
                } else {
                    interactor.completionSpeed = slideMultiplier * 1.3
                    interactor.cancel()
                }
            default:
                break
            }
        }
    }
    
    @IBAction func closeDown(_ sender: UIButton) {
        closeButton.layer.opacity = 0.4
    }
    
    func switchChanged(sender: UISwitch!) {
        switch sender.tag {
        case 2:
            if calculateRatio{
                calculateRatio = false
            } else {
                calculateRatio = true
            }
//            if #available(iOS 10.3, *) {
//                if UIApplication.shared.supportsAlternateIcons {
//                    // let the user choose a new icon
//                    if nightMode{
//                        UIApplication.shared.setAlternateIconName("AppIcon-2")
//                    } else {
//                        UIApplication.shared.setAlternateIconName(nil)
//                    }
//                } else {
//                    print("Oops")
//                }
//            }
        case 0:
            if roundedValues {
                roundedValues = false
                fixedPoint = true
            } else {
                roundedValues = true
                fixedPoint = false
            }
            print("Rounded values changed")
        default: break
        }
        loadSettings()
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        defaults.setValue(nightMode, forKey: "nightMode")
        defaults.setValue(roundedValues, forKey: "roundedValues")
        defaults.setValue(calculateRatio, forKey: "calculateRatio")
        print("Settings loaded")
    }
    
    private func setVersion(){
        if let version = Bundle.main.releaseVersionNumber {
            if let build = Bundle.main.buildVersionNumber {
                let attributedString = NSMutableAttributedString(string: "Version \(version) (\(build))\nby Artem Misesin and Alex Suprun")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 7
                
                attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
                footerView.attributedText = attributedString
                footerView.textAlignment = .center
            }
        }
    }
}

// Setting up the table

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func cellSetup(of cell: CustomCell) {
        let borderHeight: CGFloat = 0.5
        let bottomY = cell.bounds.maxY - borderHeight
        let topY = cell.bounds.minY
        let topBorder = UIView(frame: CGRect(x: 16, y: topY, width: cell.bounds.width - 32, height: borderHeight))
        let bottomBorder = UIView(frame: CGRect(x: 16, y: bottomY, width: cell.bounds.width - 32, height: borderHeight))
        if let label = cell.textLabel!.text {
            switch label {
            case "Calculate Ratio":
                let ratioSwitch = UISwitch()
                if calculateRatio {
                    ratioSwitch.isOn = true
                } else {
                    ratioSwitch.isOn = false
                }
                ratioSwitch.onTintColor = ColorConstants.deleteColor
                ratioSwitch.tag = 2
                cell.accessoryView = ratioSwitch
                ratioSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
            case "Round Values":
                let roundedValuesSwitch = UISwitch()
                if roundedValues {
                    roundedValuesSwitch.isOn = true
                } else {
                    roundedValuesSwitch.isOn = false
                }
                roundedValuesSwitch.onTintColor = ColorConstants.deleteColor
                roundedValuesSwitch.tag = 0
                cell.accessoryView = roundedValuesSwitch
                roundedValuesSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
            case "Dark Theme":
                let nightModeSwitch = UISwitch()
                if nightMode {
                    nightModeSwitch.isOn = true
                } else {
                    nightModeSwitch.isOn = false
                }
                nightModeSwitch.onTintColor = ColorConstants.deleteColor
                nightModeSwitch.tag = 1
                cell.accessoryView = nightModeSwitch
                nightModeSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
                cell.addSubview(bottomBorder)
            case "Share Aspetica":
                cell.addSubview(bottomBorder)
            case "Dark":
                if nightMode{
                    cell.accessoryType = .checkmark
                    cell.tintColor = ColorConstants.settingsText
                }
                cell.addSubview(bottomBorder)
            case "Bright":
                if !nightMode{
                    cell.accessoryType = .checkmark
                    cell.tintColor = ColorConstants.settingsText
                }
            default: break;
            }
            cell.detailTextLabel?.text = ""
            bottomBorders.append(bottomBorder)
            topBorders.append(topBorder)
            cell.addSubview(topBorder)
            tableColorSetup(animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CustomCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.section == 0 {
            cell.selectionStyle = .none
        } else {
            cell.selectionStyle = .default
        }
        
        cell.textLabel?.text = labels[indexPath.section][indexPath.row]
        cellSetup(of: cell)
        cellColorSetup(of: cell, animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 2 {
            switch indexPath.row {
            case 2:
                shareApp(at: indexPath)
            case 0:
                sendEmail(from: indexPath)
            case 1:
                let appID = "1197016359"
                rateApp(appId: appID) {(success) in
                    tableView.deselectRow(at: indexPath, animated: true)}
            default: break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if nightMode {
                    nightMode = false
                    ColorConstants.defaultMode()
                    colorSetup(animated: false)
                    for cell in self.tableView.visibleCells{
                        self.cellColorSetup(of: cell as! CustomCell, animated: false)
                    }
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    self.tableView.cellForRow(at: indexPath)?.tintColor = ColorConstants.settingsText
                    let index = IndexPath(row: 1, section: 1)
                    self.tableView.cellForRow(at: index)?.accessoryType = .none
                }
            case 1:
                if !nightMode {
                    nightMode = true
                    ColorConstants.nightMode()
                    colorSetup(animated: false)
                    for cell in self.tableView.visibleCells{
                        self.cellColorSetup(of: cell as! CustomCell, animated: false)
                    }
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    self.tableView.cellForRow(at: indexPath)?.tintColor = ColorConstants.settingsText
                    let index = IndexPath(row: 0, section: 1)
                    self.tableView.cellForRow(at: index)?.accessoryType = .none
                }
            default: break
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.prepareDisclosureIndicator()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = header.textLabel?.font.withSize(12)
        header.textLabel?.textColor = ColorConstants.symbolsColor
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0{
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return sectionHeaderTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sectionHeaderTitles[section]
    }

}

// Color setup

extension SettingsViewController{

    fileprivate func nonTableColorSetup(animated: Bool){
        if animated{
            UIView.transition(with: navBarTitle, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.navBarTitle.textColor = ColorConstants.cellTextColor
            }, completion: nil)
            UIView.transition(with: footerView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.footerView.textColor = ColorConstants.symbolsColor
            }, completion: nil)
            UIView.animate(withDuration: 0.25, animations: {
                self.navBar.backgroundColor = ColorConstants.settingsMainTint
                self.closeButton.tintColor = ColorConstants.iconsColor
                self.footerView.superview?.backgroundColor = ColorConstants.settingsMainTint
                self.tableShadow.backgroundColor = ColorConstants.settingsShadows
            })
        } else {
            navBarTitle.textColor = ColorConstants.cellTextColor
            footerView.textColor = ColorConstants.symbolsColor
            navBar.backgroundColor = ColorConstants.settingsMainTint
            closeButton.tintColor = ColorConstants.iconsColor
            footerView.superview?.backgroundColor = ColorConstants.settingsMainTint
            tableShadow.backgroundColor = ColorConstants.settingsShadows
        }
        
        self.view.backgroundColor = .clear
        //self.presentingViewController?.view.backgroundColor = .yellow
    }
    
    fileprivate func separatorsColorSetup(){
        for view in self.bottomBorders {
            UIView.animate(withDuration: 0.25, animations: {
                view.backgroundColor = ColorConstants.settingsShadows
            })
            
            for viewx in self.topBorders {
                UIView.animate(withDuration: 0.25, animations: {
                    viewx.backgroundColor = ColorConstants.settingsShadows
                })
                
            }
        }
    }
    
    fileprivate func tableColorSetup(animated: Bool){
        if animated{
            UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.tableView.headerView(forSection: 0)?.textLabel?.textColor = ColorConstants.symbolsColor
                self.tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
                self.tableView.backgroundColor = ColorConstants.settingsMainTint
            }, completion: nil)
        } else {
            tableView.headerView(forSection: 0)?.textLabel?.textColor = ColorConstants.symbolsColor
            tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
            tableView.headerView(forSection: 2)?.textLabel?.textColor = ColorConstants.symbolsColor
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.backgroundColor = ColorConstants.settingsMainTint
            for view in self.bottomBorders {
                view.layer.backgroundColor = ColorConstants.settingsShadows.cgColor
                for viewx in self.topBorders {
                    viewx.layer.backgroundColor = ColorConstants.settingsShadows.cgColor
                }
            }
        }
    }
    
    fileprivate func colorSetup(animated: Bool){
        tableColorSetup(animated: animated)
        nonTableColorSetup(animated: animated)
    }
    
    fileprivate func cellColorSetup(of cell: CustomCell, animated: Bool) {
        if animated{
            UIView.transition(with: cell, duration: 0.25, options: .transitionCrossDissolve, animations: {
                cell.textLabel?.textColor = ColorConstants.cellTextColor
                cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
                }, completion: nil)
        } else {
            //cell.backgroundColor = .clear
            cell.textLabel?.textColor = ColorConstants.cellTextColor
            cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
            if nightMode{
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
            } else {
                cell.accessoryView?.tintColor = UIColor(hexString: "#ECECEC", alpha: 1)
            }
            if let dogswitch = cell.accessoryView as! UISwitch? {
                dogswitch.onTintColor = ColorConstants.deleteColor
            }
            //if let av = cell.accessoryView {
                //av.tintColor = ColorConstants.accessoryViewColor
            //}
        }
        
    }
}

// User feedback features

extension SettingsViewController: MFMailComposeViewControllerDelegate{
    
    fileprivate func sendEmail(from indexPath: IndexPath) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["artemmisesin@gmail.com"])
            if let version = Bundle.main.releaseVersionNumber {
                if let build = Bundle.main.buildVersionNumber {
                    mail.setSubject("Aspetica \(version) (\(build)), \(UIDevice.current.modelName),  \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
                }
            }
            mail.setMessageBody("", isHTML: true)
            present(mail, animated: true, completion: {self.tableView.deselectRow(at: indexPath, animated: true)})
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func shareApp(at indexPath: IndexPath){
        let firstActivityItem = "Aspetica — Aspect Ratio Calculator"
        let secondActivityItem : NSURL = NSURL(string: "http://aspetica.sooprun.com")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)})
    }
    
    fileprivate func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "https://itunes.apple.com/app/id" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
}
