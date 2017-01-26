//
//  SettingsViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/23/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dismissable {

    private var labels = [
        ["Round Values", "Night Mode", "Theme"], ["Send Feedback", "Rate Sparzel", "Share Sparzel"]
    ]
    
    weak var dismissalDelegate: DismissalDelegate?
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navBarTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var footerView: UILabel!
    
    private var sectionHeaderTitles = ["General", "Info"]
    
    @IBAction func dismiss() {
        dismissalDelegate?.finishedShowing(viewController: self)
        UIView.animate(withDuration: 1.0, animations:{
            (self.dismissalDelegate as! ViewController).dimView.layer.opacity = 0.3
        })
    }
    
    @IBAction func panDismiss(_ sender: UIScreenEdgePanGestureRecognizer) {
        dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        navBarTitle.textColor = ColorConstants.cellTextColor
        
        navBar.layer.cornerRadius = 8
        
        tableView.clipsToBounds = false
        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
        tableView.layer.shadowPath = UIBezierPath(rect: tableView.bounds).cgPath
        tableView.layer.shadowOffset = CGSize(width: 0, height: -1.0)
        let tempColor = UIColor(hexString: "#E0E4EA", alpha: 1)
        tableView.layer.shadowColor = tempColor.cgColor
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowRadius = 0.10

        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48
        
        if let version = Bundle.main.releaseVersionNumber {
            if let build = Bundle.main.buildVersionNumber {
                footerView.text = "Version \(version) (\(build))"
            }
        }

        footerView.textColor = ColorConstants.symbolsColor
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = labels[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = ColorConstants.cellTextColor
        cell.detailTextLabel?.textColor = ColorConstants.symbolsColor
        if let label = cell.textLabel!.text {
            switch label {
            case "Round Values", "Night Mode":
                let notiSwitch = UISwitch()
                notiSwitch.isOn = true
                notiSwitch.onTintColor = ColorConstants.deleteColor
                cell.detailTextLabel?.text = ""
                cell.accessoryView = notiSwitch
            case "Theme":
                cell.detailTextLabel?.text = "Default"
            case "Send Feedback":
                cell.detailTextLabel?.text = "sparzel@gmail.com"
                cell.detailTextLabel?.font = cell.detailTextLabel?.font.withSize(14)
            case "Rate Sparzel", "Share Sparzel":
                cell.detailTextLabel?.text = ""
            default: break;
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = header.textLabel?.font.withSize(12)
        header.textLabel?.textColor = ColorConstants.symbolsColor
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
}
