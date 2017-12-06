//
//  SpectrumView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/3/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpectrumView: UIView {

    var lNormMags: UnsafeMutablePointer<Double>?
    var rNormMags: UnsafeMutablePointer<Double>?
    var normLogBins = [CGFloat]()
    var fftSize: Int?

    func initializeMemoryForPlot(forSize size: Int) -> (leftPtr: UnsafeMutablePointer<Double>, rightPtr: UnsafeMutablePointer<Double>) {
        lNormMags = UnsafeMutablePointer<Double>.allocate(capacity: size)
        rNormMags = UnsafeMutablePointer<Double>.allocate(capacity: size)
        return (leftPtr: lNormMags!, rightPtr: rNormMags!)
    }

    func setNormLogBins(_ bins: [Double]) {
        normLogBins = bins.map{ CGFloat($0) }
    }

    override func draw(_ rect: CGRect) {
        let limits = UIBezierPath(roundedRect: bounds, cornerRadius: 5)
        limits.stroke()
        drawSpectralPath(rect: rect)
    }

    func drawSpectralPath(rect: CGRect) {
        let leftPath = UIBezierPath()
        let rightPath = UIBezierPath()
        for n in 0..<(fftSize ?? 0) {
            let lMag = CGFloat(lNormMags![n])
            let rMag = CGFloat(rNormMags![n])
            if n == 0 {
                leftPath.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY * lMag))
                rightPath.move(to: CGPoint(x: rect.minX, y: rect.midY - rect.midY * rMag))
            } else {
                leftPath.addLine(to: CGPoint(x: rect.minX + rect.maxX * normLogBins[n], y: rect.midY - rect.midY * lMag))
                rightPath.addLine(to: CGPoint(x: rect.minX + rect.maxX * normLogBins[n], y: rect.midY - rect.midY * rMag))
            }
        }
        UIColor.blue.setStroke()
        leftPath.stroke()
        UIColor.red.setStroke()
        rightPath.stroke()
    }
}
