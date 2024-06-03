//
//  Constant.swift
//  WWPulseLayer
//
//  Created William.Weng on 2024/6/3.
//

import UIKit

// MARK: - Constant
final class Constant: NSObject {}

// MARK: - enum
extension Constant {
        
    /// [動畫路徑 (KeyPath)](https://stackoverflow.com/questions/44230796/what-is-the-full-keypath-list-for-cabasicanimation)
    enum AnimationKeyPath: String {
        case opacity = "opacity"
        case backgroundColor = "backgroundColor"
        case scaleXY = "transform.scale.xy"
    }
}
