//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

let xFieldKey = "xField"
let yFieldKey = "yField"
let wFieldKey = "wField"
let hFieldKey = "hField"

class ViewController: UIViewController, UIGestureRecognizerDelegate, DismissalDelegate {
    
    var evaluator = RatioEvaluator()
    
    //setting up the colors
    
    //instantiating subviews
    @IBOutlet weak var xField: InsetLabel!
    @IBOutlet weak var xCarriage: UIView!
    
    @IBOutlet weak var yField: InsetLabel!
    @IBOutlet weak var yCarriage: UIView!
    
    @IBOutlet weak var wField: InsetLabel!
    @IBOutlet weak var wCarriage: UIView!
    
    @IBOutlet weak var hField: InsetLabel!
    @IBOutlet weak var hCarriage: UIView!
    
    var textfields: [InsetLabel] = []
    var carriages: [UIView] = []
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
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
    
    @IBOutlet weak var xSuppView: UIView!
    @IBOutlet weak var ySuppView: UIView!
    @IBOutlet weak var hSuppView: UIView!
    @IBOutlet weak var wSuppView: UIView!
    var suppViews: [UIView] = []
    
    var helpViews: [UIView] = []
    var helpLabels: [UILabel] = []
    
    var triangles: [UIView] = []
    
    @IBOutlet weak var keyboard: UIStackView!
    
    @IBOutlet weak var sevenStack: UIStackView!
    @IBOutlet weak var fourStack: UIStackView!
    @IBOutlet weak var oneStack: UIStackView!
    @IBOutlet weak var zeroStack: UIStackView!
    
    //instantiating constraints

    @IBOutlet weak var secondRowBottomSpace: NSLayoutConstraint!
    
    
    var reversedKeyboard = false
    
    //supporting variables
    var activeTextField: UILabel?
    var previousActive: UILabel?
    var helpIsOn = false
    var pixelsField = 3
    var secondTapDone = false
    var isTyping = false
    var pointEntered: [Bool] = []
    var decimalPart = ""
    var animationIsOn = [false, false, false, false]
    let topHelpWidth: CGFloat = 79
    let helpHeight: CGFloat = 28
    let bottomHelpWidth: CGFloat = 50
    var reevaluate = false
    var helpOffset: CGFloat = 0
    
    
    //temporary features
    @IBAction func tempKeyboardSwitch() {
        if !helpIsOn {
            helpButton.setImage(UIImage(named: "icon-info-ontap"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.helpButton.tintColor = ColorConstants.deleteColor
            })
            helpIsOn = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.helpButton.setImage(UIImage(named: "help-icon"), for: .normal)
                self.helpButton.tintColor = ColorConstants.symbolsColor
            })
            helpIsOn = false
        }
        for view in helpViews {
            if view.alpha == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                })
            }
        }
