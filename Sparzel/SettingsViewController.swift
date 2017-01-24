//
//  SettingsViewController.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/23/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var labels = [
        ["Round Values", "Night Mode", "Theme"], ["Send Feedback", "Rate Sparzel", "Share Sparzel"]
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sectionHeaderTitles = ["General", "Info"]
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 48

        // Do any additional setup after loading the view.
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
        if let label = cell.textLabel!.text {
            switch label {
            case "Round Values":
                let notiSwitch = UISwitch()
                notiSwitch.isOn = true
                notiSwitch.onTintColor = .red
                cell.detailTextLabel?.text = ""
                cell.accessoryView = notiSwitch
            case "Night Mode":
                let notiSwitch = UISwitch()
                notiSwitch.isOn = false
                cell.detailTextLabel?.text = ""
                cell.accessoryView = notiSwitch
            case "Theme":
                cell.detailTextLabel?.text = "Default"
            case "Send Feedback":
                cell.detailTextLabel?.text = "sparzel@gmail.com"
            case "Rate Sparzel":
                cell.detailTextLabel?.text = ""
            case "Share Sparzel":
                cell.detailTextLabel?.text = ""
            default: break;
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return sectionHeaderTitles[section]
    }
}
