//
//  LissajousView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class LissajousView: UIView {

    var xVal: CGFloat = 0.0
    var yVal: CGFloat = 0.0
    func setValue (x: CGFloat, y: CGFloat){
        xVal = 0.0
        yVal = 0.0
    }

    override func draw(_ rect: CGRect) {
		let border = UIBezierPath(rect: rect)
        UIColor.black.setStroke()
        border.stroke()
        let axis = UIBezierPath()
        axis.move(to: CGPoint(x: rect.minX, y: rect.midY))
        axis.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        axis.move(to: CGPoint(x: rect.midY, y: rect.minY))
        axis.addLine(to: CGPoint(x: rect.midY, y: rect.maxY))

        let value = UIBezierPath(arcCenter: CGPoint(x: xVal, y: yVal), radius: 5.0, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)

        value.stroke()

    }

}
