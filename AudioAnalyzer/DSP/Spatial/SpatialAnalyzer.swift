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
    var audioController: AVAudioController!

    var phaseMeter: PhaseMeter
    var goniometer: Goniometer

    init (_ controller: AVAudioController) {
        audioController = controller
        phaseMeter = PhaseMeter(sampleRate: audioController.sampleRate)
        goniometer = Goniometer(sampleRate: audioController.sampleRate)
        initialize()
    }

    func initialize() {
        let fs = audioController.sampleRate
		phaseMeter.peakPhase.setAttack(0.01, sampleRate: fs)
        phaseMeter.peakPhase.setRelease(0.3, sampleRate: fs)
        phaseMeter.rmsPhase.setTime(0.12, sampleRate: fs)

        phaseMeter.peakL.setTime(0.01, sampleRate: fs)
        phaseMeter.peakR.setTime(0.01, sampleRate: fs)
        phaseMeter.rmsL.setTime(0.12, sampleRate: fs)
        phaseMeter.rmsR.setTime(0.12, sampleRate: fs)
        
        goniometer.lTrace.setTime(0.01, sampleRate: fs)
        goniometer.rTrace.setTime(0.01, sampleRate: fs)
    }

    func run() {
        stop()
        installTap()
    }

    func stop() {
        removeTap()
    }

    func installTap() {
        if let input = audioController?.input {
            if input.numberOfInputs == 2 {
                input.installTap(onBus: 0, bufferSize: audioController!.bufSize, format: input.outputFormat(forBus: 0), block: { (buffer, timeStamp) in
                    if let data = buffer.floatChannelData {
                        let bufSize = Int(buffer.frameLength)
                        for i in 0..<bufSize {
                            self.process(leftInput: data[0][i], rightInput: data[1][i])
                        }
                    }
                })} else {
                input.installTap(onBus: 0, bufferSize: audioController!.bufSize, format: input.outputFormat(forBus: 0), block: { (buffer, timeStamp) in
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
        if let input = audioController?.input{
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
