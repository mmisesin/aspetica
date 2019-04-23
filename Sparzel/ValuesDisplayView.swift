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

class ValuesDisplayView: UIView, Themable {
    
    // MARK: IBs
    
    private let xValueView = SingleValueView()
    private let yValueView = SingleValueView()
    private let widthValueView = SingleValueView()
    private let heightValueView = SingleValueView()
    
    private let divSymbol = UILabel()
    private let multiSymbol = UILabel()
    
    private let shadowView = UIView()
    
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

    init() {
        super.init(frame: .zero)

        setupValueViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme() {
        xValueView.applyTheme()
        yValueView.applyTheme()
        widthValueView.applyTheme()
        heightValueView.applyTheme()
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

    @objc
    func handleLockTap() {
        divSymbol.
    }

}

// MARK: Setup Methods

private extension ValuesDisplayView {

    func setupValueViews() {
        setupHelp()
        valueViews = [xValueView, yValueView, widthValueView, heightValueView]

        for (index, valueView) in valueViews.enumerated() {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleValueTap(_:)))
            valueView.addGestureRecognizer(tapRecognizer)
            valueView.isUserInteractionEnabled = true

            valueViews[index].tag = index
        }

        widthValueView.setSelected(true)

        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = 0

        addSubview(containerStackView)

        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        setupAdditionalViews()
        let topRow = makeTopRowValuesView()
        containerStackView.addArrangedSubview(topRow)
        let bottomRow = makeBottomRowValuesView()
        containerStackView.addArrangedSubview(bottomRow)

        bottomRow.snp.makeConstraints { make in
            make.height.equalTo(topRow.snp.height)
        }
    }

    func makeTopRowValuesView() -> UIView {
        let shadowView = UIView()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0

        stackView.addArrangedSubview(xValueView)

        let divSymbolContainer = UIView()
        divSymbolContainer.addSubview(divSymbol)
        divSymbol.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        divSymbolContainer.snp.makeConstraints { make in
            make.width.equalTo(45)
        }

        let lockGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLockTap))
        divSymbolContainer.addGestureRecognizer(lockGestureRecognizer)

        stackView.addArrangedSubview(divSymbolContainer)

        stackView.addArrangedSubview(yValueView)
        yValueView.snp.makeConstraints { make in
            make.width.equalTo(xValueView.snp.width)
        }

        shadowView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return shadowView
    }

    func makeBottomRowValuesView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0

        stackView.addArrangedSubview(widthValueView)

        let multiSymbolContainer = UIView()
        multiSymbolContainer.addSubview(multiSymbol)
        multiSymbol.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        multiSymbolContainer.snp.makeConstraints { make in
            make.width.equalTo(45)
        }
        stackView.addArrangedSubview(multiSymbolContainer)
        stackView.addArrangedSubview(heightValueView)
        heightValueView.snp.makeConstraints { make in
            make.width.equalTo(widthValueView.snp.width)
        }

        return stackView
    }

    func setupAdditionalViews() {
        multiSymbol.text = "×"
        multiSymbol.font = .systemFont(ofSize: 20)
        multiSymbol.textColor = UIColor(hexString: "8B9EB1", alpha: 1)

        divSymbol.text = ":"
        divSymbol.font = .systemFont(ofSize: 20)
        divSymbol.textColor = UIColor(hexString: "8B9EB1", alpha: 1)
    }

    func setupHelp() {
        self.clipsToBounds = false
        xValueView.helpText = Text.ratioWidth
        yValueView.helpText = Text.ratioWidth
        widthValueView.helpText = Text.width
        heightValueView.helpText = Text.height
    }

}
