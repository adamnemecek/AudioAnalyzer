//
//  Goniometer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


class Goniometer {
    var fs: Double
    var ID: String

	var lTrace = PurePeakTracker()
    var rTrace = PurePeakTracker()

    init(sampleRate: Double, withName name: String = String()) {
		fs = sampleRate
        ID = name
    }

    func process(leftInput: Double, rightInput: Double) {
		lTrace.process(input: leftInput)
        rTrace.process(input: rightInput)
    }

    func getCurrentvalues() -> (l: Double, r: Double) {
        return (lTrace.value, rTrace.value)
    }
}
