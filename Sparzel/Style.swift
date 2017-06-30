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
    static var iconsColor = UIColor(hexString: "#5F6B77", alpha: 1)
    static var settingsText = UIColor(hexString: "#8FA1B3", alpha: 1)
    static var mainTextColor = UIColor(hexString: "#404850", alpha: 1)
    static var mainTextBlockedColor = UIColor(hexString: "#8FA1B3", alpha: 1)
    static var buttonBorder = UIColor(hexString: "#EEF0F4", alpha: 1)
    static var mainBackground = UIColor(hexString: "#F6F7F9", alpha: 1)
    static var labelsBackground = UIColor(hexString: "#FF5533", alpha: 0.1)
    static var deleteColor = UIColor(hexString: "#FF5533", alpha: 1)
    static var cellTextColor = UIColor(hexString: "#5F6B77", alpha: 1)
    static var deleteIconColor = UIColor(hexString: "#F65C3C", alpha: 1)
    static var deleteIconDarkColor = UIColor(hexString: "#DE4B34", alpha: 1)
    static var carriageColor = UIColor(hexString: "#E04A2C", alpha: 1)
    static var settingsMainTint = UIColor(hexString: "#FFFFFF", alpha: 1)
    static var navShadow = UIColor(hexString: "#E0E4EA", alpha: 0.7)
    static var accessoryViewColor = UIColor(hexString: "#C4CDD7", alpha: 1)
    static var helpColor = UIColor(hexString: "#E04A2C", alpha: 1)
    static var onTapColor = UIColor(hexString: "#F6F7F9", alpha: 1)
    static var settingsShadows = UIColor(hexString: "#E0E4EA", alpha: 1)
    static let selectionColor = UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1)
    
    static func nightMode() {
        mainBackground = UIColor(hexString: "#1C1D20", alpha: 1)
        defaultButtonBackground = UIColor(hexString: "#25272B", alpha: 1)
        pressedButtonColor = UIColor(hexString: "#2E2F33", alpha: 1)
        pressedButtonTextColor = UIColor(hexString: "#6E737A", alpha: 1)
        pressedButtonBorder = UIColor(hexString: "#404047", alpha: 1)
        symbolsColor = UIColor(hexString: "#494C52", alpha: 1)
        settingsText = UIColor(hexString: "#74767B", alpha: 1)
        mainTextColor = UIColor(hexString: "#E4E5E6", alpha: 1)
        mainTextBlockedColor = UIColor(hexString: "#494C52", alpha: 1)
        buttonBorder = UIColor(hexString: "#313337", alpha: 1)
        labelsBackground = UIColor(hexString: "#FFE187", alpha: 0.1)
        deleteColor = UIColor(hexString: "#FFC61A", alpha: 1)
        cellTextColor = UIColor(hexString: "#6E737A", alpha: 1)
        deleteIconColor = UIColor(hexString: "#FFC61A", alpha: 1)
        deleteIconDarkColor = UIColor(hexString: "#FFE187", alpha: 1)
        carriageColor = UIColor(hexString: "#FFE187", alpha: 1)
        settingsMainTint = UIColor(hexString: "#1C1D20", alpha: 1)
        navShadow = UIColor(hexString: "#25272B", alpha: 1)
        accessoryViewColor = UIColor(hexString: "#313337", alpha: 1)
        helpColor = UIColor(hexString: "#FFE187", alpha: 1)
        onTapColor = UIColor(hexString: "#25272B", alpha: 1)
        iconsColor = UIColor(hexString: "#494C52", alpha: 1)
        settingsShadows = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    }
    
    static func defaultMode() {
        defaultButtonBackground = UIColor.white
        pressedButtonColor = UIColor(hexString: "#FFE6E1", alpha: 1)
        pressedButtonTextColor = UIColor(hexString: "#AA3821", alpha: 1)
        pressedButtonBorder = UIColor(hexString: "#FFA694", alpha: 1)
        symbolsColor = UIColor(hexString: "#8FA1B3", alpha: 1)
        settingsText = UIColor(hexString: "#404850", alpha: 1)
        mainTextColor = UIColor(hexString: "#404850", alpha: 1)
        mainTextBlockedColor = UIColor(hexString: "#8FA1B3", alpha: 1)
        buttonBorder = UIColor(hexString: "#EEF0F4", alpha: 1)
        mainBackground = UIColor(hexString: "#F6F7F9", alpha: 1)
        labelsBackground = UIColor(hexString: "#FF5533", alpha: 0.1)
        deleteColor = UIColor(hexString: "#FF5533", alpha: 1)
        cellTextColor = UIColor(hexString: "#5F6B77", alpha: 1)
        deleteIconColor = UIColor(hexString: "#F65C3C", alpha: 1)
        deleteIconDarkColor = UIColor(hexString: "#DE4B34", alpha: 1)
        carriageColor = UIColor(hexString: "#E04A2C", alpha: 1)
        settingsMainTint = UIColor(hexString: "#FFFFFF", alpha: 1)
        navShadow = UIColor(hexString: "#E0E4EA", alpha: 0.7)
        accessoryViewColor = UIColor(hexString: "#C4CDD7", alpha: 1)
        helpColor = UIColor(hexString: "#E04A2C", alpha: 1)
        onTapColor = UIColor(hexString: "#F6F7F9", alpha: 1)
        settingsShadows = UIColor(hexString: "#E0E4EA", alpha: 1)
    }
}
