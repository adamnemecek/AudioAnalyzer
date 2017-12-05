//
//  PhaseMeter.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation

struct PhaseDynamics {
    var name: String
    var peakValue: Double
    var rmsValue: Double
    var intValue: Double
    var corrValue: Double
}

class PhaseMeter {
    var fs: Double
    var ID: String
	var peakPhase = PhasePeakTracker()
    var rmsPhase = PhaseRMSTracker()
    var intPhase = PhaseIntegratorTracker()

    var peakL = PurePeakTracker()
    var peakR = PurePeakTracker()
    var rmsL = RMSTracker()
    var rmsR = RMSTracker()

    init(sampleRate: Double, withName name: String = String()) {
        fs = sampleRate
        ID = name
    }

    func process(leftInput: Double, rightInput: Double) {
        let phase = atan(leftInput/rightInput) * 180.0 / (2.0 * Double.pi)
        peakL.process(input: leftInput)
        peakR.process(input: rightInput)
        rmsL.process(input: leftInput)
        rmsR.process(input: rightInput)
        peakPhase.process(input: phase)
        rmsPhase.process(input: phase)
        intPhase.process(input: phase)
    }

    func getCurrentPhaseValues() -> PhaseDynamics {
        let values = PhaseDynamics(name: ID,
                                   peakValue: peakPhase.value,
                                   rmsValue: rmsPhase.value,
                                   intValue: intPhase.value,
                                   corrValue: getCorrelationValues())
        return values
    }
    func getCorrelationValues() -> Double {
        let corr = (peakL.value * peakR.value) / (rmsL.value * rmsR.value)
        return corr
    }
}
