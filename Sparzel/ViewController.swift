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

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
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
    
    @IBOutlet weak var divSymbol: UIImageView!
    @IBOutlet weak var multiSymbol: UIImageView!

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
    var precisedValue1: String = ""
    var precisedValue2: String = ""
    var secondTapDone = false
    var helpIsOn = false
    var pixelsField = 3
    var isTyping = false
    var pointEntered: [Bool] = []
    var decimalPart = ""
    var animationIsOn = [false, false, false, false]
    let topHelpWidth: CGFloat = 79
    let helpHeight: CGFloat = 28
    let bottomHelpWidth: CGFloat = 50
    var reevaluate = false
    var helpOffset: CGFloat = 0
    var initialLoad: Bool = true
    
    
    //temporary features
    @IBAction func tempKeyboardSwitch() {
        if !helpIsOn {
            helpButton.setImage(UIImage(named: "icon-info-ontap"), for: .normal)
            UIView.animate(withDuration: 0.25, animations: {
                self.helpButton.tintColor = ColorConstants.deleteColor
            })
            helpIsOn = true
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.helpButton.setImage(UIImage(named: "help-icon"), for: .normal)
                self.helpButton.tintColor = ColorConstants.symbolsColor
            })
            helpIsOn = false
        }
        for view in helpViews {
            if view.alpha == 0 {
                UIView.animate(withDuration: 0.25, animations: {
                    view.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    view.alpha = 0
                })
            }
        }
    }
    
    func calculateRatioButton(){
        if calculateRatio{
            UIView.transition(with: divSymbol, duration: 0.25, options: .transitionCrossDissolve, animations: {
                if nightMode{
                self.divSymbol.image = UIImage(named: "icon-ratio-dark")
            } else {
                self.divSymbol.image = UIImage(named: "icon-ratio")
                }}, completion: nil)
            calculateRatio = false
            UIView.transition(with: textfields[0], duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.textfields[0].textColor = ColorConstants.mainTextColor
            }, completion: nil)
            UIView.transition(with: textfields[1], duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.textfields[1].textColor = ColorConstants.mainTextColor
            }, completion: nil)
            textfields[0].isUserInteractionEnabled = true
            textfields[1].isUserInteractionEnabled = true
        } else {
            UIView.transition(with: divSymbol, duration: 0.25, options: .transitionCrossDissolve, animations: {
                if nightMode{
                    self.divSymbol.image = UIImage(named: "icon-ratio-dark-ontap")
                } else {
                    self.divSymbol.image = UIImage(named: "icon-ratio-ontap")
                }}, completion: nil)
            calculateRatio = true
            UIView.transition(with: textfields[0], duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.textfields[0].textColor = ColorConstants.mainTextBlockedColor
            }, completion: nil)
            UIView.transition(with: textfields[1], duration: 0.25, options: .transitionCrossDissolve, animations: {
                self.textfields[1].textColor = ColorConstants.mainTextBlockedColor
            }, completion: nil)
            textfields[0].isUserInteractionEnabled = false
            textfields[1].isUserInteractionEnabled = false
            if activeTextField?.tag == 1 || activeTextField?.tag == 2{
                activeTextField?.backgroundColor = .clear
                UIView.transition(with: textfields[2], duration: 0.25, options: .transitionCrossDissolve, animations: {
                    self.textfields[2].textColor = ColorConstants.deleteColor
                    self.textfields[2].backgroundColor = ColorConstants.labelsBackground
                }, completion: nil)
                stopAnimation((activeTextField?.tag)! - 1)
                secondTapDone = false
                previousActive = textfields[2]
                activeTextField = textfields[2]
            }
        }
        let defaults = UserDefaults.standard
        defaults.setValue(calculateRatio, forKey: "calculateRatio")
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    @IBAction func iconDragOutside(_ sender: UIButton) {
        sender.layer.opacity = 1
    }
    
    @IBAction func settings(_ sender: UIButton) {
        stopAnimation((activeTextField?.tag)! - 1)
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
        
        if activeTextField?.tag == 3 || activeTextField?.tag == 4 {
            pixelsField = (activeTextField?.tag)!
            if roundedValues{
                pointButton.setTitle("", for: .normal)
                pointButton.isEnabled = false
            } else {
                pointButton.setTitle(".", for: .normal)
                pointButton.isEnabled = true
            }
        } else {
            pointButton.setTitle(".", for: .normal)
            pointButton.isEnabled = true
        }
        
        //if tapping specific field for the first time
        if activeTextField != previousActive {
            secondTapDone = false
            isTyping = false
            UIView.animate(withDuration: 0.25, animations: {self.deleteButton.tintColor = ColorConstants.deleteIconColor})
        } else {
            if secondTapDone {
                secondTapDone = false
                isTyping = false
                UIView.animate(withDuration: 0.25, animations: {self.deleteButton.tintColor = ColorConstants.deleteIconColor})
            } else {
                secondTapDone = true
                UIView.animate(withDuration: 0.25, animations: {self.deleteButton.tintColor = ColorConstants.deleteIconDarkColor})
            }
        }
        
        //first tap state
        if !secondTapDone {
            for view in textfields {
                if view != activeTextField {
                    if calculateRatio {
                        if view.tag == 1 || view.tag == 2 {
                            continue
                        }
                    }
                    UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                        view.textColor = ColorConstants.mainTextColor
                        view.backgroundColor = UIColor.clear
                        self.carriages[view.tag - 1].backgroundColor = .clear
                    }, completion: {(finished) in })
                } else {
                    UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                        view.textColor = ColorConstants.deleteColor
                        view.backgroundColor = ColorConstants.labelsBackground
                        self.carriages[view.tag - 1].backgroundColor = .clear
                    }, completion: {(finished) in })
                }
                stopAnimation(view.tag - 1)
            }
        } else { //second tap state
            
            for view in textfields {
                if view == activeTextField {
                    UIView.transition(with: view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                        view.backgroundColor = UIColor.clear
                        self.animationIsOn[view.tag - 1] = true
                        self.fadeIn(index: view.tag - 1)
                    }, completion: {(finished) in })
                } else {
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
                pointEntered[tappedField.tag - 1] = true
            } else {
                decimalPart = ""
                pointEntered[tappedField.tag - 1] = false
            }
            
            //adding a digit to the display
            if !(tappedField.text! == "0" && digit == "0") && !(tappedField.text! == "0" && digit == ".") && !(pointEntered[tappedField.tag - 1] && digit == ".") && !(!secondTapDone && digit == ".") && !((tappedField.text?.characters.count)! == 5 && digit == ".") && !((tappedField.tag == 1 || tappedField.tag == 2) && !secondTapDone && digit == "0") && !(!secondTapDone && digit == "0" && tappedField.text! == "1") && !(tappedField.text?.characters.count == 6 && secondTapDone) && !(decimalPart.characters.count == 2 && secondTapDone){
                
                if !secondTapDone {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.deleteButton.tintColor = ColorConstants.deleteIconDarkColor
                        tappedField.backgroundColor = UIColor.clear
                        self.carriages[tappedField.tag - 1].backgroundColor = ColorConstants.carriageColor
                    })
                    //activeTextField?.backgroundColor = UIColor.clear
                    //deleteButton.tintColor = ColorConstants.deleteIconDarkColor
                    //acarriages[tappedField.tag - 1].backgroundColor = ColorConstants.carriageColor
                    animationIsOn[tappedField.tag - 1] = true
                    fadeIn(index: tappedField.tag - 1)
                }
                
