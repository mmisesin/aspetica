//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, DismissalDelegate {
    
    var evaluator = RatioEvaluator()
    
    //setting up the colors
    
    //instantiating subviews
    @IBOutlet weak var xField: InsetLabel!
    @IBOutlet weak var yField: InsetLabel!
    @IBOutlet weak var wField: InsetLabel!
    @IBOutlet weak var hField: InsetLabel!
    var textfields: [InsetLabel] = []
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
    
    var dimView = UIView()
    
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
    var decimalPart = ""
    
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
    
    @IBAction func iconTouchUp(_ sender: UIButton) {
        sender.layer.opacity = 1
    }
    
    @IBAction func iconTouchDown(_ sender: UIButton) {
        sender.layer.opacity = 0.4
    }
    
    //tapping the textfields
    func handleTap(recognizer: UITapGestureRecognizer) {
        activeTextField = recognizer.view as? UILabel
        
        //if tapping specific field for the first time
        if activeTextField != previousActive {
            secondTapDone = false
            isTyping = false
            deleteButton.tintColor = ColorConstants.deleteIconColor
        } else {
            if secondTapDone {
                secondTapDone = false
                isTyping = false
                deleteButton.tintColor = ColorConstants.deleteIconColor
            } else {
                secondTapDone = true
                deleteButton.tintColor = ColorConstants.deleteIconDarkColor
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
        if (activeTextField?.text!)!.contains("."){
            decimalPart = (activeTextField?.text!)!
            decimalPart.stripFromCharacter(char: ".")
        } else {
            decimalPart = ""
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
            
            if (tappedField.text?.contains("."))!{
                decimalPart = tappedField.text!
                decimalPart.stripFromCharacter(char: ".")
            } else {
                decimalPart = ""
            }
            print("kek \(decimalPart)")
            
            //adding a digit to the display
            if !(tappedField.text! == "0" && digit == "0") && !(tappedField.text == "0" && digit == ".") && !(pointEntered[tappedField.tag - 1] && digit == ".") && !(!secondTapDone && digit == ".") && !(tappedField.text?.characters.count == 5 && digit == ".") {
                
                if !secondTapDone {
                    activeTextField?.backgroundColor = UIColor.clear
                    deleteButton.tintColor = ColorConstants.deleteIconDarkColor//setDeleteButtonImage(path: "delete-icon")
                }
                
                if (secondTapDone || isTyping) {
                    if tappedField.text == "0" && digit != "0"{
                        tappedField.text = digit
                        pointEntered[tappedField.tag - 1] = false
                    } else {
                        if (tappedField.text?.characters.count)! <= 5 && !(decimalPart.characters.count == 2 && digit == ".") {
                            tappedField.text = tappedField.text! + digit
                        }
                    }
                } else {
                    tappedField.text = digit
                    isTyping = true
                }
                
                if (tappedField.text?.contains("."))!{
                    decimalPart = (activeTextField?.text!)!
                    decimalPart.stripFromCharacter(char: ".")
                } else {
                    decimalPart = ""
                }
                
                generalEvaluation(with: tappedField)
                if digit == "." {
                    pointEntered[tappedField.tag - 1] = true
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
                        pointEntered[tappedField.tag - 1] = false
                    }
                    tappedField.text?.remove(at: (tappedField.text?.index(before: (tappedField.text?.endIndex)!))!)
                    if tappedField.text == "" {
                        tappedField.text = "0"
                        pointEntered[tappedField.tag - 1] = false
                    }
                }
            }
            generalEvaluation(with: tappedField)
            if (tappedField.text?.contains("."))!{
                decimalPart = tappedField.text!
                decimalPart.stripFromCharacter(char: ".")
            } else {
                decimalPart = ""
            }

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDeleteButtonImage(path: "delete-icon-bright")
        deleteButton.tintColor = ColorConstants.deleteIconColor
        
        self.view.backgroundColor = .clear
        
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
        //dimView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {self.dimView.layer.opacity = 0.0
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier {
            case "showSettings":
                let tempFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
                dimView = UIView(frame: tempFrame)
                dimView.backgroundColor = .black
                dimView.layer.opacity = 0
                self.view.addSubview(dimView)
                UIView.animate(withDuration: 0.5, animations: {
                    self.dimView.layer.opacity = 0.4
                })
            default:break
            }
        }
        if let vc = segue.destination as? Dismissable
        {
            vc.dismissalDelegate = self
        }
    }
    
    func generalEvaluation(with tappedField: UILabel) {
        let values = (xField!.text!, yField!.text!, wField!.text!, hField!.text!)
        //if tappedField.text != "0" && xField.text != "0" && yField.text != "0"{
        if tappedField.tag != 4 {
            hField.text = evaluator.evaluate(values: values, field: tappedField.tag)
        } else {
            wField.text = evaluator.evaluate(values: values, field: tappedField.tag)
        }
    }
    
    func setDeleteButtonImage(path: String){
        if let image = UIImage(named: path) {
            deleteButton.setImage(image, for: .normal)
        }
    }
}

