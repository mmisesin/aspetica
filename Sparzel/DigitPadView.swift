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
    
    @IBOutlet private weak var oneButton: CustomButton!
    @IBOutlet private weak var twoButton: CustomButton!
    @IBOutlet private weak var threeButton: CustomButton!
    @IBOutlet private weak var fourButton: CustomButton!
    @IBOutlet private weak var fiveButton: CustomButton!
    @IBOutlet private weak var sixButton: CustomButton!
    @IBOutlet private weak var sevenButton: CustomButton!
    @IBOutlet private weak var eightButton: CustomButton!
    @IBOutlet private weak var nineButton: CustomButton!

    @IBOutlet private weak var pointButton: CustomButton!
    @IBOutlet private weak var zeroButton: CustomButton!

    @IBOutlet private weak var deleteButton: CustomButton!

    @IBOutlet private var safeAreaView: UIView!
    @IBOutlet private var safeAreaViewHeightConstraint: NSLayoutConstraint!

    @IBAction func digitTouchUpInside(_ sender: CustomButton) {
        sender.backgroundColor = Color.defaultButtonBackground
        sender.setTitleColor(Color.mainTextColor, for: .normal)
        sender.borderColor = Color.buttonBorder
        
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

    // MARK: Public properties
    
    weak var delegate: DigitPadViewDelegate?
    
    // MARK: Public methods

    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.setImage(#imageLiteral(resourceName: "delete-icon-bright"), for: .normal)
        deleteButton.tintColor = Color.deleteIconColor

        if UserDefaultsManager.roundedValues {
            pointButton.setTitle("", for: .normal)
            pointButton.isEnabled = false
        } else {
            pointButton.setTitle(".", for: .normal)
            pointButton.isEnabled = true
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        safeAreaViewHeightConstraint.constant = UIDevice.current.isIPhoneX ? 78 : 0
    }

    func setDeleteDoubled(_ doubled: Bool) {
        deleteButton.tintColor = doubled ? Color.deleteIconDarkColor : Color.deleteIconColor
    }

    func applyTheme() {
        [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, zeroButton, pointButton, deleteButton].forEach {
            $0.applyTheme()
        }

        safeAreaView.backgroundColor = Color.defaultButtonBackground
    }
    
}
