//
//  MeterTicksView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/30/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit


class MeterTicksView: UIView {

    static var tickValues = (-6...0).map{Double($0) * 10}
    static var limits: (min: Double, max: Double) = (-60, 0)
    static var range: Double { return MeterTicksView.limits.max - MeterTicksView.limits.min }
    static func fracOfLimits(from value: Double) -> Double {
        return (value - MeterTicksView.limits.min) / MeterTicksView.range
    }
    static var tickFontSize: CGFloat {
        return UIFont.smallSystemFontSize
    }
    static var tickFont: UIFont {
        return UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .footnote), size: MeterTicksView.tickFontSize)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: rect.origin)
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))

        let tickMarkerWidth: CGFloat = rect.width/10.0
        for tick in MeterTicksView.tickValues {
            let frac = CGFloat(MeterTicksView.fracOfLimits(from: tick))
            if frac > 1 { continue }
            let tickOrigin = CGPoint(x: rect.minX, y: frac * rect.height)
            path.move(to: tickOrigin)
            path.addLine(to: tickOrigin.offsetBy(dx: tickMarkerWidth, dy: 0.0))
            drawTickText(value: tick, rect: CGRect(origin: tickOrigin.offsetBy(dx: tickMarkerWidth, dy: 0.0), size: CGSize(width: rect.width - tickMarkerWidth, height: 50.0)))
        }
        UIColor.black.setStroke()
        path.stroke()
    }

    func drawTickText(value: Double, rect: CGRect) {
        let textFont = MeterTicksView.tickFont
        let attributes = [NSAttributedStringKey.font: textFont,
                          NSAttributedStringKey.strokeColor: UIColor.black]
        let text = NSAttributedString(string: String(value), attributes: attributes)
        text.draw(in: rect)
    }
}
