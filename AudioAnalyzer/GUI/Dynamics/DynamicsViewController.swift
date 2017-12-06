//
//  DynamicsViewController.swift
//  AudioAnalyzer
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import UIKit

class DynamicsViewController: UIViewController {

    var audioController: AVAudioController { return (UIApplication.shared.delegate as! AppDelegate).audioController }
    
    var analyzer: DynamicsAnalyzer!
    var timer = Timer()

    @IBOutlet weak var lMeter: MeterView!
    @IBOutlet weak var rMeter: MeterView!
    @IBOutlet weak var mMeter: MeterView!
    @IBOutlet weak var sMeter: MeterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        analyzer = DynamicsAnalyzer(audioController)
        analyzer.run()
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
            self.updateMeters()
        })
        // Do any additional setup after loading the view.
    }

    func updateMeters() {
        lMeter.setDynamics(newValues: analyzer.lMeter.getCurrentValues())
        rMeter.setDynamics(newValues: analyzer.rMeter.getCurrentValues())
        mMeter.setDynamics(newValues: analyzer.mMeter.getCurrentValues())
        sMeter.setDynamics(newValues: analyzer.sMeter.getCurrentValues())

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
		analyzer.stop()
    }


    @IBAction func configButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "segueToDynamicsConfigTab", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
