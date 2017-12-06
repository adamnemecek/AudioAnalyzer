//
//  SpectrumAnalyzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/2/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation
import Accelerate

class SpectrumAnalyzer {
    var audioController: AVAudioController!
    private var lFFT: FFT
    private var rFFT: FFT
    private var lBuf: UnsafeMutablePointer<Double>
    private var rBuf: UnsafeMutablePointer<Double>
    private var lSpecNorm: UnsafeMutablePointer<Double>
    private var rSpecNorm: UnsafeMutablePointer<Double>
    private var lSpecdB: UnsafeMutablePointer<Double>
    private var rSpecdB: UnsafeMutablePointer<Double>
    private var lSpecdBNorm: UnsafeMutablePointer<Double>
    private var rSpecdBNorm: UnsafeMutablePointer<Double>
    private var normalMult: Double = 0;
    private var normalAdd:  Double = 0;

    var maxdBValue: Double =   0.0 { didSet{ calculateNormalizationAffineTransform() }}
    var mindBValue: Double = -80.0 { didSet{ calculateNormalizationAffineTransform() }}
    var ref: Double = 1.0
    var bins: [Double] { return lFFT.getBins() }
    var numBins: Int { return Int(lFFT.fftSize) }
    var fftSize: Int { return Int(lFFT.fftSize) }

    private var writePos = 0 { didSet {
        if writePos == fftSize { computeSpectrum(); writePos = 0 } } }

    init(_ controller: AVAudioController) {
		audioController = controller

        let fftSz = Int(controller.bufSize)
        let fs = audioController.sampleRate

        lFFT = FFT(fftSize: UInt32(fftSz), sampleRate: fs)
        rFFT = FFT(fftSize: UInt32(fftSz), sampleRate: fs)

        lBuf = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        rBuf = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        lSpecNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        rSpecNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        lSpecdB = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        rSpecdB = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        lSpecdBNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)
        rSpecdBNorm = UnsafeMutablePointer<Double>.allocate(capacity: fftSz)

        calculateNormalizationAffineTransform()
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
		lBuf[writePos] = Double(leftInput)
        rBuf[writePos] = Double(rightInput)
        writePos += 1
    }

    func computeSpectrum() {
        lFFT.process(dataPtr: lBuf, fftMagPtr: lSpecNorm)
        rFFT.process(dataPtr: rBuf, fftMagPtr: rSpecNorm)
    }

    func getSpectrumPtrs() -> (leftPtr: UnsafeMutablePointer<Double>, rightPtr: UnsafeMutablePointer<Double>) {
        return (leftPtr: lSpecdBNorm, rightPtr: rSpecdBNorm)
    }

    func triggerUpdate(completion: () -> Void) {
        calculateNormlizeddBSpectrum()
        completion()
    }

    func calculateNormlizeddBSpectrum() {
        vDSP_vdbconD(lSpecNorm, 1, &ref, lSpecdB, 1, lFFT.fftSize, 1)
        vDSP_vdbconD(rSpecNorm, 1, &ref, rSpecdB, 1, lFFT.fftSize, 1)
        vDSP_vsmsaD(lSpecdB, 1, &normalMult, &normalAdd, lSpecdBNorm, 1, lFFT.fftSize)
        vDSP_vsmsaD(rSpecdB, 1, &normalMult, &normalAdd, rSpecdBNorm, 1, lFFT.fftSize)
    }


    func calculateNormalizationAffineTransform() {
        normalMult = 1.0/(maxdBValue - mindBValue)
        normalAdd = -mindBValue/(maxdBValue - mindBValue)
    }
}

