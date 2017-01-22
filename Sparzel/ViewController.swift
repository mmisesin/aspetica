//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var evaluator = RatioEvaluator()
    
    //setting up the colors
    var pressedButtonColor: UIColor = UIColor(hexString: "#FFE6E1", alpha: 1)
    var pressedButtonTextColor: UIColor = UIColor(hexString: "#AA3821", alpha: 1)
    var pressedButtonBorder: UIColor = UIColor(hexString: "#FFA694", alpha: 1)
    var symbolsColor: UIColor = UIColor(hexString: "#8FA1B3", alpha: 1)
    var mainTextColor: UIColor = UIColor(hexString: "#404850", alpha: 1)
    var buttonBorder: UIColor = UIColor(hexString: "EEF0F4", alpha: 1)
    var mainTint: UIColor = UIColor(hexString: "#F6F7F9", alpha: 1)
    var labelsBackground: UIColor = UIColor(hexString: "#FF5533", alpha: 0.1)
    var deleteColor: UIColor = UIColor(hexString: "#FF5533", alpha: 1)
    
    //instantiating subviews
    @IBOutlet weak var xField: UILabel!
    @IBOutlet weak var yField: UILabel!
    @IBOutlet weak var wField: UILabel!
    @IBOutlet weak var hField: UILabel!
    var textfields: [UILabel] = []
    @IBOutlet weak var deleteButton: CustomButton!
    
    @IBOutlet weak var divSymbol: UILabel!
    @IBOutlet weak var multiSymbol: UILabel!
    
    @IBOutlet weak var oneButton: CustomButton!
    @IBOutlet weak var twoButton: CustomButton!
    @IBOutlet weak var threeButton: CustomButton!
    @IBOutlet weak var fourButton: CustomButton!
    @IBOutlet weak var fiveButton: CustomButton!
    @IBOutlet weak var sixButton: CustomButton!
    @IBOutlet weak var sevenButton: CustomButton!
    @IBOutlet weak var eightButton: CustomButton!
    @IBOutlet weak var nineButton: CustomButton!
    var mainButtons: [CustomButton] = []
    
    @IBOutlet weak var pointButton: CustomButton!
    @IBOutlet weak var zeroButton: CustomButton!
    
    //supporting views
    
    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var shadowView: UIView!
    
    //supporting variables
    var activeTextField: UILabel?
    var previousActive: UILabel?
    var secondTapDone = false
    var isTyping = false
    var pointEntered: [Bool] = []
    
    //tapping the textfields
    func handleTap(recognizer: UITapGestureRecognizer) {
        activeTextField = recognizer.view as? UILabel
        
        //if tapping specific field for the first time
        if activeTextField != previousActive {
            secondTapDone = false
            isTyping = false
            setDeleteButtonImage(path: "delete-icon-bright")
        } else {
            if secondTapDone {
                secondTapDone = false
                setDeleteButtonImage(path: "delete-icon-bright")
            } else {
                secondTapDone = true
                setDeleteButtonImage(path: "delete-icon")
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
        
        let digit = sender.titleLabel!.text!
        
        //button view, when finger is released
        sender.backgroundColor = UIColor.white
        sender.setTitleColor(mainTextColor, for: UIControlState.normal)
        sender.borderColor = buttonBorder
        
        if let tappedField = activeTextField {
            
            //adding a digit to the display
            if !(tappedField.text == "0" && digit == "0") && !(tappedField.text == "0" && digit == ".") && !(pointEntered[tappedField.tag] && digit == ".") && !(!secondTapDone && digit == "."){
                
                if !secondTapDone {
                    activeTextField?.backgroundColor = UIColor.clear
                    setDeleteButtonImage(path: "delete-icon")
                }
                
                if secondTapDone || isTyping {
                    if tappedField.text == "0" && digit != "0"{
                        tappedField.text = digit
                    } else {
                        tappedField.text = tappedField.text! + digit
                    }
                } else {
                    tappedField.text = digit
                    isTyping = true
                }
                generalEvaluation(with: tappedField)
                if digit == "." {
                    pointEntered[tappedField.tag] = true
                }
                secondTapDone = true
            }
        }
    }
    
    @IBAction func deleteButtonTapped() {
        deleteButton.backgroundColor = UIColor.white
        deleteButton.borderColor = buttonBorder
        if let tappedField = activeTextField {
            if !secondTapDone {
                tappedField.text = "0"
            } else {
                if tappedField.text != "0" {
                    if tappedField.text?.characters.last == "." {
                        pointEntered[tappedField.tag] = false
                    }
                    tappedField.text?.remove(at: (tappedField.text?.index(before: (tappedField.text?.endIndex)!))!)
                    if tappedField.text == "" {
                        tappedField.text = "0"
                    }
                }
            }
            generalEvaluation(with: tappedField)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedView.layer.cornerRadius = 8
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.03
        shadowView.layer.shadowRadius = 0.5
        
        divSymbol.textColor = symbolsColor
        multiSymbol.textColor = symbolsColor
        
        textfields = [xField, yField, wField, hField]
        mainButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, deleteButton, pointButton]

        for button in mainButtons {
            button.borderColor = mainTint
            button.backgroundColor = .white
            button.titleLabel?.textColor = mainTextColor
        }
        
        //setting up textfields
        for view in textfields {
            view.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
            
            pointEntered.append(false)
            
//            let carriageView = UIView()
//            
//            carriageView.frame = CGRect(x: view.frame.width - 2, y: 0, width: 2, height: view.frame.height)
//            carriageView.backgroundColor = deleteColor;
//            
//            view.addSubview(carriageView)
            
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 4
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        //Status bar style and visibility
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Change status bar color
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.black
    }
    
    func generalEvaluation(with tappedField: UILabel) {
        if tappedField.text != "0" && xField.text != "0" && yField.text != "0"{
            switch tappedField.tag {
            case 1:
                wField.text = evaluator.evaluate(tappedValue: tappedField.text!, hField!.text!, yField!.text!, reversed: false)
            case 2:
                hField.text = evaluator.evaluate(tappedValue: tappedField.text!, wField!.text!, xField!.text!, reversed: false)
            case 3:
                hField.text = evaluator.evaluate(tappedValue: tappedField.text!, xField!.text!, yField!.text!, reversed: true)
            case 4:
                wField.text = evaluator.evaluate(tappedValue: tappedField.text!, yField!.text!, xField!.text!, reversed: true)
            default: break
            }
        }
    }
    
    func setDeleteButtonImage(path: String){
        if let image = UIImage(named: path) {
            deleteButton.setImage(image, for: .normal)
        }
    }
}

