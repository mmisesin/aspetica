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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dismissable, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {

    private var labels = [
        ["Round Values", "Night Mode"], ["Send Feedback", "Rate Sparzel", "Share Sparzel"]
    ]
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableShadow: UIView?
    
    @IBOutlet weak var footerView: UILabel!
    
    private var sectionHeaderTitles = ["General", "Application"]
    
    private var bottomBorders: [UIView] = []
    private var topBorders: [UIView] = []
    
    @IBAction func dismiss() {
        dismissalDelegate?.finishedShowing(viewController: self)
        UIView.animate(withDuration: 1.0, animations:{
            (self.dismissalDelegate as! ViewController).dimView.layer.opacity = 0.3
        })
//        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func panDismiss(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        navBar.layer.cornerRadius = 8
        tableShadow = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        tableShadow?.layer.opacity = 0.5
        tableView.addSubview(tableShadow!)
//        tableView.clipsToBounds = false
//        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
//        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
//        tableView.layer.shadowOffset = CGSize(width: 0, height: -0.5)
//        tableView.layer.shadowOpacity = 0.5
//        tableView.layer.shadowRadius = 0.1
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48
        
        footerView.sizeToFit()
        if let version = Bundle.main.releaseVersionNumber {
            if let build = Bundle.main.buildVersionNumber {
                footerView.text = "Version \(version) (\(build))\nby Artem Misesin and Alex Suprun"
            }
        }
        
        colorSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
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
        case 1:
            if nightMode{
                nightMode = false
                ColorConstants.defaultMode()
            } else {
                nightMode = true
                ColorConstants.nightMode()
            }
            UIView.animate(withDuration: 0.4, animations: {self.colorSetup()
            })
            
            
        case 0:
            if roundedValues {
                roundedValues = false
                sender.layer.borderWidth = 1
                sender.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1).cgColor
                sender.layer.cornerRadius = 16
            } else {
                roundedValues = true
            }
            print("Rounded values changed")
        default: break
        }
        loadSettings()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        tableView.separatorColor = ColorConstants.navShadow
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            let vc = segue.destination as! ViewController
            switch identifier {
                case "toMain":
                        UIView.animate(withDuration: 0.5, animations: {vc.dimView.layer.opacity = 0.0
                        })
            default: break
            }
        }
    }
    
    private func colorSetup() {
        navBarTitle.textColor = ColorConstants.cellTextColor
        navBar.backgroundColor = ColorConstants.settingsMainTint
        tableView.backgroundColor = ColorConstants.settingsMainTint
//        tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
        footerView.textColor = ColorConstants.symbolsColor
        footerView.superview?.backgroundColor = ColorConstants.settingsMainTint
        tableShadow?.backgroundColor = ColorConstants.navShadow
        self.view.backgroundColor = .clear
        self.presentingViewController?.view.backgroundColor = .black
        for cell in tableView.visibleCells {
            //cell.backgroundColor = ColorConstants.settingsMainTint
            cell.textLabel?.textColor = ColorConstants.cellTextColor
            cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
            cell.accessoryView?.tintColor = .clear//ColorConstants.accessoryViewColor
            if let dogswitch = cell.accessoryView as! UISwitch? {
                dogswitch.onTintColor = ColorConstants.deleteColor
            }
        }
        
        tableView.headerView(forSection: 0)?.textLabel?.textColor = ColorConstants.symbolsColor
        tableView.headerView(forSection: 1)?.textLabel?.textColor = ColorConstants.symbolsColor
        //for header in tableView.section
        for view in bottomBorders {
            view.layer.backgroundColor = ColorConstants.navShadow.cgColor
            for viewx in topBorders {
                viewx.layer.backgroundColor = ColorConstants.navShadow.cgColor
            }
        }
    }
    
    private func cellSetup(cell: UITableViewCell) {
        cell.textLabel?.textColor = ColorConstants.cellTextColor
        cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
        cell.backgroundColor = .clear //ColorConstants.settingsMainTint
        cell.layer.borderColor = ColorConstants.navShadow.cgColor
        cell.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        recognizer.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let borderHeight: CGFloat = 1
        let bottomY = cell.bounds.maxY - borderHeight
        let topY = cell.bounds.minY
        let topBorder = UIView(frame: CGRect(x: 16, y: topY, width: cell.bounds.width - 16, height: borderHeight))
        let bottomBorder = UIView(frame: CGRect(x: 16, y: bottomY, width: cell.bounds.width - 16, height: borderHeight))
        bottomBorder.backgroundColor = ColorConstants.navShadow
        topBorder.backgroundColor = ColorConstants.navShadow
        if let label = cell.textLabel!.text {
            switch label {
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
                cell.accessoryView?.tintColor = .clear
                if nightMode {
                    cell.accessoryView?.tintColor = .clear//ColorConstants.accessoryViewColor
                }
                roundedValuesSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
            case "Night Mode":
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
                cell.accessoryView?.tintColor = .clear
                nightModeSwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
                bottomBorders.append(bottomBorder)
                cell.addSubview(bottomBorder)
            case "Theme":
                cell.detailTextLabel?.text = "Default"
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
            case "Send Feedback":
                cell.detailTextLabel?.text = "sparzel@gmail.com"
                cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(16)
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                topBorders.append(topBorder)
                cell.addSubview(topBorder)
                cell.addGestureRecognizer(recognizer)
            case "Rate Sparzel":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                cell.addGestureRecognizer(recognizer)
            case "Share Sparzel":
                cell.detailTextLabel?.text = ""
                cell.accessoryView?.tintColor = ColorConstants.accessoryViewColor
                cell.addGestureRecognizer(recognizer)
                bottomBorders.append(bottomBorder)
                cell.addSubview(bottomBorder)
            default: break;
            }
            topBorders.append(topBorder)
            cell.addSubview(topBorder)
        }
    }
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        defaults.setValue(nightMode, forKey: "nightMode")
        defaults.setValue(roundedValues, forKey: "roundedValues")
        print("Settings loaded")
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let cell = recognizer.view as? UITableViewCell
        if let cellText = cell?.textLabel?.text {
            switch cellText {
            case "Share Sparzel":
                let firstActivityItem = "Kek"
                let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
                // If you want to put an image
                
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
                
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
                // Anything you want to exclude
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
                
                self.present(activityViewController, animated: true, completion: nil)
            case "Send Feedback":
                let url = NSURL(string: "mailto:artemmisesin@gmail.com")
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
            case "Rate Sparzel":
                let appID = "959379869"
                if let checkURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
                    open(url: checkURL)
                } else {
                    print("invalid url")
                }
            default: break
            }
        }
    }
    
    func open(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(url): \(success)")
            })
        } else {
            if UIApplication.shared.openURL(url) {
                print("Opened")
            }
        }
    }
}
