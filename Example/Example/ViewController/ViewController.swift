//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2024/1/1.
//

import UIKit
import WWPrint
import WWPulseLayer

// MARK: - ViewController
final class ViewController: UIViewController {

    enum SliderType: Int {
        case Count = 101
        case MaxRadius = 102
        case Duration = 103
        case Interval = 104
        case MaxAlpha = 105
    }
    
    enum SegmentType: Int {
        case Orientation = 201
        case Color = 202
    }
    
    @IBOutlet weak var layerView: UIView!
    
    var pulseLayer: WWPulseLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pulseLayer = WWPulseLayer()
        
        pulseLayer.frame = CGRect(origin: layerView.center, size: .zero)
        pulseLayer.start()
        
        layerView.layer.addSublayer(pulseLayer)
    }
    
    @IBAction func valueSliderAction(_ sender: UISlider) {
        
        guard let type = SliderType(rawValue: sender.tag) else { return }
        
        switch type {
        case .Count: pulseLayer.pulseCount = Int(sender.value)
        case .MaxRadius: pulseLayer.maxRadius = CGFloat(sender.value)
        case .Duration: pulseLayer.animationDuration = Double(sender.value)
        case .Interval: pulseLayer.animationInterval = Double(sender.value)
        case .MaxAlpha: pulseLayer.maxAlpha = CGFloat(sender.value)
        }
    }
    
    @IBAction func valueSegmentedAction(_ sender: UISegmentedControl) {
        
        guard let type = SegmentType(rawValue: sender.tag) else { return }
        
        switch type {
        case .Orientation: 
            pulseLayer.pulseOrientation = (sender.selectedSegmentIndex == 0) ? .out : .in
        case .Color:
            pulseLayer.inColor = (sender.selectedSegmentIndex == 0) ? .blue : .red
            pulseLayer.outColor = (sender.selectedSegmentIndex == 0) ? .blue : .yellow
        }
    }
}
