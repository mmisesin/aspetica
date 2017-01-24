//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

//var pressedButtonColor: UIColor = UIColor(hexString: "#FFE6E1", alpha: 1)
//var pressedButtonTextColor: UIColor = UIColor(hexString: "#AA3821", alpha: 1)
//var pressedButtonBorder: UIColor = UIColor(hexString: "#FFA694", alpha: 1)
//var symbolsColor: UIColor = UIColor(hexString: "#8FA1B3", alpha: 1)
//var mainTextColor: UIColor = UIColor(hexString: "#404850", alpha: 1)
//var buttonBorder: UIColor = UIColor(hexString: "EEF0F4", alpha: 1)
//var mainTint: UIColor = UIColor(hexString: "#F6F7F9", alpha: 1)
//var labelsBackground: UIColor = UIColor(hexString: "#FF5533", alpha: 0.1)
//var deleteColor: UIColor = UIColor(hexString: "#FF5533", alpha: 1)

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var evaluator = RatioEvaluator()
    
    //setting up the colors
    
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
    
    @IBOutlet weak var keyboard: UIStackView!
    
    @IBOutlet weak var sevenStack: UIStackView!
    @IBOutlet weak var fourStack: UIStackView!
    @IBOutlet weak var oneStack: UIStackView!
    @IBOutlet weak var zeroStack: UIStackView!
    
    var reversedKeyboard = false
    
    //supporting variables
    var activeTextField: UILabel?
    var previousActive: UILabel?
    var secondTapDone = false
    var isTyping = false
    var pointEntered: [Bool] = []
    
    //temporary features
    @IBAction func tempKeyboardSwitch() {
        if !reversedKeyboard {
            keyboard.addArrangedSubview(sevenStack)
            keyboard.addArrangedSubview(fourStack)
            keyboard.addArrangedSubview(oneStack)
            reversedKeyboard = true
        } else {
            keyboard.addArrangedSubview(oneStack)
            keyboard.addArrangedSubview(fourStack)
            keyboard.addArrangedSubview(sevenStack)
            reversedKeyboard = false
        }
        keyboard.addArrangedSubview(zeroStack)
        
    }
    
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
                isTyping = false
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
                    view.textColor = ColorConstants.mainTextColor
                    view.backgroundColor = UIColor.clear
                } else {
                    view.textColor = ColorConstants.deleteColor
                    view.backgroundColor = ColorConstants.labelsBackground
                }
            }
        } else {
            
        //second tap state
            for view in textfields {
                if view == activeTextField {
                    view.backgroundColor = UIColor.clear
                } else {
                    view.textColor = ColorConstants.mainTextColor
                    view.backgroundColor = UIColor.clear
                }
            }
        }
        
        previousActive = activeTextField
        print("Second tap done \(secondTapDone)")
        print("Is typing \(isTyping)")
    }
    
    //button view, when finger is down on the screen
    @IBAction func touchDownDigit(_ sender: CustomButton) {
        sender.backgroundColor = ColorConstants.pressedButtonColor
        sender.setTitleColor(ColorConstants.pressedButtonTextColor, for: .normal)
        sender.borderColor = ColorConstants.pressedButtonBorder
    }
    
    @IBAction func dragAwayOffDigit(_ sender: CustomButton) {
        sender.backgroundColor = ColorConstants.defaultButtonBackground
        sender.setTitleColor(ColorConstants.mainTextColor, for: UIControlState.normal)
        sender.borderColor = ColorConstants.buttonBorder
    }
    
    
    //pressing the button on a numpad
    @IBAction func touchDigit(_ sender: CustomButton, forEvent event: UIEvent) {
        
        let digit = sender.titleLabel!.text!
        
        //button view, when finger is released
        sender.backgroundColor = ColorConstants.defaultButtonBackground
        sender.setTitleColor(ColorConstants.mainTextColor, for: UIControlState.normal)
        sender.borderColor = ColorConstants.buttonBorder
        
        if let tappedField = activeTextField {
            
            //adding a digit to the display
            if !(tappedField.text! == "0" && digit == "0") && !(tappedField.text == "0" && digit == ".") && !(pointEntered[tappedField.tag - 1] && digit == ".") && !(!secondTapDone && digit == ".") && (tappedField.text?.characters.count)! <= 5 {
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
        print("Second tap done \(secondTapDone)")
        print("Is typing \(isTyping)")
    }
    
    @IBAction func deleteButtonTapped() {
        deleteButton.backgroundColor = ColorConstants.defaultButtonBackground
        deleteButton.borderColor = ColorConstants.buttonBorder
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
        print("Second tap done \(secondTapDone)")
        print("Is typing \(isTyping)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedView.layer.cornerRadius = 8
        
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        shadowView.layer.shadowOpacity = 0.03
        shadowView.layer.shadowRadius = 0.5
        
        divSymbol.textColor = ColorConstants.symbolsColor
        multiSymbol.textColor = ColorConstants.symbolsColor
        
        textfields = [xField, yField, wField, hField]
        mainButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, deleteButton, pointButton]

        for button in mainButtons {
            button.borderColor = ColorConstants.mainTint
            button.backgroundColor = ColorConstants.defaultButtonBackground
            button.titleLabel?.textColor = ColorConstants.mainTextColor
        }
        
        //setting up textfields
        for (index, view) in textfields.enumerated() {
            view.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
            
            if index == 2 {
                handleTap(recognizer: recognizer)
            }
            
            pointEntered.append(false)
            
//            let carriageView = UIView()
//            
//            carriageView.frame = CGRect(x: view.frame.width + 2, y: 0, width: 2, height: view.frame.height)
//            carriageView.backgroundColor = deleteColor;
//            
//            view.addSubview(carriageView)
            
            view.sizeToFit()
            
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
        let values = (xField!.text!, yField!.text!, wField!.text!, hField!.text!)
        //if tappedField.text != "0" && xField.text != "0" && yField.text != "0"{
        if tappedField.tag != 4 {
            hField.text = evaluator.evaluate(values: values, field: tappedField.tag)
        } else {
            wField.text = evaluator.evaluate(values: values, field: tappedField.tag)
        }
//            case 1:
//                wField.text = evaluator.evaluate(tappedValue: tappedField.text!, hField!.text!, yField!.text!, field: 1)
//            case 2:
//                hField.text = evaluator.evaluate(tappedValue: tappedField.text!, wField!.text!, xField!.text!, field: 2)
//            case 3:
//                hField.text = evaluator.evaluate(tappedValue: tappedField.text!, xField!.text!, yField!.text!, field: 3)
//            case 4:
//                wField.text = evaluator.evaluate(tappedValue: tappedField.text!, yField!.text!, xField!.text!, field: 4)
//            default: break
//            }
        //}
    }
    
    func setDeleteButtonImage(path: String){
        if let image = UIImage(named: path) {
            deleteButton.setImage(image, for: .normal)
        }
    }
    
    func cancelSelection() {
        secondTapDone = false
        isTyping = false
        activeTextField = nil
        previousActive = nil
        setDeleteButtonImage(path: "delete-icon")
        for view in textfields {
            if view != activeTextField {
                view.textColor = ColorConstants.mainTextColor
                view.backgroundColor = UIColor.clear
            }
        }
        print("tap")
    }
}

