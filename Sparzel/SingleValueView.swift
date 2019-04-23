//
//  SingleValueView.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/29/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit
import SnapKit

class SingleValueView: UIView, Themable {
    
    // MARK: IBs
    
    private let valueLabel: InsetLabel = InsetLabel()
    private let carriage: UIView = UIView()
    
    // MARK: Public properties
    
    var value: Double {
        get {
            return Double(valueLabel.text ?? "1") ?? 1
        }
        set {

            valueLabel.text = processValueToDisplay(newValue)
        }
    }

    var stringValue: String {
        return valueLabel.text ?? "1"
    }

    var helpText: String = "" {
        didSet {
            helpView.textLabel.text = helpText
        }
    }

    // MARK: Private properties

    private var decimalPartStarted:  Bool {
        return stringValue.contains(".")
    }
    private var isSelected = false
    private var shouldAnimate = false
    private var helpView: HelpView = HelpView()
    
    // MARK: Public methods

    init() {
        super.init(frame: .zero)

        setupValueLabel()
        setupCarriage()
        setupHelp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme() {
        carriage.backgroundColor = Color.carriageColor
        valueLabel.backgroundColor = isSelected ? Color.labelsBackground : .clear
        valueLabel.textColor = isSelected ? Color.deleteColor : Color.mainTextColor
    }
    
    func setSelected(_ selected: Bool) {
        isSelected = selected
        valueLabel.textColor = selected ? Color.deleteColor : Color.mainTextColor
        valueLabel.backgroundColor = selected ? Color.labelsBackground : .clear
        
        stopAnimation()
    }
    
    func setActive(_ active: Bool) {
        valueLabel.textColor = active ? Color.deleteColor : Color.mainTextColor
        valueLabel.backgroundColor = .clear
        carriage.alpha = 0

        active ? startAnimation() : stopAnimation()
    }

    func appendPoint() {
        guard
            !decimalPartStarted,
            let text = valueLabel.text,
            text.count < 5
        else { return }
        valueLabel.text = text + "."
    }

    func setToDecimal() {
        guard !decimalPartStarted else { return }
        valueLabel.text = "0."
        setActive(true)
    }

    func setHelpVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.helpView.alpha = visible ? 1 : 0
        })
    }

    // MARK: Private methods

    private func processValueToDisplay(_ value: Double?) -> String {
        guard let value = value, value < 999999 else {
            return "🗿"
        }

        if UserDefaultsManager.roundedValues {
            let temp = String(format: "%g", value.roundTo(places: 0))
            return temp.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        } else {
            return String(format: "%g", value.roundTo(places: 2))
        }
    }
    
    private func startAnimation() {
        guard !shouldAnimate else { return }
        shouldAnimate = true
        fadeIn()
    }
    
    private func stopAnimation() {
        shouldAnimate = false
        carriage.layer.removeAllAnimations()
        carriage.alpha = 0
    }

    private func fadeIn() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.18,
            options: .curveEaseInOut,
            animations: {
                self.carriage.alpha = 1
            },
            completion: { _ in
                if self.shouldAnimate {
                    self.fadeOut()
                }
            }
        )
    }

    private func fadeOut() {
        UIView.animate(
            withDuration: 0.25,
            delay: 0.18,
            options: .curveEaseInOut,
            animations: {
                self.carriage.alpha = 0
            },
            completion: { _ in
                if self.shouldAnimate {
                    self.fadeIn()
                }
            }
        )
    }

}

// MARK: Setup Methods

private extension SingleValueView {

    func setupValueLabel() {
        addSubview(valueLabel)

        valueLabel.sizeToFit()
        valueLabel.textAlignment = .center
        valueLabel.layer.cornerRadius = 4
        valueLabel.layer.masksToBounds = true
        valueLabel.font = .systemFont(ofSize: 40, weight: .medium)

        valueLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.equalTo(56)
        }
    }

    func setupCarriage() {
        addSubview(carriage)

        carriage.backgroundColor = Color.carriageColor
        carriage.alpha = 0
        carriage.layer.cornerRadius = 4
        carriage.layer.masksToBounds = true

        carriage.snp.makeConstraints { make in
            make.trailing.equalTo(valueLabel)
            make.width.equalTo(2)
            make.centerY.equalTo(valueLabel.snp.centerY)
            make.height.equalTo(valueLabel.snp.height)
        }
    }

    func setupHelp() {
        addSubview(helpView)

        helpView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        helpView.alpha = 0
    }

}