//                if activeTextField?.tag == 3 || activeTextField?.tag == 4 {
//                    pixelsField = (activeTextField?.tag)!
//                }
                
                if (secondTapDone || isTyping) {
                    if tappedField.text == "0" && digit != "0"{
                        tappedField.text = digit
                        pointEntered[tappedField.tag - 1] = false
                    } else {
                        if (tappedField.text?.characters.count)! <= 5 && !(decimalPart.characters.count == 2 && digit == ".")  || decimalPart.characters.count < 2{
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
    }
    
    @IBAction func deleteButtonTapped() {
        deleteButton.backgroundColor = ColorConstants.defaultButtonBackground
        deleteButton.borderColor = ColorConstants.buttonBorder
        if let tappedField = activeTextField {
            if !secondTapDone {
                    tappedField.text = "1"
            } else {
                if tappedField.text != "1" {
                    if tappedField.text?.characters.last == "." {
                        pointEntered[tappedField.tag - 1] = false
                    }
                    tappedField.text?.remove(at: (tappedField.text?.index(before: (tappedField.text?.endIndex)!))!)
                    if tappedField.text == "" {
                            tappedField.text = "1"
                            tappedField.backgroundColor = ColorConstants.labelsBackground
                            tappedField.textColor = ColorConstants.deleteColor
                            carriages[tappedField.tag - 1].backgroundColor = .clear
                            stopAnimation(tappedField.tag - 1)
                            secondTapDone = false
                            isTyping = false
                            pointEntered[tappedField.tag - 1] = false
                    }
                } else {
                    tappedField.backgroundColor = ColorConstants.labelsBackground
                    tappedField.textColor = ColorConstants.deleteColor
                    carriages[tappedField.tag - 1].backgroundColor = .clear
                    stopAnimation(tappedField.tag - 1)
                    secondTapDone = false
                    isTyping = false
                    pointEntered[tappedField.tag - 1] = false
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
        
        self.view.backgroundColor = .black
        setDeleteButtonImage(path: "delete-icon-bright")
        roundedView.layer.cornerRadius = 8
        
        textfields = [xField, yField, wField, hField]
        suppViews = [xSuppView, ySuppView, wSuppView, hSuppView]
        mainButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, deleteButton, pointButton]
        carriages = [xCarriage, yCarriage, wCarriage, hCarriage]
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(calculateRatioButton))
        recognizer.delegate = self
        divSymbol.addGestureRecognizer(recognizer)
        divSymbol.isUserInteractionEnabled = true
        
        for view in carriages {
            view.layer.cornerRadius = 2
            view.backgroundColor = .clear
        }
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight == 568 {
            secondRowBottomSpace.constant = 56
            for button in mainButtons {
                button.titleLabel?.font = button.titleLabel?.font.withSize(22)
            }
            for textfield in textfields {
                textfield.font = textfield.font.withSize(32)
            }
            helpOffset = 53
        } else if screenHeight == 667 {
            helpOffset = 39
        } else if screenHeight == 736 {
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            helpOffset = 30
            secondRowBottomSpace.constant = 73
            for button in mainButtons {
                button.titleLabel?.font = button.titleLabel?.font.withSize(31)
            }
            for textfield in textfields {
                textfield.font = textfield.font.withSize(45)
                
            }
        }
        
        //setting up textfields
        shadowView.backgroundColor = ColorConstants.mainBackground
        shadowView.layer.shadowColor = ColorConstants.navShadow.cgColor
        shadowView.layer.shadowOpacity = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let screenHeight = UIScreen.main.bounds.size.height
        //print("right here")
        for view in helpViews{
            view.removeFromSuperview()
        }
        
        if roundedValues{
            pointButton.setTitle("", for: .normal)
            pointButton.isEnabled = false
        } else {
            pointButton.setTitle(".", for: .normal)
            pointButton.isEnabled = true
        }
        
        var helpText = ["Ratio width", "Ratio height", "Width", "Height"]
        
        let triangleWidth: CGFloat = 8
        for (index, view) in textfields.enumerated() {
            view.isUserInteractionEnabled = true
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            recognizer.delegate = self
            view.addGestureRecognizer(recognizer)
            if initialLoad{
                if index == 2 {
                    handleTap(recognizer: recognizer)
                }
            }
            let superWidth = suppViews[index].bounds.width
            //let x = suppViews[index].bounds.midX
            let helpWidth: CGFloat = 79
            let helpView = UIView(frame: CGRect(x: superWidth/2 - helpOffset, y: view.frame.minY - helpHeight - 10, width: helpWidth, height: helpHeight))
            helpView.layer.cornerRadius = 4
            helpView.backgroundColor = ColorConstants.helpColor
            let triangle = TriangleView(frame: CGRect(x: helpView.bounds.midX - triangleWidth/2, y: helpView.bounds.maxY - 1, width: triangleWidth , height: triangleWidth * 0.5))
            triangle.backgroundColor = .clear
            helpView.bringSubview(toFront: triangle)
            helpView.addSubview(triangle)
            if helpIsOn{
                helpView.alpha = 1
            } else {
                helpView.alpha = 0
            }
            let helpLabel = UILabel(frame: CGRect(x: helpView.bounds.minX, y: helpView.bounds.minY, width: helpView.bounds.width, height: helpView.bounds.height))
            helpLabel.textAlignment = .center
            helpLabel.text = helpText[index]
            helpLabel.textColor = ColorConstants.mainBackground
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
            if view.text == "🗿"{
                reevaluate = true
            }
        }
        
        if !calculateRatio{
            textfields[0].isUserInteractionEnabled = true
            textfields[1].isUserInteractionEnabled = true
            //activeTextField?.textColor = ColorConstants.deleteColor
        } else {
            textfields[0].isUserInteractionEnabled = false
            textfields[1].isUserInteractionEnabled = false
        }
        
        colorSetup()
        
        if initialLoad{
            (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!) = evaluator.fetchData()
        }
        generalEvaluation(with: activeTextField!)
        if reevaluate{
            (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!) = ("16", "9", "1920", "1080")
        }
        initialLoad = false
        if screenHeight == 568 {
            helpOffset = 40
        } else if screenHeight == 736{
            helpOffset = 38
        }
    }
    
    let interactor = Interactor()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SettingsViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            let tempFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            dimView = UIView(frame: tempFrame)
            dimView.backgroundColor = .black
            dimView.layer.opacity = 0
            self.view.addSubview(dimView)
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.layer.opacity = 0.8
                self.roundedView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: {_ in self.dimView.removeFromSuperview()})
        }
    }
    
    override func viewDidLayoutSubviews() {
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadowView.layer.shadowRadius = 0
    }
    
    private func generalEvaluation(with tappedField: UILabel) {
        
        if fixedPoint && !roundedValues && precisedValue1 != ""{
            tappedField.text = precisedValue1
        }
        
        if fixedPoint && !roundedValues && precisedValue1 != "" && calculateRatio{
            (textfields[2].text)! = precisedValue1
            (textfields[3].text)! = precisedValue2
        }
        
        fixedPoint = false
        
        if !calculateRatio {
            if roundedValues{
                precisedValue1 = (tappedField.text)!
                (hField.text!, wField.text!) = evaluator.roundValues(a: hField.text!, b: wField.text!)
            }
            let values = (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!)
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
            
            
        } else {
            if roundedValues{
                precisedValue1 = (textfields[2].text)!
                precisedValue2 = (textfields[3].text)!
                (hField.text!, wField.text!) = evaluator.roundValues(a: hField.text!, b: wField.text!)
            }
            let values = (textfields[0].text!, textfields[1].text!, textfields[2].text!, textfields[3].text!)
            (xField.text, yField.text) = evaluator.evaluateRatio(values: values, field: tappedField.tag)
        }

        loadData()
    }
    
    private func setDeleteButtonImage(path: String){
        if let image = UIImage(named: path) {
            deleteButton.setImage(image, for: .normal)
        }
    }
    
    private func colorSetup() {
        deleteButton.tintColor = ColorConstants.deleteIconColor
        roundedView.backgroundColor = ColorConstants.mainBackground
        
        if !calculateRatio {
            if activeTextField?.tag != 2 && activeTextField?.tag != 1 {
                textfields[0].textColor = ColorConstants.mainTextColor
                textfields[1].textColor = ColorConstants.mainTextColor
            }
            if nightMode{
                divSymbol.image = UIImage(named: "icon-ratio-dark")
            } else {
                divSymbol.image = UIImage(named: "icon-ratio")
            }
        } else {
            textfields[0].textColor = ColorConstants.mainTextBlockedColor
            textfields[0].backgroundColor = .clear
            textfields[1].textColor = ColorConstants.mainTextBlockedColor
            textfields[1].backgroundColor = .clear
            if activeTextField?.tag != 4{
                textfields[2].textColor = ColorConstants.deleteColor
                textfields[2].backgroundColor = ColorConstants.labelsBackground
                activeTextField = textfields[2]
                previousActive = textfields[2]
            }
            if nightMode{
                divSymbol.image = UIImage(named: "icon-ratio-dark-ontap")
            } else {
                divSymbol.image = UIImage(named: "icon-ratio-ontap")
            }
        }
        
        for view in textfields {
            if view != activeTextField {
                view.textColor = ColorConstants.mainTextColor
                view.backgroundColor = UIColor.clear
            } else {
                if secondTapDone {
                    view.backgroundColor = UIColor.clear
                    view.textColor = ColorConstants.deleteColor
                    //carriages[view.tag - 1].backgroundColor = ColorConstants.carriageColor
                } else {
                    view.textColor = ColorConstants.deleteColor
                    view.backgroundColor = ColorConstants.labelsBackground
                }
            }
        }
        if calculateRatio{
            textfields[0].textColor = ColorConstants.mainTextBlockedColor
            textfields[1].textColor = ColorConstants.mainTextBlockedColor
        }
        
        multiSymbol.tintColor = ColorConstants.symbolsColor
        
        settingsButton.tintColor = ColorConstants.iconsColor
        
        if !helpIsOn {
            helpButton.tintColor = ColorConstants.iconsColor
        } else {
            helpButton.tintColor = ColorConstants.deleteColor
        }
        
        
        for button in mainButtons {
            button.borderColor = ColorConstants.buttonBorder
            button.backgroundColor = ColorConstants.defaultButtonBackground
            button.setTitleColor(ColorConstants.mainTextColor, for: UIControlState.normal)
        }
        
        for view in helpViews {
            view.backgroundColor = ColorConstants.helpColor
        }
        
        for view in triangles {
            view.setNeedsDisplay()
        }
        
        for view in helpLabels {
            view.textColor = ColorConstants.mainBackground
        }
        
        shadowView.backgroundColor = ColorConstants.mainBackground
        shadowView.layer.shadowColor = ColorConstants.navShadow.cgColor
    }
    
    private func fetchSettings() {
        let defaults = UserDefaults.standard
        let nightModeValue = defaults.bool(forKey: "nightMode")
        let roundedValuesValue = defaults.bool(forKey: "roundedValues")
        let calculateRatioValue = defaults.bool(forKey: "calculateRatio")
        roundedValues = roundedValuesValue
        nightMode = nightModeValue
        calculateRatio = calculateRatioValue
    }
    
    private func loadData() {
        let defaults = UserDefaults.standard
        defaults.setValue(xField.text!, forKey: xFieldKey)
        defaults.setValue(yField.text!, forKey: yFieldKey)
        defaults.setValue(wField.text!, forKey: wFieldKey)
        defaults.setValue(hField.text!, forKey: hFieldKey)
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

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}


