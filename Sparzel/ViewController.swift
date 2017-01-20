//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var deleteColor: UIColor = UIColor(hexString: "#FF5533")
    
    var activeTextField = UITextField()
    
    var previousActive = UITextField()

    @IBOutlet weak var xField: UITextField!
    
    @IBOutlet weak var wField: UITextField!
    
    @IBOutlet weak var yField: UITextField!
    
    @IBOutlet weak var hField: UITextField!
    
    var secondTap = false
    
    var isTyping = false
    
    var textfields: [UITextField] = []
    
    @IBAction func touchDigit(_ sender: CustomButton, forEvent event: UIEvent) {
        let digit = sender.titleLabel!.text!
        if !secondTap || isTyping {
            activeTextField.text = activeTextField.text! + digit
        } else {
            activeTextField.text = digit
            isTyping = true
        }
        secondTap = false
        var result = 0.0
        if hField.text != "" && wField.text != "" && xField.text != "" && yField.text != "" {
        switch activeTextField.tag {
        case 1:
            result = Double(hField!.text!)! / Double(yField!.text!)! * Double(activeTextField.text!)!
            wField.text = String(forTailingZero(temp: result))
        case 2:
            result = Double(wField!.text!)! / Double(xField!.text!)! * Double(activeTextField.text!)!
            hField.text = String(forTailingZero(temp: result))
        case 3:
            result = (Double(hField!.text!)! / Double(yField!.text!)!)
            xField.text = String(forTailingZero(temp: Double(activeTextField.text!)! / result))
        case 4:
            result = (Double(wField!.text!)! / Double(xField!.text!)!)
            yField.text = String(forTailingZero(temp: Double(activeTextField.text!)! / result))
        default: break
            }
        }
    }
    
    @IBAction func touchTextField(_ sender: UITextField) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)

        activeTextField = sender
        if activeTextField != previousActive {
            secondTap = false
        }
        if !secondTap {
            for view in textfields {
                if view != sender {
                    view.textColor = UIColor(red: 0.25, green: 0.28, blue: 0.31, alpha: 1)
                    view.backgroundColor = UIColor.clear
                    view.tintColor = UIColor.clear
                } else {
                    view.textColor = deleteColor
                    view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                    view.tintColor = UIColor.clear
                }
            }
        } else {
            for view in textfields {
                if view == sender {
                    view.tintColor = deleteColor
                    view.backgroundColor = UIColor.clear
                } else {
                    view.textColor = UIColor(red: 0.25, green: 0.28, blue: 0.31, alpha: 1)
                    view.tintColor = UIColor.clear
                    view.backgroundColor = UIColor.clear
                }
            }
        }
        if secondTap{
            secondTap = false
            isTyping = false
        } else {
            secondTap = true
        }
        previousActive = sender
    }
    
    @IBAction func deleteButton() {
        if secondTap {
            activeTextField.text = ""
        } else {
            if activeTextField.text != "" {
                activeTextField.text?.remove(at: (activeTextField.text?.index(before: (activeTextField.text?.endIndex)!))!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textfields = [xField, yField, wField, hField]
        
        for view in textfields {
            view.tintColor = UIColor.clear
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forTailingZero(temp: Double) -> String{
        return String(format: "%g", temp)
    }
}

