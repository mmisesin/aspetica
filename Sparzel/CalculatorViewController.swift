//
//  ViewController.swift
//  ratio
//
//  Created by Artem Misesin on 1/18/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit
import SnapKit

class CalculatorViewController: BaseViewController, UIGestureRecognizerDelegate, DismissalDelegate {
    
    // MARK: IBs
    
    private let settingsButton = IconButton()
    private let helpButton = IconButton()
    
    private let valuesDisplay = ValuesDisplayView()
    private let digitPad = DigitPadView()
    
    private var roundedView = UIView()
    
    // MARK: Private view properties
    
    private var dimView = UIView()
    
    // MARK: Private value properties

    private var logicStore: LogicStore = LogicStore()
    private let valueProcessor = ValueProcessor()
    private let interactor = Interactor()

    private var helpIsOn = false

    init() {
        super.init(nibName: nil, bundle: nil)

        setupRoundedView()
        setupDigitPad()
        setupValuesLabel()
        setupTopButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        if let destinationViewController = segue.destination as? SettingsViewController {
//            destinationViewController.transitioningDelegate = self
//            destinationViewController.interactor = interactor
//            destinationViewController.dismissalDelegate = self
//            let tempFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//            dimView = UIView(frame: tempFrame)
//            dimView.backgroundColor = .black
//            dimView.layer.opacity = 0
//            self.view.addSubview(dimView)
//            UIView.animate(withDuration: 0.5, animations: {
//                self.dimView.layer.opacity = 0.4
//            }, completion: {_ in self.dimView.removeFromSuperview()})
//        }
    }

    @objc func helpAction() {
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

    @objc func settingsAction() {
        let settingsViewController = SettingsViewController()
        settingsViewController.transitioningDelegate = self
        settingsViewController.interactor = interactor
        settingsViewController.dismissalDelegate = self

    }

}

// MARK: Setup Methods

private extension CalculatorViewController {

    func setupRoundedView() {
        view.addSubview(roundedView)

        roundedView.layer.cornerRadius = 10
        roundedView.layer.masksToBounds = true

        roundedView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
        }
    }

    func setupDigitPad() {
        view.addSubview(digitPad)

        digitPad.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.top.equalTo(roundedView.snp.bottom).offset(-20)
        }
    }

    func setupValuesLabel() {
        roundedView.addSubview(valuesDisplay)

        valuesDisplay.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalToSuperview().offset(-88)
            make.top.equalTo(50)
        }
    }

    func setupTopButtons() {
        roundedView.addSubview(settingsButton)

        settingsButton.setImage(UIImage(named: "settings-icon"), for: .normal)

        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.leading.top.equalToSuperview()
        }

        roundedView.addSubview(helpButton)

        helpButton.setImage(UIImage(named: "help-icon"), for: .normal)
        helpButton.addTarget(self, action: #selector(helpAction), for: .touchUpInside)

        helpButton.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.trailing.top.equalToSuperview()
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
