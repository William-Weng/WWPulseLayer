//
//  Extension.swift
//  WWPulseLayer
//
//  Created William.Weng on 2024/6/3.
//

import UIKit

// MARK: - CABasicAnimation (static function)
extension CABasicAnimation {
    
    static func _build(keyPath: Constant.AnimationKeyPath) -> Self {
        return Self(keyPath: keyPath.rawValue)
    }
    
    func _setting(duration: CFTimeInterval, fromValue: Any?, toValue: Any?) {
        self.duration = duration
        self.fromValue = fromValue
        self.toValue = toValue
    }
}