//        if !reversedKeyboard {
//            keyboard.addArrangedSubview(sevenStack)
//            keyboard.addArrangedSubview(fourStack)
//            keyboard.addArrangedSubview(oneStack)
//            reversedKeyboard = true
//        } else {
//            keyboard.addArrangedSubview(oneStack)
//            keyboard.addArrangedSubview(fourStack)
//            keyboard.addArrangedSubview(sevenStack)
//            reversedKeyboard = false
//        }
//        keyboard.addArrangedSubview(zeroStack)
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
        print("Tapped \(activeTextField?.tag)")
        
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
                    carriages[view.tag - 1].backgroundColor = .clear
                } else {
                    view.textColor = ColorConstants.deleteColor
                    view.backgroundColor = ColorConstants.labelsBackground
                    carriages[view.tag - 1].backgroundColor = .clear
                }
                stopAnimation(view.tag - 1)
            }
        } else { //second tap state
            
            for view in textfields {
                if view == activeTextField {
                    view.backgroundColor = UIColor.clear
                    //carriages[view.tag - 1].backgroundColor = ColorConstants.carriageColor
                    animationIsOn[view.tag - 1] = true
                    fadeIn(index: view.tag - 1)

                } else {
                    view.textColor = ColorConstants.mainTextColor
                    view.backgroundColor = UIColor.clear
                    carriages[view.tag - 1].backgroundColor = .clear
                    stopAnimation(view.tag - 1)
                }
            }
        }
        //dealing with digits after the point
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
    
    //button view, when finger is dragged away
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
            if !(tappedField.text! == "0" && digit == "0") && !(tappedField.text == "0" && digit == ".") && !(pointEntered[tappedField.tag - 1] && digit == ".") && !(!secondTapDone && digit == ".") && !(tappedField.text?.characters.count == 5 && digit == ".") && !((tappedField.tag == 1 || tappedField.tag == 2) && !secondTapDone && digit == "0"){
                
                if !secondTapDone {
                    activeTextField?.backgroundColor = UIColor.clear
                    deleteButton.tintColor = ColorConstants.deleteIconDarkColor
                    carriages[tappedField.tag - 1].backgroundColor = ColorConstants.carriageColor
                    animationIsOn[tappedField.tag - 1] = true
                    fadeIn(index: tappedField.tag - 1)
                }
                
                if activeTextField?.tag == 3 || activeTextField?.tag == 4 {
                    pixelsField = (activeTextField?.tag)!
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
                loadData()
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
                if tappedField.tag == 1 || tappedField.tag == 2 {
                    tappedField.text = "1"
                } else {
                    tappedField.text = "0"
                }
            } else {
                if tappedField.text != "0" {
                    if tappedField.text?.characters.last == "." {
                        pointEntered[tappedField.tag - 1] = false
                    }
                    tappedField.text?.remove(at: (tappedField.text?.index(before: (tappedField.text?.endIndex)!))!)
                    if tappedField.text == "" {
                        if tappedField.tag == 1 || tappedField.tag == 2 {
                            tappedField.text = "1"
                            tappedField.backgroundColor = ColorConstants.labelsBackground
                            tappedField.textColor = ColorConstants.deleteColor
                            carriages[tappedField.tag - 1].backgroundColor = .clear
                            stopAnimation(tappedField.tag - 1)
                            secondTapDone = false
                            isTyping = false
                        } else {
                            tappedField.text = "0"
                            pointEntered[tappedField.tag - 1] = false
                        }
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
        
        fetchSettings()
        
        if nightMode {
            ColorConstants.nightMode()
        }
        
        self.view.backgroundColor = .clear
        setDeleteButtonImage(path: "delete-icon-bright")
        roundedView.layer.cornerRadius = 8
        
        let helpText = ["Ratio width", "Ratio height", "Width", "Height"]
        textfields = [xField, yField, wField, hField]
        suppViews = [xSuppView, ySuppView, wSuppView, hSuppView]
        mainButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, deleteButton, pointButton]
        carriages = [xCarriage, yCarriage, wCarriage, hCarriage]
        
        for view in carriages {
            view.layer.cornerRadius = 2
            view.backgroundColor = .clear
        }
        
        colorSetup()
        
        let triangleWidth: CGFloat = 8
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight == 568 {
            secondRowBottomSpace.constant = 56
            for button in mainButtons {
                button.titleLabel?.font = button.titleLabel?.font.withSize(22)
            }
            for textfield in textfields {
                textfield.font = textfield.font.withSize(32)
            }
            helpOffset = 40
            print("SE")
        } else if screenHeight == 667 {
            helpOffset = 26
            print("7")
        } else if screenHeight == 736 {
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            helpOffset = 18
            secondRowBottomSpace.constant = 73
            for button in mainButtons {
                button.titleLabel?.font = button.titleLabel?.font.withSize(31)
            }
            for textfield in textfields {
                textfield.font = textfield.font.withSize(45)
                
            }
            print("7+")
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
            let superWidth = suppViews[index].bounds.width
            //let x = suppViews[index].bounds.midX
            print("Yo\(superWidth)")
            let helpWidth: CGFloat = 79
            let helpView = UIView(frame: CGRect(x: superWidth/2 - helpOffset, y: view.frame.minY - helpHeight - 10, width: helpWidth, height: helpHeight))
            helpView.layer.cornerRadius = 4
            helpView.backgroundColor = ColorConstants.helpColor
            let triangle = TriangleView(frame: CGRect(x: helpView.bounds.midX - triangleWidth/2, y: helpView.bounds.maxY, width: triangleWidth , height: triangleWidth * 0.5))
            triangle.backgroundColor = .clear
            helpView.addSubview(triangle)
            let helpLabel = UILabel(frame: CGRect(x: helpView.bounds.minX, y: helpView.bounds.minY, width: helpView.bounds.width, height: helpView.bounds.height))
            helpLabel.textAlignment = .center
            helpLabel.text = helpText[index]
            helpLabel.textColor = ColorConstants.mainBackground
            //helpLabel.sizeToFit()
            helpLabel.font = helpLabel.font.withSize(12)
            helpView.addSubview(helpLabel)
            helpViews.append(helpView)
            triangles.append(triangle)
            helpLabels.append(helpLabel)
            helpViews[index].alpha = 0
            suppViews[index].addSubview(helpView)
            
            pointEntered.append(false)

            view.sizeToFit()
            
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 4
        }
        shadowView.backgroundColor = ColorConstants.mainBackground
        shadowView.layer.shadowColor = ColorConstants.navShadow.cgColor
        shadowView.layer.shadowOpacity = 1
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //dimView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {self.dimView.layer.opacity = 0.0
        })
        colorSetup()
        
        //print(numpadHeight.constant)
        
        if roundedValues{
            pointButton.setTitle("", for: .normal)
            pointButton.isEnabled = false
        } else {
            pointButton.setTitle(".", for: .normal)
            pointButton.isEnabled = true
        }
        (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!) = evaluator.fetchData()
        
        for view in textfields {
            if view.text == "🗿"{
                reevaluate = true
            }
        }
        
        if reevaluate{
            (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!) = ("16", "9", "1920", "1080")
        }
        generalEvaluation(with: activeTextField!)
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
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
//        let shadow = UIView(frame: CGRect(x: shadowView.bounds.minX, y: shadowView.bounds.maxY, width: shadowView.bounds.width, height: 1))
//        shadow.backgroundColor = .yellow
//        shadowView.addSubview(shadow)
//        shadowView.clipsToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        //shadowView.layer.shadowOpacity = 0.03
        shadowView.layer.shadowRadius = 0
    }
    
    private func generalEvaluation(with tappedField: UILabel) {
        let values = (xField!.text!, yField!.text!, wField!.text!, hField!.text!)
        //if tappedField.text != "0" && xField.text != "0" && yField.text != "0"{
        if tappedField.tag == 3 {
            hField.text = evaluator.evaluate(values: values, field: tappedField.tag, pixelsField: pixelsField)
        } else if tappedField.tag == 4 {
            wField.text = evaluator.evaluate(values: values, field: tappedField.tag, pixelsField: pixelsField)
        } else {
            if pixelsField == 3 {
                hField.text = evaluator.evaluate(values: values, field: tappedField.tag, pixelsField: pixelsField)
            } else if pixelsField == 4 {
                wField.text = evaluator.evaluate(values: values, field: tappedField.tag, pixelsField: pixelsField)
            }
        }
    }
    
    private func setDeleteButtonImage(path: String){
        if let image = UIImage(named: path) {
            deleteButton.setImage(image, for: .normal)
        }
    }
    
    private func colorSetup() {
        deleteButton.tintColor = ColorConstants.deleteIconColor
        roundedView.backgroundColor = ColorConstants.mainBackground
        divSymbol.textColor = ColorConstants.symbolsColor
        multiSymbol.textColor = ColorConstants.symbolsColor
        settingsButton.tintColor = ColorConstants.symbolsColor
        
        if !helpIsOn {
            helpButton.tintColor = ColorConstants.symbolsColor
        } else {
            helpButton.tintColor = ColorConstants.deleteColor
        }
        
        
        for button in mainButtons {
            button.borderColor = ColorConstants.buttonBorder
            button.backgroundColor = ColorConstants.defaultButtonBackground
            button.setTitleColor(ColorConstants.mainTextColor, for: UIControlState.normal)
        }
//        
//        for view in suppViews {
//            view.backgroundColor = .clear
//        }
        
        for view in helpViews {
            view.backgroundColor = ColorConstants.helpColor
        }
        
        for view in triangles {
            view.setNeedsDisplay()
        }
        
        for view in helpLabels {
            view.textColor = ColorConstants.mainBackground
        }
        
        for view in textfields {
            if view != activeTextField {
                view.textColor = ColorConstants.mainTextColor
                view.backgroundColor = UIColor.clear
            } else {
                if secondTapDone {
                    view.backgroundColor = UIColor.clear
                    view.textColor = ColorConstants.deleteColor
                    carriages[view.tag - 1].backgroundColor = ColorConstants.carriageColor
                } else {
                view.textColor = ColorConstants.deleteColor
                view.backgroundColor = ColorConstants.labelsBackground
                }
            }
        }
    }
    
    private func fetchSettings() {
        let defaults = UserDefaults.standard
        let nightModeValue = defaults.bool(forKey: "nightMode")
        let roundedValuesValue = defaults.bool(forKey: "roundedValues")
        print(nightModeValue)
        print(roundedValuesValue)
        roundedValues = roundedValuesValue
        nightMode = nightModeValue
        print("Settings fetched")
    }
    
    private func loadData() {
        let defaults = UserDefaults.standard
        defaults.setValue(xField.text!, forKey: xFieldKey)
        defaults.setValue(yField.text!, forKey: yFieldKey)
        defaults.setValue(wField.text!, forKey: wFieldKey)
        defaults.setValue(hField.text!, forKey: hFieldKey)
        print(xField.text!)
        print(yField.text!)
        print(wField.text!)
        print(hField.text!)
    }
    
    func fadeIn(index: Int) {
        UIView.animate(withDuration: 0.25, delay: 0.18, options: .curveEaseInOut, animations: {
            if self.animationIsOn[index] {
                self.carriages[index].backgroundColor = ColorConstants.carriageColor
            } else {
                self.carriages[index].layer.removeAllAnimations()
            }
        }, completion: {(finished) in self.fadeOut(index: index)})
    }
    
    func fadeOut(index: Int) {
        UIView.animate(withDuration: 0.25, delay: 0.18, options: .curveEaseInOut, animations: {self.carriages[index].backgroundColor = .clear}, completion: {(finished) in
            if !self.animationIsOn[index] {
                self.carriages[index].layer.removeAllAnimations()
            } else {
                self.fadeIn(index: index)
            }})
    }
    
    func stopAnimation(_ index: Int) {
        self.carriages[index].layer.removeAllAnimations()
        carriages[index].backgroundColor = .clear
        animationIsOn[index] = false
    }
        
}

