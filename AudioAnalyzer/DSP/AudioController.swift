//
//  AudioController.swift
//  AudioTest3
//
//  Created by Juan David Sierra on 11/28/17.
//  Copyright © 2017 JuanSaudio. All rights reserved.
//

import Foundation
import AVFoundation

class AVAudioController {

    var sampleRate: Double {
        set { configureAudioSession(sampleRate: newValue,
                                    bufSize: UInt32(session.ioBufferDuration * newValue))
        }
        get { return session.sampleRate }
    }
    var bufSize: UInt32 {
        set { configureAudioSession(sampleRate: sampleRate, bufSize: newValue) }
        get { return UInt32(session.ioBufferDuration * sampleRate) }
    }

    var session: AVAudioSession
    var engine: AVAudioEngine!
    var input: AVAudioInputNode!
    var output: AVAudioOutputNode!

    init(sampleRate: Double, bufSize: UInt32) {
        session = AVAudioSession.sharedInstance()
        initializeAudioSession(sampleRate: sampleRate, bufSize: bufSize)
        engine = AVAudioEngine()
        configureAudioEngine()
        runAudioEngine()
        registerObservers()
    }

    deinit {
        stopAudioEngine()
        terminateAudioSession()
    }

    func runAudioEngine() {
        engine.prepare()
        do     {
            try engine.start()
        }    catch    {
            print("Couldnt load the engine: \(error)")
        }
    }

    func stopAudioEngine() {
        engine.stop()
    }

    func configureAudioEngine() {
        input = engine.inputNode
        output = engine.outputNode
        engine.connect(input, to: output, format: input.outputFormat(forBus: 0))
    }

    func initializeAudioSession(sampleRate: Double, bufSize: UInt32) {
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeMeasurement, options: AVAudioSessionCategoryOptions.interruptSpokenAudioAndMixWithOthers)
            try session.setPreferredSampleRate(sampleRate)
            try session.setPreferredIOBufferDuration(Double(bufSize)/sampleRate)

            session.requestRecordPermission({ (success) in
                if success { print("Permission Granted") } else {
                    print("A carajo")
                    // TODO: UIAlertNotification
                }
            })
        }    catch    {
            print("Audio session not loaded properly \(error)")
        }
    }

    func configureAudioSession(sampleRate: Double, bufSize: UInt32) {
        do {
            try session.setPreferredSampleRate(sampleRate)
            try session.setPreferredIOBufferDuration(Double(bufSize)/sampleRate)
        } catch {
            print("Audio Session Couldnt be setup: \(error)")
        }
    }

    func terminateAudioSession() {

    }

    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(AudioSessionInterrupted), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioRouteChanged), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AudioEngineChanged), name: NSNotification.Name.AVAudioEngineConfigurationChange, object: nil)
    }

    func deregisterObservers() {
        // TODO
    }
}

extension AVAudioController {
    @objc func AudioSessionInterrupted() {
        print("Audio Session Interrupted")
    }

    @objc func AudioRouteChanged() {
        print("Audio Route Change")
    }

    @objc func AudioEngineChanged() {
        print("Audio Engine Changed")
    }
}

