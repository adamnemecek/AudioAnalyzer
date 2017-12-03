//
//  MeterView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

@IBDesignable
class MeterView: UIView {

    func setDynamics(newValues: Dynamics) {
        bar.setDynamics(newValues)
    }

    var bar = MeterBarView()
    var ticks = MeterTicksView()

	@IBInspectable var peakValue: CGFloat = 0.9
    @IBInspectable var rmsValue: CGFloat = 0.5
    @IBInspectable var vuValue: CGFloat = 0.2

    var limits: (min: Double, max: Double) = (-60.0, 0.0)
    var tickValues: [Int] = (-6...1).map{ $0 * 10 }

    var dangerLevel = -3.0
    var cautionLevel = -6.0
    var safeLevel = -12.0

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        addSubview(bar)
        addSubview(ticks)
    }

//    override func draw(_ rect: CGRect) {
//
//    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bar.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width * 0.7, height: bounds.height)

        ticks.frame = CGRect(x: bounds.origin.x + bounds.width * 0.75, y: bounds.origin.y, width: bounds.width * 0.25, height: bounds.height)
    }
}

func normalize(value: Double, withRange range: (min: Double, max: Double) ) -> Double {
	return (value - range.min) / (range.max - range.min)
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }

    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }

    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }

    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth)/2, dy: (height - newHeight)/2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

