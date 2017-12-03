//
//  OnePoleFilter.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation


class OnePoleFilter {
	private var b0 = 1.0
    private var a1 = 0.0
	private var val = 0.0

    func reset() {
        val = 0.0
    }

    func resetCoefs() {
        a1 = 0.0
        b0 = 1.0
    }

    func setTau(ms tau: Double, fs: Double) {
        a1 = exp(-1.0 / ( tau * fs / 1000.0 ) )
        b0 = 1.0 - a1
    }

    func process(input: Double, output: inout Double) {
        val += b0 * ( input - val )
        output = val
    }
}
