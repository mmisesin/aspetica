//
//  UserDefaultsManager.swift
//  Aspetica
//
//  Created by Artem Misesin on 12/28/18.
//  Copyright © 2018 Artem Misesin. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static let `default` = UserDefaultsManager()
    
    private init() {}
    
    private var nightMode: Bool {
        return UserDefaults.standard.bool(forKey: #function)
    }
    
    private var roundedValues: Bool {
        return UserDefaults.standard.bool(forKey: #function)
    }
    
    private var xValue: Double {
        return UserDefaults.standard.double(forKey: #function)
    }
    
    private var yValue: Double {
        return UserDefaults.standard.double(forKey: #function)
    }
    
    private var widthValue: Double {
        return UserDefaults.standard.double(forKey: #function)
    }
    
    private var heightValue: Double {
        return UserDefaults.standard.double(forKey: #function)
    }
    
}

extension UserDefaultsManager {
    
    static var nightMode: Bool {
        get {
            return UserDefaultsManager.default.nightMode
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    static var roundedValues: Bool {
        get {
            return UserDefaultsManager.default.roundedValues
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    static var xValue: Double {
        get {
            return UserDefaultsManager.default.xValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    static var yValue: Double {
        get {
            return UserDefaultsManager.default.yValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    static var widthValue: Double {
        get {
            return UserDefaultsManager.default.widthValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
    static var heightValue: Double {
        get {
            return UserDefaultsManager.default.heightValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: #function)
        }
    }
    
}
