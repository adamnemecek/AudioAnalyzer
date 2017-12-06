//
//  SpectrumViewController.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit
import AVFoundation

class SpectrumViewController: UIViewController {

    var timer = Timer()

    var audioController: AVAudioController { return (UIApplication.shared.delegate as! AppDelegate).audioController }
    var analyzer:SpectrumAnalyzer!
    var spectrumVertLimits: (min: Double, max: Double) = (-40, 10)
    var spectrumHorzLimits: (min: Double, max: Double) = (0, 22050)

    var lPlotPtr: UnsafeMutableRawPointer!
    var rPlotPtr: UnsafeMutableRawPointer!
    var lAnaPtr:  UnsafeMutableRawPointer!
    var rAnaPtr:  UnsafeMutableRawPointer!

    @IBOutlet weak var spectrumView: SpectrumView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = SpectrumAnalyzer(audioController)
        analyzer.run()

        spectrumView.fftSize = analyzer.fftSize
        let ptr2Copy = spectrumView.initializeMemoryForPlot(forSize: analyzer.fftSize)
        let ptr4Copy = analyzer.getSpectrumPtrs()

        lPlotPtr = UnsafeMutableRawPointer(ptr2Copy.leftPtr)
        rPlotPtr = UnsafeMutableRawPointer(ptr2Copy.rightPtr)
        lAnaPtr  = UnsafeMutableRawPointer(ptr4Copy.leftPtr)
        rAnaPtr  = UnsafeMutableRawPointer(ptr4Copy.rightPtr)

        setSpectrumViewNormalBins()

        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.updateSpectrum()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        analyzer.stop()
    }

    func updateSpectrum() {
        analyzer.triggerUpdate {
            lPlotPtr.copyBytes(from: lAnaPtr, count: analyzer.fftSize * MemoryLayout<Double>.size)
            rPlotPtr.copyBytes(from: rAnaPtr, count: analyzer.fftSize * MemoryLayout<Double>.size)
            spectrumView.setNeedsDisplay()
        }
    }

    func setSpectrumViewNormalBins() {

        var linNormBins = ( 0..<analyzer.numBins ).map{ Double($0)/(Double(analyzer.numBins)) }
        let min = linNormBins[1]
        let max = 1.0
        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }

        spectrumView.setNormLogBins(logBins)
    }



    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() 

    }

        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
