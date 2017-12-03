//
//  SpectrumAnalyzer.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/2/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class SpectrumAnalyzer {

    var audioSession = AVAudioSession.sharedInstance()
    var controller: AudioController!
    var sampleRate: Double
    var fftSize: Int

    private var lFFT: FFT
    private var rFFT: FFT

    private var lBuf: UnsafeMutablePointer<Double>
    private var rBuf: UnsafeMutablePointer<Double>

	private var lSpec: UnsafeMutablePointer<Double>
    private var rSpec: UnsafeMutablePointer<Double>

    var bins: [Double] { return lFFT.getBins() }
    var numBins: Int { return fftSize }

    private var writePos = 0 { didSet {
            if writePos == fftSize {
                computeSpectrum()
                writePos = 0
            } }
    }

    init(fftSize: Int) {
        self.fftSize = fftSize
        sampleRate = audioSession.sampleRate
        lFFT = FFT(fftSize: self.fftSize, sampleRate: sampleRate)
        rFFT = FFT(fftSize: self.fftSize, sampleRate: sampleRate)

        lBuf = UnsafeMutablePointer<Double>.allocate(capacity: fftSize)
        rBuf = UnsafeMutablePointer<Double>.allocate(capacity: fftSize)

        lSpec = UnsafeMutablePointer<Double>.allocate(capacity: fftSize)
        rSpec = UnsafeMutablePointer<Double>.allocate(capacity: fftSize)
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
		lBuf[writePos] = Double(leftInput)
        rBuf[writePos] = Double(rightInput)
        writePos += 1
    }

    func computeSpectrum() {
        lFFT.process(dataPtr: lBuf, fftMagPtr: lSpec)
        rFFT.process(dataPtr: rBuf, fftMagPtr: rSpec)
    }

    func getSpectrum() -> (left: [Double], right: [Double]) {
//        assert(writePos != fftSize)

        var left: [Double] = [Double]()
        var right: [Double] = [Double]()

        left.reserveCapacity(fftSize)
        right.reserveCapacity(fftSize)

        for i in 0..<fftSize {
            left.append(lSpec[i])
            right.append(rSpec[i])
        }

        return (left, right)
    }

    func getLeftSpectrum() -> [Double] {
        var left: [Double] = [Double]()

        left.reserveCapacity(fftSize)

        for i in 0..<fftSize {
            left.append(20 * log10(lSpec[i]))
        }

        return left
    }

    func getRightSpectrum() -> [Double] {
        assert(writePos != fftSize)

        var right: [Double] = [Double]()
        right.reserveCapacity(fftSize)

        for i in 0..<fftSize {
            right[i] = rSpec[i]
        }

        return right
    }
}

