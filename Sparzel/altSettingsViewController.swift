//
//  altSettingsViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 2/10/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import MessageUI

class altSettingsViewController: UIViewController, Dismissable, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate  {

    private var labels = [
        ["Round Values", "Night Mode"], ["Send Feedback", "Rate Sparzel", "Share Sparzel"]
    ]
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    
    @IBOutlet weak var altTable: UIView!
    
    @IBOutlet weak var headerOne: UILabel!
    @IBOutlet weak var headerTwo: UILabel!
    
    @IBOutlet weak var cellOne: UIView!
    @IBOutlet weak var cellTwo: UIView!
    @IBOutlet weak var cellThree: UIView!
    @IBOutlet weak var cellFour: UIView!
    @IBOutlet weak var cellFive: UIView!
    @IBOutlet weak var cellSix: UIView!
    @IBOutlet weak var cellSeven: UIView!
    
    @IBOutlet weak var roundValuesCell: UILabel!
    @IBOutlet weak var nightModeCell: UILabel!
    
    @IBOutlet weak var mailCell: UILabel!
    @IBOutlet weak var rateCell: UILabel!
    @IBOutlet weak var shareCell: UILabel!
    
    @IBOutlet weak var roundSwitch: UISwitch!
    @IBOutlet weak var nightSwitch: UISwitch!
    
    @IBOutlet weak var mailLabel: UILabel!
    
    @IBOutlet weak var feedbackArrow: UIImageView!
    @IBOutlet weak var rateArrow: UIImageView!
    @IBOutlet weak var shareArrow: UIImageView!
    
    @IBOutlet weak var footerView: UILabel!
    
    private var sectionHeaderTitles = ["GENERAL", "APPLICATION"]
    
    private var headerTitles: [UILabel] = []
    private var cells: [UIView] = []
    private var cellLabels: [[UILabel]] = []
    private var switches: [UISwitch] = []
    private var disclosureIndicators: [UIImageView] = []
    
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
        
        headerTitles = [headerOne, headerTwo]
        cells = [cellOne, cellTwo, cellThree, cellFour, cellFive, cellSix, cellSeven]
        cellLabels = [[roundValuesCell, nightModeCell], [mailCell, rateCell, shareCell]]
        switches = [roundSwitch, nightSwitch]
        disclosureIndicators = [feedbackArrow, rateArrow, shareArrow]

        if roundedValues {
            roundSwitch.isOn = true
        } else {
            roundSwitch.isOn = false
        }
        if nightMode {
            nightSwitch.isOn = true
        } else {
            nightSwitch.isOn = false
        }
        
        footerView.sizeToFit()
        if let version = Bundle.main.releaseVersionNumber {
            if let build = Bundle.main.buildVersionNumber {
                footerView.text = "Version \(version) (\(build))\nby Artem Misesin and Alex Suprun"
            }
        }
        
        colorSetup()
        
    }
    
    @IBAction func switchChanged(sender: UISwitch!) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let cell = recognizer.view
            switch cell!.tag {
            case 2:
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
            case 3:
                let url = NSURL(string: "mailto:artemmisesin@gmail.com")
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
            case 4:
                let appID = "959379869"
                if let checkURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
                    open(url: checkURL)
                } else {
                    print("invalid url")
                }
            default: break
            }
    }
    
    private func colorSetup() {
        navBarTitle.textColor = ColorConstants.cellTextColor
        navBar.backgroundColor = ColorConstants.settingsMainTint
        altTable.backgroundColor = ColorConstants.settingsMainTint
        altTable.layer.shadowColor = ColorConstants.navShadow.cgColor
        footerView.textColor = ColorConstants.symbolsColor
        footerView.superview?.backgroundColor = ColorConstants.settingsMainTint
        self.view.backgroundColor = .clear
        
        let navBarShadow = UIView(frame: CGRect(x: altTable.bounds.minX, y: altTable.bounds.minY, width: altTable.bounds.width, height: 1))
        navBarShadow.backgroundColor = ColorConstants.navShadow
        altTable.addSubview(navBarShadow)
        
//        altTable.clipsToBounds = false
//        altTable.layer.shadowPath = UIBezierPath(rect: altTable.bounds).cgPath
//        altTable.layer.shadowOffset = CGSize(width: 0, height: -0.5)
//        altTable.layer.shadowOpacity = 0.03
//        altTable.layer.shadowRadius = 0
        
        for cell in cells {
            let borderHeight: CGFloat = 1
            let bottomY = cell.bounds.maxY - borderHeight
            let bottomBorder = UIView(frame: CGRect(x: 16, y: bottomY, width: cell.bounds.width - 16, height: borderHeight))
            bottomBorder.backgroundColor = ColorConstants.navShadow
            cell.addSubview(bottomBorder)
        }
        
        for cell in cellLabels {
            for label in cell{
                label.textColor = ColorConstants.cellTextColor
                mailLabel.textColor = ColorConstants.symbolsColor            }
        }
        for arrow in disclosureIndicators {
            arrow.tintColor = ColorConstants.accessoryViewColor
        }

        nightSwitch.onTintColor = ColorConstants.deleteColor
        roundSwitch.onTintColor = ColorConstants.deleteColor
        
        headerOne.textColor = ColorConstants.symbolsColor
        headerTwo.textColor = ColorConstants.symbolsColor
//        for view in bottomBorders {
//            view.layer.backgroundColor = ColorConstants.navShadow.cgColor
//            for viewx in topBorders {
//                viewx.layer.backgroundColor = ColorConstants.navShadow.cgColor
//            }
//        }
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
    
    private func loadSettings() {
        let defaults = UserDefaults.standard
        defaults.setValue(nightMode, forKey: "nightMode")
        defaults.setValue(roundedValues, forKey: "roundedValues")
        print("Settings loaded")
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
