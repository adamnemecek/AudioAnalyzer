//
//  PhaseMeterView.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class PhaseMeterView: UIView {

    var phaseDynamics = PhaseDynamics.init(name: String(),
                                        peakValue: 0.0,
                                        rmsValue: 0.0,
                                        intValue: 0.0,
                                        corrValue: 0.0)
    func setValue(_ val: PhaseDynamics) {
        phaseDynamics = val
        setNeedsDisplay()
    }

    var peakValue: CGFloat { return CGFloat(phaseDynamics.peakValue) }
    var rmsValue: CGFloat  { return CGFloat(phaseDynamics.rmsValue)  }
    var intValue: CGFloat  { return CGFloat(phaseDynamics.intValue)  }
    var corrValue: CGFloat { return CGFloat(phaseDynamics.corrValue) }

    override func draw(_ rect: CGRect) {
        let meterBorder = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        UIColor.black.setStroke()
        meterBorder.stroke()

        let baseWidth: CGFloat = 5.0

        let peakIndicator = UIBezierPath(rect: CGRect(x: peakValue - baseWidth/2, y: rect.minY, width: baseWidth, height: rect.height))

        UIColor.blue.setFill()
        peakIndicator.stroke()

        let rmsIndicator = UIBezierPath(rect: CGRect(x: rmsValue - baseWidth/2, y: rect.minY, width: baseWidth, height: rect.height))

        UIColor.blue.setFill()
        rmsIndicator.stroke()

        let corrIndicator = UIBezierPath(rect: CGRect(x: corrValue - baseWidth/2, y: rect.minY, width: baseWidth, height: rect.height))

        UIColor.blue.setFill()
        corrIndicator.stroke()

    }

}
