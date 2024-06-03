//
//  WWPulseLayer.swift
//  WWPulseLayer
//
//  Created William.Weng on 2024/6/3.
//

import UIKit

// MARK: - WWPulseLayer
open class WWPulseLayer: CAReplicatorLayer {
    
    /// 擴散樣式
    public enum Orientation {
        case `in`   // 由內而外
        case out    // 由外而內
    }
    
    public var isAnimating: Bool { return parseAnimating() }                                                                    // 是否在執行動畫？
    
    public var pulseCount: Int = 5 { didSet { pulseCountAction(pulseCount, oldValue: oldValue) }}                               // 複製的數量
    
    public var minRadius: CGFloat = 0 { didSet { restartIfNeeded(minRadius < maxRadius && minRadius >= 0) }}                    // 最小半徑
    public var maxRadius: CGFloat = 50 { didSet { maxRadiusAction(maxRadius) }}                                                 // 最大半徑

    public var minAlpha: CGFloat = 0 { didSet { restartIfNeeded(minAlpha <= maxAlpha && minAlpha >= 0) }}                       // 最小透明度
    public var maxAlpha: CGFloat = 0.5 { didSet { restartIfNeeded(maxAlpha >= minAlpha && maxAlpha > 0 && maxAlpha <= 1) }}     // 最大透明度

    public var animationDuration: Double = 3.0 { didSet { restartIfNeeded(animationDuration != oldValue) }}                     // 動畫週期
    public var animationInterval: Double = 1.0 { didSet { restartIfNeeded(animationInterval != oldValue) }}                     // 動畫間隔
    
    public var inColor: UIColor = .blue { didSet { restartIfNeeded(inColor != oldValue) }}                                      // 在圓心的起始顏色
    public var outColor: UIColor = .blue { didSet { restartIfNeeded(outColor != oldValue) }}                                    // 在圓周的最終顏色
    
    public var pulseOrientation: Orientation = .out { didSet { restartIfNeeded(pulseOrientation != oldValue) }}                 // 擴散樣式 (in / out)

    private let pulseAnimationKey: String = "PulseAnimationKey"

    private var pulseLayer: CALayer!
    private var isAnimatingBeforeLeaving: Bool = false
    
