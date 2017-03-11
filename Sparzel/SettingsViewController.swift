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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dismissable, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    private var labels = [
        ["Calculate Ratio", "Round Values", "Dark Theme"], ["Send Feedback", "Rate Aspetica", "Share Aspetica"]
    ]
    
    var counter = 0
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var panImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadow: UIView!
    
//    var tableShadow: UIView?
    
    @IBOutlet weak var footerView: UILabel!
    
    private var sectionHeaderTitles = ["General", "Application"]
    
    private var bottomBorders: [UIView] = []
    private var topBorders: [UIView] = []
    
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
                        interactor.completionSpeed = slideMultiplier//3
                    } else {
                        interactor.completionSpeed = slideMultiplier * 3
                    }
                    interactor.finish()
                } else {
                    interactor.completionSpeed = slideMultiplier
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        navBar.layer.cornerRadius = 8
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48
        
        footerView.sizeToFit()
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
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels[section].count
    }
    
    func switchChanged(sender: UISwitch!) {
        switch sender.tag {
        case 2:
            if calculateRatio{
                calculateRatio = false
            } else {
                calculateRatio = true
            }
        case 1:
            if nightMode{
                nightMode = false
                ColorConstants.defaultMode()
            } else {
                nightMode = true
                ColorConstants.nightMode()
            }
            tableView.reloadData()
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
        header.textLabel?.textColor = ColorConstants.symbolsColor
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
        print("willSelect \(indexPath)")
        if indexPath.section == 0{
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
        navBarTitle.textColor = ColorConstants.cellTextColor
        //        tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
        footerView.textColor = ColorConstants.symbolsColor
        for cell in tableView.visibleCells {
            //cell.backgroundColor = ColorConstants.settingsMainTint
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
        }
        
        tableView.headerView(forSection: 0)?.textLabel?.textColor = ColorConstants.symbolsColor
        tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
        //for header in tableView.section
        for view in bottomBorders {
            view.layer.backgroundColor = ColorConstants.settingsShadows.cgColor
            for viewx in topBorders {
                viewx.layer.backgroundColor = ColorConstants.settingsShadows.cgColor
            }
        }
    }
    
    func colorAnimated() {
        navBar.backgroundColor = ColorConstants.settingsMainTint
        closeButton.tintColor = ColorConstants.iconsColor
        tableView.backgroundColor = ColorConstants.settingsMainTint
        footerView.superview?.backgroundColor = ColorConstants.settingsMainTint
        tableShadow.backgroundColor = ColorConstants.settingsShadows
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
        cell.textLabel?.textColor = ColorConstants.cellTextColor
        cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
        cell.backgroundColor = .clear //ColorConstants.settingsMainTint
        //cell.isUserInteractionEnabled = true
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        recognizer.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let borderHeight: CGFloat = 0.5
        let bottomY = cell.bounds.maxY - borderHeight
        let topY = cell.bounds.minY
        let topBorder = UIView(frame: CGRect(x: 16, y: topY, width: cell.bounds.width - 32, height: borderHeight))
        let bottomBorder = UIView(frame: CGRect(x: 16, y: bottomY, width: cell.bounds.width - 32, height: borderHeight))
        let selView = UIView()
        selView.backgroundColor = ColorConstants.onTapColor
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
                cell.detailTextLabel?.text = ""
                cell.accessoryView = ratioSwitch
                if nightMode {
                    cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                }
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
                cell.detailTextLabel?.text = ""
                cell.accessoryView = roundedValuesSwitch
                cell.contentView.isUserInteractionEnabled = false
                if nightMode {
                    cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                }
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
                cell.detailTextLabel?.text = ""
                cell.accessoryView = nightModeSwitch
                if nightMode {
                    cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                }
                nightModeSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
                if counter < 6 {
                    cell.addSubview(bottomBorder)
                }
                cell.selectionStyle = .none
            case "Send Feedback":
                cell.detailTextLabel?.text = ""
                cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(16)
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                if counter < 6 {
                    cell.addSubview(topBorder)
                }
            case "Rate Aspetica":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
            case "Share Aspetica":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                if counter < 6 {
                    cell.addSubview(bottomBorder)
                }
            default: break;
            }
            bottomBorders.append(bottomBorder)
            topBorders.append(topBorder)
            if counter < 6 {
                cell.addSubview(topBorder)
            }
            colorSetup()
            counter = counter + 1
        }
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        print(nightMode)
        print(roundedValues)
        defaults.setValue(nightMode, forKey: "nightMode")
        defaults.setValue(roundedValues, forKey: "roundedValues")
        defaults.setValue(calculateRatio, forKey: "calculateRatio")
        print("Settings loaded")
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
        } else {
            // show failure alert
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
