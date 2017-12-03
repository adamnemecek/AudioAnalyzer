//
//  DynamicsAnalayzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/29/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation



class DynamicsAnalyzer {

    var audioSession = AVAudioSession.sharedInstance()
    var controller: AudioController!

    lazy var lMeter = Meter(sampleRate: sampleRate, withName: "Left Meter")
    lazy var rMeter = Meter(sampleRate: sampleRate, withName: "Right Meter")
    lazy var mMeter = Meter(sampleRate: sampleRate, withName: "Mid Meter")
    lazy var sMeter = Meter(sampleRate: sampleRate, withName: "Side Meter")

    var sampleRate: Double

    init() {
        sampleRate = audioSession.sampleRate
    }

    func run() {
        stop()
		installTap()
    }

    func stop() {
        removeTap()
    }

    func installTap() {
        if let input = controller?.input {
            input.installTap(onBus: 0, bufferSize: controller!.bufSize, format: input.outputFormat(forBus: 0), block: { (buffer, timeStamp) in
                if let data = buffer.floatChannelData {
                    let bufSize = Int(buffer.frameLength)
                    for i in 0..<bufSize {
                        self.process(leftInput: data[0][i], rightInput: data[0][i])
                    }
                }
            })
        }
    }

    func removeTap() {
        if let input = controller?.input{
            input.removeTap(onBus: 0)
        }
    }

    func process(leftInput: Float, rightInput: Float) {

		let l = Double(leftInput)
        let r = Double(rightInput)
		let m = (l + r) / 2
		let s = (l - r) / 2

		lMeter.process(input: l)
        rMeter.process(input: r)
        mMeter.process(input: m)
        sMeter.process(input: s)
    }

}
