//
//  SettingsViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/23/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dismissable, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    private var labels = [
        ["Round Values", "Dark Theme"], ["Send Feedback", "Rate Aspetica", "Share Aspetica"]
    ]
    
    var counter = 0
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadow: UIView!
    
    @IBOutlet weak var footerView: UILabel!
    
    private var sectionHeaderTitles = ["General", "Application"]
    
    private var bottomBorders: [UIView] = []
    private var topBorders: [UIView] = []
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
        closeButton.layer.opacity = 1
    }
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var interactor:Interactor? = nil
    
    @IBAction func panDismiss(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))

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
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
    @IBAction func closeDown(_ sender: UIButton) {
        closeButton.layer.opacity = 0.4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        navBar.layer.cornerRadius = 8
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48
        
        footerView.sizeToFit()
        if let version = Bundle.main.releaseVersionNumber {
            if let build = Bundle.main.buildVersionNumber {
                footerView.text = "Version \(version) (\(build))\nby Artem Misesin and Alex Suprun"
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels[section].count
    }
    
    @objc
    func switchChanged(_ sender: UISwitch!) {
        switch sender.tag {
        case 1:
            if UserDefaultsManager.nightMode {
                Color.defaultMode()
            } else {
                Color.nightMode()
            }
            UserDefaultsManager.nightMode = !UserDefaultsManager.nightMode
            tableView.reloadData()
        case 0:
            UserDefaultsManager.roundedValues = !UserDefaultsManager.roundedValues
        default: break
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
        cellSetup(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.prepareDisclosureIndicator()
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = header.textLabel?.font.withSize(12)
        header.textLabel?.textColor = Color.symbolsColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 2:
                let firstActivityItem = "Aspetica — Aspect Ratio Calculator"
                let secondActivityItem : NSURL = NSURL(string: "http://aspetica.sooprun.com")!
                
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
                
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
                activityViewController.excludedActivityTypes = [
                    .postToWeibo,
                    .print,
                    .assignToContact,
                    .saveToCameraRoll,
                    .addToReadingList,
                    .postToFlickr,
                    .postToVimeo,
                    .postToTencentWeibo
                ]
                
                self.present(activityViewController, animated: true, completion: {
                    tableView.deselectRow(at: indexPath, animated: true)})
            case 0:
                sendEmail(from: indexPath)
            case 1:
                let appID = "1197016359"
                rateApp(appId: appID) {(success) in
                    tableView.deselectRow(at: indexPath, animated: true)}

            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sectionHeaderTitles[section]
    }
    
    private func colorSetup() {
        colorAnimated()
        navBarTitle.textColor = Color.cellTextColor
        footerView.textColor = Color.symbolsColor
        for cell in tableView.visibleCells {
            cell.textLabel?.textColor = Color.cellTextColor
            cell.detailTextLabel?.textColor = Color.symbolsColor
            if UserDefaultsManager.nightMode {
                cell.accessoryView?.tintColor = Color.accessoryViewColor
            } else {
                cell.accessoryView?.tintColor = UIColor(hexString: "#ECECEC", alpha: 1)
            }
            if let dogswitch = cell.accessoryView as! UISwitch? {
                dogswitch.onTintColor = Color.deleteColor
            }
        }
        
        tableView.headerView(forSection: 0)?.textLabel?.textColor = Color.symbolsColor
        tableView.headerView(forSection: 1)?.textLabel?.textColor = Color.symbolsColor

        for view in bottomBorders {
            view.layer.backgroundColor = Color.settingsShadows.cgColor
            for viewx in topBorders {
                viewx.layer.backgroundColor = Color.settingsShadows.cgColor
            }
        }
    }
    
    func colorAnimated() {
        navBar.backgroundColor = Color.settingsMainTint
        closeButton.tintColor = Color.iconsColor
        tableView.backgroundColor = Color.settingsMainTint
        footerView.superview?.backgroundColor = Color.settingsMainTint
        tableShadow.backgroundColor = Color.settingsShadows
        self.view.backgroundColor = .clear
        self.presentingViewController?.view.backgroundColor = .black
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    
    private func cellSetup(cell: CustomCell) {
        cell.textLabel?.textColor = Color.cellTextColor
        cell.detailTextLabel?.textColor = Color.symbolsColor
        cell.backgroundColor = .clear
        tableView.separatorStyle = .none
        let borderHeight: CGFloat = 0.5
        let bottomY = cell.bounds.maxY - borderHeight
        let topY = cell.bounds.minY
        let topBorder = UIView(frame: CGRect(x: 16, y: topY, width: cell.bounds.width - 32, height: borderHeight))
        let bottomBorder = UIView(frame: CGRect(x: 16, y: bottomY, width: cell.bounds.width - 32, height: borderHeight))
        let selView = UIView()
        selView.backgroundColor = Color.onTapColor
        if let label = cell.textLabel!.text {
            switch label {
            case "Round Values":
                let roundedValuesSwitch = UISwitch()
                if UserDefaultsManager.roundedValues {
                    roundedValuesSwitch.isOn = true
                } else {
                    roundedValuesSwitch.isOn = false
                }
                roundedValuesSwitch.onTintColor = Color.deleteColor
                roundedValuesSwitch.tag = 0
                cell.detailTextLabel?.text = ""
                cell.accessoryView = roundedValuesSwitch
                cell.contentView.isUserInteractionEnabled = false
                if UserDefaultsManager.nightMode {
                    cell.accessoryView?.tintColor = Color.accessoryViewColor
                }
                roundedValuesSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            case "Dark Theme":
                let nightModeSwitch = UISwitch()
                if UserDefaultsManager.nightMode {
                    nightModeSwitch.isOn = true
                } else {
                    nightModeSwitch.isOn = false
                }
                nightModeSwitch.onTintColor = Color.deleteColor
                
                nightModeSwitch.tag = 1
                cell.detailTextLabel?.text = ""
                cell.accessoryView = nightModeSwitch
                if UserDefaultsManager.nightMode {
                    cell.accessoryView?.tintColor = Color.accessoryViewColor
                }
                nightModeSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
                if counter < 5 {
                    cell.addSubview(bottomBorder)
                }
                cell.selectionStyle = .none
            case "Send Feedback":
                cell.detailTextLabel?.text = ""
                cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(16)
                cell.accessoryView?.tintColor = Color.accessoryViewColor
                if counter < 5 {
                    cell.addSubview(topBorder)
                }
            case "Rate Aspetica":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = Color.accessoryViewColor
            case "Share Aspetica":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = Color.accessoryViewColor
                if counter < 5 {
                    cell.addSubview(bottomBorder)
                }
            default: break;
            }
            bottomBorders.append(bottomBorder)
            topBorders.append(topBorder)
            if counter < 5 {
                cell.addSubview(topBorder)
            }
            colorSetup()
            counter = counter + 1
        }
    }
    
    func sendEmail(from indexPath: IndexPath) {
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
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
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
