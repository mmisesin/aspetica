//
//  DigitPadView.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/25/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import UIKit

protocol DigitPadViewDelegate: class {
    
    func digitPadView(_ padView: DigitPadView, didSelect digit: Int)
    func digitPadViewPointPressed()
    func digitPadViewDeletePressed()

}

class DigitPadView: UIView, Themable {
    
    // MARK: IBs
    
    private let oneButton = CustomButton(symbol: "1")
    private let twoButton = CustomButton(symbol: "2")
    private let threeButton = CustomButton(symbol: "3")
    private let fourButton = CustomButton(symbol: "4")
    private let fiveButton = CustomButton(symbol: "5")
    private let sixButton = CustomButton(symbol: "6")
    private let sevenButton = CustomButton(symbol: "7")
    private let eightButton = CustomButton(symbol: "8")
    private let nineButton = CustomButton(symbol: "9")

    private let pointButton = CustomButton(symbol: ".")
    private let zeroButton = CustomButton(symbol: "0")

    private let deleteButton = CustomButton(symbol: "")

    private let safeAreaView = UIView()

    // MARK: Public properties
    
    weak var delegate: DigitPadViewDelegate?
    
    // MARK: Public methods

    init() {
        super.init(frame: .zero)

        setupAdditionalViews()
        setupDigitButtons()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDeleteDoubled(_ doubled: Bool) {
        deleteButton.tintColor = doubled ? Color.deleteIconDarkColor : Color.deleteIconColor
    }

    func applyTheme() {
        [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, zeroButton, pointButton, deleteButton].forEach {
            $0.applyTheme()
            $0.addTarget(self, action: #selector(digitTouchUpInside(_:)), for: .touchUpInside)
        }

        safeAreaView.backgroundColor = Color.defaultButtonBackground
    }

    @objc func digitTouchUpInside(_ sender: CustomButton) {
        sender.backgroundColor = Color.defaultButtonBackground
        sender.setTitleColor(Color.mainTextColor, for: .normal)
        sender.layer.borderColor = Color.buttonBorder.cgColor

        guard let text = sender.titleLabel?.text else {
            delegate?.digitPadViewDeletePressed()
            return
        }

        if let digit = Int(text) {
            delegate?.digitPadView(self, didSelect: digit)
        } else {
            delegate?.digitPadViewPointPressed()
        }
    }
    
}

// MARK: Setup Methods

private extension DigitPadView {

    func setupDigitButtons() {
        let keyboardStack = UIStackView()
        keyboardStack.axis = .vertical
        keyboardStack.alignment = .fill
        keyboardStack.distribution = .fillEqually
        keyboardStack.spacing = 0

        addSubview(keyboardStack)

        keyboardStack.snp.makeConstraints { make in
            make.trailing.leading.top.equalToSuperview()
            make.bottom.equalTo(safeAreaView.snp.top)
        }

        let firstStack = makeRowStackView()

        oneButton.snp.makeConstraints { make in
            make.height.equalTo(64)
        }

        firstStack.addArrangedSubview(oneButton)
        firstStack.addArrangedSubview(twoButton)
        firstStack.addArrangedSubview(threeButton)

        keyboardStack.addArrangedSubview(firstStack)

        let secondStack = makeRowStackView()

        secondStack.addArrangedSubview(fourButton)
        secondStack.addArrangedSubview(fiveButton)
        secondStack.addArrangedSubview(sixButton)

        keyboardStack.addArrangedSubview(secondStack)

        let thirdStack = makeRowStackView()

        thirdStack.addArrangedSubview(sevenButton)
        thirdStack.addArrangedSubview(eightButton)
        thirdStack.addArrangedSubview(nineButton)

        keyboardStack.addArrangedSubview(thirdStack)

        let fourthStack = makeRowStackView()

        if UserDefaultsManager.roundedValues {
            pointButton.setTitle("", for: .normal)
            pointButton.isEnabled = false
        } else {
            pointButton.setTitle(".", for: .normal)
            pointButton.isEnabled = true
        }
        fourthStack.addArrangedSubview(pointButton)

        fourthStack.addArrangedSubview(zeroButton)

        deleteButton.setImage(#imageLiteral(resourceName: "delete-icon-bright"), for: .normal)
        deleteButton.tintColor = Color.deleteIconColor
        fourthStack.addArrangedSubview(deleteButton)

        keyboardStack.addArrangedSubview(fourthStack)
    }

    func setupAdditionalViews() {
        addSubview(safeAreaView)

        safeAreaView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(UIDevice.current.isIPhoneX ? 78 : 0)
        }
    }

    func makeRowStackView() -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .fill
        rowStack.distribution = .fillEqually
        rowStack.spacing = 0

        return rowStack
    }

}
