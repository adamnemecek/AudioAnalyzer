//
//  SpatialAnalyzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/5/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class SpatialAnalyzer {
    var audioSession = AVAudioSession.sharedInstance()
    var controller: AudioController!

    lazy var phaseMeter = PhaseMeter(sampleRate: sampleRate)
    lazy var goniometer = Goniometer(sampleRate: sampleRate)

    var sampleRate: Double { return audioSession.sampleRate }

    func initialize() {
		phaseMeter.peakPhase.setAttack(0.01, sampleRate: sampleRate)
        phaseMeter.peakPhase.setRelease(0.3, sampleRate: sampleRate)
        phaseMeter.rmsPhase.setTime(0.12, sampleRate: sampleRate)

        phaseMeter.peakL.setTime(0.01, sampleRate: sampleRate)
        phaseMeter.peakR.setTime(0.01, sampleRate: sampleRate)
        phaseMeter.rmsL.setTime(0.12, sampleRate: sampleRate)
        phaseMeter.rmsR.setTime(0.12, sampleRate: sampleRate)
        
        goniometer.lTrace.setTime(0.01, sampleRate: sampleRate)
        goniometer.rTrace.setTime(0.01, sampleRate: sampleRate)
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
            if input.numberOfInputs == 2 {
                input.installTap(onBus: 0, bufferSize: controller!.bufSize, format: input.outputFormat(forBus: 0), block: { (buffer, timeStamp) in
                    if let data = buffer.floatChannelData {
                        let bufSize = Int(buffer.frameLength)
                        for i in 0..<bufSize {
                            self.process(leftInput: data[0][i], rightInput: data[1][i])
                        }
                    }
                })} else {
                input.installTap(onBus: 0, bufferSize: controller!.bufSize, format: input.outputFormat(forBus: 0), block: { (buffer, timeStamp) in
                    if let data = buffer.floatChannelData {
                        let bufSize = Int(buffer.frameLength)
                        for i in 0..<bufSize {
                            self.process(leftInput: data[0][i], rightInput: data[0][i])
                        }
                    }
                })}
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
        phaseMeter.process(leftInput: l, rightInput: r)
        goniometer.process(leftInput: l, rightInput: r)
    }
}
