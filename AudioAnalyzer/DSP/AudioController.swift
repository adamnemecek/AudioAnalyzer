//
//  AudioController.swift
//  AudioTest3
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class AudioController {

    var engine: AVAudioEngine!
    var input: AVAudioInputNode!
    var output: AVAudioOutputNode!
    var bufSize: UInt32

    init(bufSize: UInt32) {
		engine = AVAudioEngine()
        input = engine.inputNode
        output = engine.outputNode
        self.bufSize = bufSize
        engine.connect(input, to: output, format: input.outputFormat(forBus: 0))
        engine.prepare()
        do 	{	try engine.start()
        }	catch	{
            print("Couldnt load the engine: \(error)")
        }
    }
}
