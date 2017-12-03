//
//  SpectrumView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/3/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpectrumView: UIView {

    var lNormMags = [CGFloat]()
    var rNormMags = [CGFloat]()
    var normLogBins = [CGFloat]()

    func setValues(left: [Double], right: [Double]) {
        lNormMags = left.map{CGFloat($0)}
        rNormMags = right.map{CGFloat($0)}
        setNeedsDisplay()
    }

    func setNormLogBins(_ bins: [Double]) {
        normLogBins = bins.map{ CGFloat($0) }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let limits = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
        limits.stroke()
        drawSpectralPath(rect: rect)
    }


    func drawSpectralPath(rect: CGRect) {
        let leftPath = UIBezierPath()
        let rightPath = UIBezierPath()
        for n in lNormMags.indices {
            if n == 0 {
                leftPath.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY * lNormMags[0]))
                rightPath.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY * rNormMags[0]))
            } else {
                leftPath.addLine(to: CGPoint(x: rect.minX + rect.maxX * normLogBins[n], y: rect.midY - rect.midY * lNormMags[n]))
                rightPath.addLine(to: CGPoint(x: rect.minX + rect.maxX * normLogBins[n], y: rect.midY - rect.midY * lNormMags[n])))
            }
        }
        leftPath.stroke()
    }







}
