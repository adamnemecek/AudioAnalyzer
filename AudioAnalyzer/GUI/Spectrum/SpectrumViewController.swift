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

    var controller = AudioController(bufSize: 1024)
    var analyzer = SpectrumAnalyzer(fftSize: 2048)
    var spectrumVertLimits: (min: Double, max: Double) = (-60, 10)
    var spectrumHorzLimits: (min: Double, max: Double) = (0, 22050)

    @IBOutlet weak var spectrum: SpectrumView!

    override func viewDidLoad() {
        super.viewDidLoad()

        analyzer.controller = controller
        analyzer.run()

        spectrumVertLimits = (-60, 10)
        spectrumHorzLimits = (0, 22050)

        setSpectrumViewNormalBins()

        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.updateSpectrum()
        })
    }

    func updateSpectrum() {
        let values = analyzer.getSpectrum()

        let leftNormValues = values.left.map{
            spectrumVertLimits.max - $0 / spectrumVertLimits.min
        }
        let rightNormValues = values.right.map{
            spectrumVertLimits.max - $0 / spectrumVertLimits.min
        }
        spectrum.setValues(left: leftNormValues, right: rightNormValues)

    }

    func setSpectrumViewNormalBins() {

        var linNormBins = ( 0..<analyzer.numBins ).map{ Double($0)/(Double(analyzer.numBins)) }
        let min = linNormBins[1]
        let max = 1.0
        let logBins = linNormBins.map{ log(($0 + min)/min) / log(max/min) }
        spectrum.setNormLogBins(logBins)
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
