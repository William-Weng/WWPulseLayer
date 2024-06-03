//
//  Extension.swift
//  WWPulseLayer
//
//  Created William.Weng on 2024/6/3.
//

import UIKit

// MARK: - CABasicAnimation (static function)
extension CABasicAnimation {
    
    /// 建立CABasicAnimation
    /// - Parameter keyPath: Constant.AnimationKeyPath
    /// - Returns: Self
    static func _build(keyPath: Constant.AnimationKeyPath) -> Self {
        return Self(keyPath: keyPath.rawValue)
    }
    
    /// 設定參數
    /// - Parameters:
    ///   - duration: CFTimeInterval
    ///   - fromValue: Any?
    ///   - toValue: Any?
    func _setting(duration: CFTimeInterval, fromValue: Any?, toValue: Any?) {
        self.duration = duration
        self.fromValue = fromValue
        self.toValue = toValue
    }
}
