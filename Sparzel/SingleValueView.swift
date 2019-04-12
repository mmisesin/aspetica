//
//  SingleValueView.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/29/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

class SingleValueView: UIView, NibLoadable {
    
    // MARK: IBs
    
    @IBOutlet private weak var valueLabel: InsetLabel!
    @IBOutlet private weak var carriage: UIView!
    
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

    var helpText: String?

    // MARK: Private properties

    private var decimalPartStarted:  Bool {
        return stringValue.contains(".")
    }
    private var shouldAnimate = false
    private var helpView: UIView?
    
    // MARK: Public methods

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupFromNib()

        carriage.backgroundColor = Color.carriageColor
        carriage.alpha = 0

        valueLabel.sizeToFit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupHelp()
    }
    
    func setSelected(_ selected: Bool) {

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
            self.helpView?.alpha = visible ? 1 : 0
        })
    }

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

    private func setupHelp() {
        let triangleWidth: CGFloat = 8
        let helpHeight: CGFloat = 28
        let helpWidth: CGFloat = 79

        let helpView = UIView(frame: CGRect(
            x: bounds.midX - helpWidth / 2,
            y: valueLabel.bounds.minY - 10,
            width: helpWidth,
            height: helpHeight
            )
        )

        helpView.layer.cornerRadius = 4
        helpView.backgroundColor = Color.helpColor
        let triangle = TriangleView(frame: CGRect(x: helpView.bounds.midX - triangleWidth/2, y: helpView.bounds.maxY - 1, width: triangleWidth , height: triangleWidth * 0.5))
        triangle.backgroundColor = .clear
        helpView.bringSubviewToFront(triangle)
        helpView.addSubview(triangle)
        let helpLabel = UILabel(frame: CGRect(x: helpView.bounds.minX, y: helpView.bounds.minY, width: helpWidth, height: helpHeight))
        helpLabel.textAlignment = .center
        helpLabel.text = helpText
        helpLabel.textColor = Color.mainBackground
        helpLabel.font = helpLabel.font.withSize(12)
        helpView.alpha = 0
        helpView.addSubview(helpLabel)
        addSubview(helpView)
        self.helpView = helpView
        sizeToFit()
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
