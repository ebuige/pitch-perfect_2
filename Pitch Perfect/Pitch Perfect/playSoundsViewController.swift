//
//  playSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Troutslayer33 on 3/17/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//
// Play Sounds View Controller receives an audio file and will play back that
// audio either fast or slow or with two different variable pitches to make it sound
// like a chipmunk or Darth Vader

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {
    
    // Declare objects
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!

    // When the view loads initialize an audioPlayer, audioEngine and convert receivedAudio to AVAudioFile

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine  = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function calls the initializer for audioplayer and sets the rate property to 2.0
    // then it plays the audio file at twice the normal speed

    @IBAction func playFast(sender: AnyObject) {
        initAudioPlayerEngine(2.0)
        audioPlayer.play()
    }
    
    // This function calls the initializer for audioplayer and sets the rate property to 0.5
    // then it plays the audio file at half the normal speed
    
    @IBAction func playSlow(sender: AnyObject) {
        initAudioPlayerEngine(0.5)
        audioPlayer.play()
    }
    
    // this function calls playAudioWithVariablePitch passing a value (pitch)
    // of -1000 to make the audio file sound like Darth Vader
    
    @IBAction func playDarthVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    // this function calls playAudioWithVariablePitch passing a value (pitch)
    // of 1000 to make the audio file sound like a chipmunk
    
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
        
    }
    
    // called when stop button is pressed
    
    @IBAction func stopPlayer(sender: AnyObject) {
        stopAllAudio()
    }
    
    // Stop all audio and initialize audio player with the rate and set the audio to
    // play from the beginning of the recording (currentTime)
    
    func initAudioPlayerEngine(rate: Float) {
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        
    }
    
    // Stops all audio
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    // plays audio with a varible pitch. To do this you need to create an AVAudioPlayerNode and a
    // AVAudioUnitTimePitch, set the pitch and attach these to an audioEngine lines (104 - 109). 
    // Line 112 connects the AVAudioPlayerNode to AVAudioUnitTimePitch. Line 113 connects 
    // AVAudioUnitTimePitch to the output (speakers). Lines 116 - 118 plays the audio
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    }
