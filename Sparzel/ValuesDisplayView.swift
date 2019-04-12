//
//  ValuesDisplayView.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/26/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

protocol ValuesDisplayViewDelegate: class {
    func valuesDisplayView(_ view: ValuesDisplayView, didSelectValue value: ActiveValue)
}

enum ActiveValue: Int {
    case x
    case y
    case width
    case height

    static var `default`: ActiveValue {
        return .width
    }
}

class ValuesDisplayView: UIView {
    
    // MARK: IBs
    
    @IBOutlet weak var xValueView: SingleValueView!
    @IBOutlet weak var yValueView: SingleValueView!
    @IBOutlet weak var widthValueView: SingleValueView!
    @IBOutlet weak var heightValueView: SingleValueView!
    
    @IBOutlet weak var divSymbol: UILabel!
    @IBOutlet weak var multiSymbol: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: Public properties
    
    var currentStack: CalculationStack {
        return CalculationStack(xValue: xValueView.value,
                         yValue: yValueView.value,
                         widthValue: widthValueView.value,
                         heightValue: heightValueView.value)
    }

    var logicStore: LogicStore!

    var selectedValue: String {
        return activeValueView.stringValue
    }

    weak var delegate: ValuesDisplayViewDelegate?
    
    // MARK: Private properties

    private let evaluator = RatioEvaluator()

    private var valueViews: [SingleValueView] = []
    
    private var helpViews: [UIView] = []

    private var activeValueView: SingleValueView {
        switch logicStore.activeValue {
        case .height:
            return heightValueView
        case .width:
            return widthValueView
        case .x:
            return xValueView
        case .y:
            return yValueView
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        valueViews = [xValueView, yValueView, widthValueView, heightValueView]

        valueViews.forEach {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleValueTap(_:)))
            $0.addGestureRecognizer(tapRecognizer)
            $0.isUserInteractionEnabled = true
        }

        widthValueView.setSelected(true)

        setupHelp()
    }

    func displayStack(_ stack: CalculationStack? = nil) {
        let stack = stack ?? evaluator.fetchData()
        xValueView.value = stack.xValue
        yValueView.value = stack.yValue
        widthValueView.value = stack.widthValue
        heightValueView.value = stack.heightValue
        UserDefaultsManager.xValue = stack.xValue
        UserDefaultsManager.yValue = stack.yValue
        UserDefaultsManager.widthValue = currentStack.widthValue
        UserDefaultsManager.heightValue = currentStack.heightValue
    }

    func updateStack(with value: Double) {
        var newStack: CalculationStack = currentStack
        newStack.setValue(value, for: logicStore.activeValue.rawValue)
        if !logicStore.secondTapDone {
            logicStore.secondTapDone.toggle()
            activeValueView.setActive(true)
        } else if logicStore.isClearValue {
            activeValueView.setActive(true)
        }
        displayStack(
            evaluator.calculate(
                stack: newStack,
                field: logicStore.activeValue.rawValue,
                pixelsField: logicStore.ratioValue.rawValue
            )
        )
        logicStore.isClearValue = false
    }

    func clearActiveValue() {
        updateStack(with: 1)
        logicStore.isClearValue = true
        activeValueView.setSelected(true)
    }

    func startDecimalPart() {
        if logicStore.secondTapDone {
            activeValueView.appendPoint()
        } else {
            logicStore.secondTapDone = true
            activeValueView.setToDecimal()
        }
    }
    
    func setHelpVisible(_ visible: Bool) {
        [xValueView, yValueView, widthValueView, heightValueView].forEach {
            $0.setHelpVisible(visible)
        }
    }
    
    @objc
    func handleValueTap(_ recognizer: UITapGestureRecognizer) {
        guard let sender = recognizer.view as? SingleValueView else {
            return
        }
        
        logicStore.activeValue = ActiveValue(rawValue: sender.tag) ?? ActiveValue.default
    
        valueViews.forEach {
            logicStore.secondTapDone ? $0.setActive(logicStore.activeValue.rawValue == $0.tag)
                                     : $0.setSelected(logicStore.activeValue.rawValue == $0.tag)

        }

        delegate?.valuesDisplayView(self, didSelectValue: logicStore.activeValue)
    }

}

private extension ValuesDisplayView {

    func setupHelp() {
        self.clipsToBounds = false
        xValueView.helpText = Text.ratioWidth
        yValueView.helpText = Text.ratioWidth
        widthValueView.helpText = Text.width
        heightValueView.helpText = Text.height
    }

}
