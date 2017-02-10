//
//  Constants.swift
//  Sparzel
//
//  Created by Artem Misesin on 1/24/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

struct ColorConstants {
    static var defaultButtonBackground = UIColor.white
    static var pressedButtonColor = UIColor(hexString: "#FFE6E1", alpha: 1)
    static var pressedButtonTextColor = UIColor(hexString: "#AA3821", alpha: 1)
    static var pressedButtonBorder = UIColor(hexString: "#FFA694", alpha: 1)
    static var symbolsColor = UIColor(hexString: "#8FA1B3", alpha: 1)
    static var settingsText = UIColor(hexString: "#8FA1B3", alpha: 1)
    static var mainTextColor = UIColor(hexString: "#404850", alpha: 1)
    static var buttonBorder = UIColor(hexString: "#EEF0F4", alpha: 1)
    static var mainTint = UIColor(hexString: "#F6F7F9", alpha: 1)
    static var labelsBackground = UIColor(hexString: "#FF5533", alpha: 0.1)
    static var deleteColor = UIColor(hexString: "#FF5533", alpha: 1)
    static var cellTextColor = UIColor(hexString: "#5F6B77", alpha: 1)
    static var deleteIconColor = UIColor(hexString: "#F65C3C", alpha: 1)
    static var deleteIconDarkColor = UIColor(hexString: "#DE4B34", alpha: 1)
    static var carriageColor = UIColor(hexString: "#E04A2C", alpha: 1)
    static var settingsMainTint = UIColor.white
    static var navShadow = UIColor(hexString: "#E0E4EA", alpha: 0.7)
    static var accessoryViewColor = UIColor(hexString: "#C4CDD7", alpha: 1)
    
    static func nightMode() {
        mainTint = UIColor(hexString: "#1C1D1F", alpha: 1)
        defaultButtonBackground = UIColor(hexString: "#252629", alpha: 1)
        pressedButtonColor = UIColor(hexString: "#2E2F33", alpha: 1)
        pressedButtonTextColor = UIColor(hexString: "#6E737A", alpha: 1)
        pressedButtonBorder = UIColor(hexString: "#404047", alpha: 1)
        symbolsColor = UIColor(hexString: "#404850", alpha: 1)
        settingsText = UIColor(hexString: "#494C52", alpha: 1)
        mainTextColor = UIColor(hexString: "#E0E4EA", alpha: 1)
        buttonBorder = UIColor(hexString: "#2E3033", alpha: 1)
        labelsBackground = UIColor(hexString: "#FFE187", alpha: 0.1)
        deleteColor = UIColor(hexString: "#FFC61A", alpha: 1)
        cellTextColor = UIColor(hexString: "#6E737A", alpha: 1)
        deleteIconColor = UIColor(hexString: "#FFC61A", alpha: 1)
        deleteIconDarkColor = UIColor(hexString: "#FFE187", alpha: 1)
        carriageColor = UIColor(hexString: "#FFE187", alpha: 1)
        settingsMainTint = UIColor(hexString: "#1C1D1F", alpha: 1)
        navShadow = UIColor(hexString: "#242628", alpha: 0.7)
        accessoryViewColor = UIColor(hexString: "#343639", alpha: 1)
    }
    
    static func defaultMode() {
        defaultButtonBackground = UIColor.white
        pressedButtonColor = UIColor(hexString: "#FFE6E1", alpha: 1)
        pressedButtonTextColor = UIColor(hexString: "#AA3821", alpha: 1)
        pressedButtonBorder = UIColor(hexString: "#FFA694", alpha: 1)
        symbolsColor = UIColor(hexString: "#8FA1B3", alpha: 1)
        settingsText = UIColor(hexString: "#404850", alpha: 1)
        mainTextColor = UIColor(hexString: "#404850", alpha: 1)
        buttonBorder = UIColor(hexString: "#EEF0F4", alpha: 1)
        mainTint = UIColor(hexString: "#F6F7F9", alpha: 1)
        labelsBackground = UIColor(hexString: "#FF5533", alpha: 0.1)
        deleteColor = UIColor(hexString: "#FF5533", alpha: 1)
        cellTextColor = UIColor(hexString: "#5F6B77", alpha: 1)
        deleteIconColor = UIColor(hexString: "#F65C3C", alpha: 1)
        deleteIconDarkColor = UIColor(hexString: "#DE4B34", alpha: 1)
        carriageColor = UIColor(hexString: "#E04A2C", alpha: 1)
        settingsMainTint = UIColor.white
        navShadow = UIColor(hexString: "#E0E4EA", alpha: 0.7)
        accessoryViewColor = UIColor(hexString: "#C4CDD7", alpha: 1)
    }
}
