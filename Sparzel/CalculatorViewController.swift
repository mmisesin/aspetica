//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class CalculatorViewController: BaseViewController, UIGestureRecognizerDelegate, DismissalDelegate {
    
    // MARK: IBs
    
    @IBOutlet private weak var settingsButton: IconButton!
    @IBOutlet private weak var helpButton: IconButton!
    
    @IBOutlet private weak var valuesDisplay: ValuesDisplayView!
    @IBOutlet private weak var digitPad: DigitPadView!
    
    @IBOutlet private weak var roundedView: UIView!
    
    // MARK: Private view properties
    
    private var dimView = UIView()
    
    // MARK: Private value properties

    private var logicStore: LogicStore = LogicStore()
    private let valueProcessor = ValueProcessor()
    private let interactor = Interactor()

    private var helpIsOn = false
    
    @IBAction func helpAction() {
        helpIsOn.toggle()

        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.helpButton.setImage(self.helpIsOn ? #imageLiteral(resourceName: "icon-info-ontap") : #imageLiteral(resourceName: "help-icon"), for: .normal)
                self.helpButton.tintColor = self.helpIsOn ? Color.deleteColor : Color.symbolsColor
            }
        )

        valuesDisplay.setHelpVisible(helpIsOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsManager.nightMode {
            Color.nightMode()
        }

        valuesDisplay.logicStore = self.logicStore
        valuesDisplay.delegate = self
        digitPad.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valuesDisplay.displayStack()
    }

    override func applyTheme() {
        settingsButton.tintColor = Color.symbolsColor
        helpButton.tintColor = Color.symbolsColor

        valuesDisplay.applyTheme()
        digitPad.applyTheme()
        roundedView.backgroundColor = Color.mainBackground
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SettingsViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.dismissalDelegate = self
            let tempFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            dimView = UIView(frame: tempFrame)
            dimView.backgroundColor = .black
            dimView.layer.opacity = 0
            self.view.addSubview(dimView)
            UIView.animate(withDuration: 0.5, animations: {
                self.dimView.layer.opacity = 0.4
            }, completion: {_ in self.dimView.removeFromSuperview()})
        }
    }

}

extension CalculatorViewController: DigitPadViewDelegate {
    func digitPadView(_ padView: DigitPadView, didSelect digit: Int) {
        var newValue: Double
        if logicStore.secondTapDone && !logicStore.isClearValue {
            newValue = valueProcessor.addDigit(digit, to: valuesDisplay.selectedValue)
        } else {
            newValue = Double(digit)
        }

        valuesDisplay.updateStack(with: newValue)
    }
    
    func digitPadViewPointPressed() {
        valuesDisplay.startDecimalPart()
    }

    func digitPadViewDeletePressed() {
        if logicStore.secondTapDone {
            let value = valueProcessor.removeLastDigit(from: valuesDisplay.selectedValue)
            valuesDisplay.updateStack(with: value)
        } else {
            valuesDisplay.clearActiveValue()
        }
    }

}

extension CalculatorViewController: ValuesDisplayViewDelegate {

    func valuesDisplayView(_ view: ValuesDisplayView, didSelectValue value: ActiveValue) {
        digitPad.setDeleteDoubled(logicStore.secondTapDone)
    }

}

extension CalculatorViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
