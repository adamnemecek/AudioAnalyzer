//
//  MeterTicksView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit


class MeterTicksView: UIView {
    
    var tickValues = (1...6).map{$0 * 10}
    var limits: (min: Double, max: Double) = (-60, 0)

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))

        let tickMarkerWidth: CGFloat = 5.0
        for tick in tickValues {
            let frac = CGFloat(normalize(value: Double(tick), withRange: limits))
            let tickOrigin = CGPoint(x: rect.minX, y: frac * rect.height)
            if frac > 1 { continue }
            path.move(to: tickOrigin)
            path.addLine(to: tickOrigin.offsetBy(dx: tickMarkerWidth, dy: 0))
        }
        path.stroke()
    }
}
