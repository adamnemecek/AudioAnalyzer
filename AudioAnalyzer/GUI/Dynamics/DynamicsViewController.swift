//
//  DynamicsViewController.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class DynamicsViewController: UIViewController {

	var timer = Timer()

	var controller = AudioController(bufSize: 1024)
    var analyzer = DynamicsAnalyzer()

    var lMeter = MeterView()
    var rMeter = MeterView()
    var mMeter = MeterView()
    var sMeter = MeterView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //
		view.addSubview(lMeter)
        view.addSubview(rMeter)
        view.addSubview(mMeter)
        view.addSubview(sMeter)

        //
        analyzer.controller = controller
        analyzer.run()

        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            self.updateMeters()
        })
        // Do any additional setup after loading the view.
    }

    func updateMeters() {
		let values = analyzer.lMeter.getCurrentValues()

//        peakSlider.value = Float(values.peakValue)
//        rmsSlider.value = Float(values.rmsValue)
//        vuSlider.value = Float(values.vuValue)

        lMeter.setDynamics(newValues: analyzer.lMeter.getCurrentValues())
        rMeter.setDynamics(newValues: analyzer.rMeter.getCurrentValues())
        mMeter.setDynamics(newValues: analyzer.mMeter.getCurrentValues())
        sMeter.setDynamics(newValues: analyzer.sMeter.getCurrentValues())

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
		analyzer.stop()
    }

    override func viewLayoutMarginsDidChange() {
        lMeter.frame = CGRect(x: 100, y: 50, width: 50, height: 200)
        rMeter.frame = CGRect(x: 200, y: 50, width: 50, height: 200)
        mMeter.frame = CGRect(x: 300, y: 50, width: 50, height: 200)
        sMeter.frame = CGRect(x: 100, y: 50, width: 50, height: 200)
    }

    @IBAction func configButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueToDynamicsConfigTab", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let configTab = segue.destination
//        configTab
    }

}
