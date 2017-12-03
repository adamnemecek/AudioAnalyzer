//
//  FFT.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 12/3/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import Accelerate

class FFT {
    let N: vDSP_Length
    let NLog: vDSP_Length
    var setup: FFTSetup
    var complexPtr: UnsafeMutablePointer<Double>
    var complex: DSPDoubleSplitComplex
    var fftFact: Double

    var fs: Double

    init(fftSize: Int, sampleRate: Double) {
        N = vDSP_Length(fftSize * 4)
        NLog = vDSP_Length(log2(Double(N)))
        setup = vDSP_create_fftsetupD(NLog, FFTRadix(FFT_RADIX2))!
        fftFact = 1.0 / (Double(fftSize))

        complexPtr = UnsafeMutablePointer<Double>.allocate(capacity: Int(N))
        complex = DSPDoubleSplitComplex(realp: complexPtr, imagp: complexPtr.advanced(by: Int(N/2)))

        fs = sampleRate
    }

    deinit {
        vDSP_destroy_fftsetupD(setup)
    }

    func process(data: inout [Double], fftMag: inout [Double]) {

        vDSP_vsmulD(&data, 1, &fftFact, complexPtr, 1, N / 4)
        vDSP_vclrD(complexPtr.advanced(by: Int(N/4)), 1, 3 * N / 4)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))

        complex.imagp[0] = Double(0.0)

        vDSP_zvabsD(&complex, 1, &fftMag, 1, N / 4)
    }

    func process(dataPtr: UnsafeMutablePointer<Double>, fftMagPtr: UnsafeMutablePointer<Double>) {
        vDSP_vsmulD(dataPtr, 1, &fftFact, complexPtr, 1, N / 4)
        vDSP_vclrD(complexPtr.advanced(by: Int(N/4)), 1, 3 * N / 4)
        vDSP_fft_zripD(setup, &complex, 1, NLog, FFTDirection(FFT_FORWARD))

        complex.imagp[0] = Double(0.0)

        vDSP_zvabsD(&complex, 1, fftMagPtr, 1, N / 4)
    }

    func getBins() -> [Double] {
        let fftSize = Double(N/4)
        return ( 0..<Int(fftSize) ).map{ Double($0) * fs/2 / fftSize }
    }

}
