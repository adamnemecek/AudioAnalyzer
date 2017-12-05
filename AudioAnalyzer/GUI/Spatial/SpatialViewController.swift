//
//  SpatialViewController.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class SpatialViewController: UIViewController {

    var timer = Timer()
    var controller = AudioController(bufSize: 1024)
    var analyzer = SpatialAnalyzer()

    @IBOutlet weak var lissajousView: LissajousView!
    @IBOutlet weak var phaseMeterView: PhaseMeterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer.controller = controller
        analyzer.run()
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            self.updateGraphs()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		timer.invalidate()
        analyzer.stop()
    }

    func updateGraphs() {
        let phas = analyzer.phaseMeter.getCurrentPhaseValues()
        let XY = analyzer.goniometer.getCurrentvalues()
        phaseMeterView.setValue(phas)
        lissajousView.setValue(x: CGFloat(XY.l), y: CGFloat(XY.r))
    }

    @IBAction func configButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueToSpatialConfigTab", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
