//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //setting up the colors
    var pressedButtonColor: UIColor = UIColor(red: 1, green: 0.94, blue: 0.93, alpha: 1)
    var pressedButtonTextColor: UIColor = UIColor(red: 0.67, green: 0.22, blue: 0.13, alpha: 1)
    var pressedButtonBorder: UIColor = UIColor(red: 1, green: 0.81, blue: 0.78, alpha: 1)
    var mainTextColor: UIColor = UIColor(red: 0.25, green: 0.28, blue: 0.31, alpha: 1)
    var mainTint: UIColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    var labelsBackground: UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
    var deleteColor: UIColor = UIColor(hexString: "#FF5533")
    
    //instantiating subviews
    @IBOutlet weak var xField: UILabel!
    @IBOutlet weak var yField: UILabel!
    @IBOutlet weak var wField: UILabel!
    @IBOutlet weak var hField: UILabel!
    var textfields: [UILabel] = []
    @IBOutlet weak var deleteButton: CustomButton!
    
    //supporting variables
    var activeTextField: UILabel?
    var previousActive: UILabel?
    var secondTapDone = false
    var isTyping = false
    
    //tapping the textfields
    func handleTap(recognizer: UITapGestureRecognizer) {
        activeTextField = recognizer.view as? UILabel
        
        //if tapping specific field for the first time
        if activeTextField != previousActive {
            secondTapDone = false
            isTyping = false
        } else {
            if secondTapDone {
                secondTapDone = false
            } else {
                secondTapDone = true
            }
        }
        
        //first tap state
        if !secondTapDone {
            for view in textfields {
                if view != activeTextField {
                    view.textColor = mainTextColor
                    view.backgroundColor = UIColor.clear
                } else {
                    view.textColor = deleteColor
                    view.backgroundColor = labelsBackground
                }
            }
        } else {
            
        //second tap state
            for view in textfields {
                if view == activeTextField {
                    view.backgroundColor = UIColor.clear
                } else {
                    view.textColor = mainTextColor
                    view.backgroundColor = UIColor.clear
                }
            }
        }
        
        previousActive = activeTextField
    }
    
    //button view, when finger is down on the screen
    @IBAction func touchDownDigit(_ sender: CustomButton) {
        sender.backgroundColor = pressedButtonColor
        sender.setTitleColor(pressedButtonTextColor, for: .normal)
        sender.borderColor = pressedButtonBorder
    }
    
    //pressing the button on a numpad
    @IBAction func touchDigit(_ sender: CustomButton, forEvent event: UIEvent) {
        
        if let tappedField = activeTextField {
            
            //button view, when finger is released
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(mainTextColor, for: UIControlState.normal)
            sender.borderColor = mainTint
            
            //adding a digit to the display
            let digit = sender.titleLabel!.text!
            if secondTapDone || isTyping {
                tappedField.text = tappedField.text! + digit
            } else {
                tappedField.text = digit
                isTyping = true
            }
            
            var result = 0.0
            if hField.text != "" && wField.text != "" && xField.text != "" && yField.text != "" {
                switch tappedField.tag {
                case 1:
                    result = Double(hField!.text!)! / Double(yField!.text!)! * Double(tappedField.text!)!
                    wField.text = String(forTailingZero(temp: result))
                case 2:
                    result = Double(wField!.text!)! / Double(xField!.text!)! * Double(tappedField.text!)!
                    hField.text = String(forTailingZero(temp: result))
                case 3:
                    result = Double(wField!.text!)! / Double(xField!.text!)! * Double(yField!.text!)!
                    hField.text = String(forTailingZero(temp: result))
                case 4:
                    result = (Double(hField!.text!)! / Double(yField!.text!)!) * Double(xField!.text!)!
                    wField.text = String(forTailingZero(temp: result))
                default: break
                }
            }
        }
    }
    
    @IBAction func deleteButtonTapped() {
        deleteButton.backgroundColor = UIColor.white
        if let tappedField = activeTextField {
            if !secondTapDone {
                tappedField.text = ""
            } else {
                if tappedField.text != "" {
                    tappedField.text?.remove(at: (tappedField.text?.index(before: (tappedField.text?.endIndex)!))!)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfields = [xField, yField, wField, hField]

        //setting up textfields
        for view in textfields {
            view.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
        }
    }

    
    //taking care of zero
    func forTailingZero(temp: Double) -> String{
        return String(format: "%g", temp)
    }
}