    public override init() {
        super.init()
        initSetting()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetting()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 公開工具
public extension WWPulseLayer {
    
    /// [啟動動畫](https://www.cnblogs.com/silence-cnblogs/p/6951948.html)
    func start() {
        
        let animations = animationsMaker(orientation: pulseOrientation)
        let animationGroup = animationGroupMaker(animations: animations, duration: animationDuration + animationInterval, repeatCount: repeatCount)

        instanceDelay = (animationDuration + animationInterval) / Double(pulseCount)
        stop()

        pulseLayer.add(animationGroup, forKey: pulseAnimationKey)
    }
    
    /// [結束動畫](https://github.com/Silence-GitHub/CoreAnimationDemo)
    func stop() {
        pulseLayer.removeAnimation(forKey: pulseAnimationKey)
    }
}

// MARK: - @objc
private extension WWPulseLayer {
    
    /// [記錄退到背景之前，是否為執行動畫的狀態](https://www.jianshu.com/p/4553fc4189c8)
    /// - Parameter notification: Notification
    @objc func save(_ notification: Notification) {
        isAnimatingBeforeLeaving = isAnimating
    }
    
    /// [回到前景後，重新執行動畫](https://blog.csdn.net/a892780582/article/details/132197158)
    /// - Parameter notification: Notification
    @objc func resume(_ notification: Notification) {
        if isAnimatingBeforeLeaving { start() }
    }
}

// MARK: - 小工具
private extension WWPulseLayer {
    
    /// 初始化功能
    func initSetting() {
        
        instanceCount = pulseCount
        repeatCount = .greatestFiniteMagnitude
        
        initLayerSetting(backgroundColor: outColor, maxRadius: maxRadius)
        initNotificationSetting()
    }
    
    /// 初始化Layer設定
    /// - Parameters:
    ///   - backgroundColor: UIColor
    ///   - maxRadius: CGFloat
    func initLayerSetting(backgroundColor: UIColor, maxRadius: CGFloat) {
        
        pulseLayer = CALayer()
        
        pulseLayer.opacity = 0
        pulseLayer.contentsScale = UIScreen.main.scale
        pulseLayer.backgroundColor = backgroundColor.cgColor
        pulseLayer.bounds.size = CGSize(width: maxRadius * 2, height: maxRadius * 2)
        pulseLayer.cornerRadius = maxRadius
        
        addSublayer(pulseLayer)
    }
    
    /// 初始化Notification設定
    func initNotificationSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(Self.save(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Self.resume(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    /// 是否要重畫
    /// - Parameter ifNeeded: Bool
    func restartIfNeeded(_ ifNeeded: Bool) {
     
        if (!ifNeeded) { return }
        if (!isAnimating) { return }
        
        start()
    }
    
    /// 產生動畫群組
    /// - Parameters:
    ///   - animations: [CAAnimation]?
    ///   - duration: CFTimeInterval
    ///   - repeatCount: Float
    /// - Returns: CAAnimationGroup
    func animationGroupMaker(animations: [CAAnimation]?, duration: CFTimeInterval, repeatCount: Float) -> CAAnimationGroup {
        
        let group = CAAnimationGroup()

        group.duration = duration
        group.animations = animations
        group.repeatCount = repeatCount
        
        return group
    }
    
    /// 根據Orientation產生動畫 (透明度 / 背景色 / 比例縮放)
    /// - Parameter orientation: Orientation
    /// - Returns: [CABasicAnimation]
    func animationsMaker(orientation: Orientation) -> [CABasicAnimation] {
        
        let scaleAnimation = CABasicAnimation._build(keyPath: .scaleXY)
        let opacityAnimation = CABasicAnimation._build(keyPath: .opacity)
        let backgroundColorAnimation = CABasicAnimation._build(keyPath: .backgroundColor)
        
        switch orientation {
        
        case .out:
            scaleAnimation._setting(duration: animationDuration, fromValue: minRadius / maxRadius, toValue: 1.0)
            opacityAnimation._setting(duration: animationDuration, fromValue: maxAlpha, toValue: minAlpha)
            backgroundColorAnimation._setting(duration: animationDuration, fromValue: inColor.cgColor, toValue: outColor.cgColor)
            
        case .in:
            scaleAnimation._setting(duration: animationDuration, fromValue: 1.0, toValue: minRadius / maxRadius)
            opacityAnimation._setting(duration: animationDuration, fromValue: minAlpha, toValue: maxAlpha)
            backgroundColorAnimation._setting(duration: animationDuration, fromValue: outColor.cgColor, toValue: inColor.cgColor)
        }
        
        return [scaleAnimation, opacityAnimation, backgroundColorAnimation]
    }
    
    /// 判定動畫是否在執行
    /// - Returns: Bool
    func parseAnimating() -> Bool {
        return pulseLayer.animation(forKey: pulseAnimationKey) != nil
    }
    
    /// 設定複製的數量 + 是否要重畫
    /// - Parameters:
    ///   - currentValue: Int
    ///   - oldValue: Int
    func pulseCountAction(_ currentValue: Int, oldValue: Int) {
        instanceCount = currentValue
        restartIfNeeded(currentValue != oldValue)
    }
    
    /// 設定圓大小及半徑 + 是否要重畫
    /// - Parameter maxRadius: CGFloat
    func maxRadiusAction(_ maxRadius: CGFloat) {
        pulseLayer.bounds.size = CGSize(width: maxRadius * 2, height: maxRadius * 2)
        pulseLayer.cornerRadius = maxRadius
    }
}
