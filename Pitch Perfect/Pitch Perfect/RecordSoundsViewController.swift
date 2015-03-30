//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Troutslayer33 on 3/11/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//
// Record Sounds View Controller is the initial view of the PitchPerfect App.
// When the user taps on the microphone the user can begin to record audio. Pressing the
// stop button will trigger the app to perform a segue to the second view in the app Play 
// Sounds View controller and from that view the user can play back the audio with four
// different effects. This class inherits from UIViewController and AVAudioRecorderDelegate

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
 
    // declare objects of type AVAudioRecorder and RecordedAudio
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    // Outlets created for views buttons and labels

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Before the view appears hide the stop button, show the recording in progress lable and set
    // the value of the lable to "Tap to Record"
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingInProgress.hidden = false
        self.recordingInProgress.text = "Tap to Record"
    }
    
    // This is the record function that gets called when the user taps the microphone to start recording
    // The first three lines manages the buttons and lables. In lines 65 - 72 the filepath where the audio
    // recording will be stored is determined (the documents directory on the user's phone) and the filename 
    // of the audio is created with the current date/time .wav. Lines 74-75 establish an audio session.
    // line 76 an audioRecorder is intialized with the location and filename of where to store the recorded
    // audio file. On line 78 Make Record Sounds View Controller a delegate of audioRecorder so you can call
    // some of the methods of AVAudioRecorderDelegate such as AudioRecorderDidFinishRecording. Prepare the 
    // recorder
    
    
    @IBAction func record(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        self.recordingInProgress.text = "Recording in Progress"
    
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    // This function is called when an audio recording finishes. It checks whether the recording finished
    // successfully and if so it initalizes an object of type RecordedAudio and initializes that object with 
    // the path and title of the recording which it gets from the recorder parameter of AVAudioRecorder. Then
    // it calls performSegueWithIdentifier with the title of the segue "stopRecording". If the recording does
    // not finish sucessfully it prints an error message and resets the buttons to an initial state
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            recordedAudio=RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording did not work")
            recordButton.enabled = true
            stopButton.hidden = false
        }
    }
    
    // This function is called before any segue, it checks to see if the segue indentifier is "stopRecording"
    // and if true it assigns the audiofile to playSoundsVC.receivedAudio
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:playSoundsViewController = segue.destinationViewController as playSoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    // this function is called when the stop button is pressed. buttons and labels are reset the audio
    // recorder is stopped and the audio session is ended

    @IBAction func stopRecord(sender: UIButton) {
        recordingInProgress.hidden = true
        recordButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

