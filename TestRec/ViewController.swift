//
//  ViewController.swift
//  TestRec
//
//  Created by 申潤五 on 2021/2/18.
//

import UIKit
import AVFoundation

enum AutioSessionMode {
    case record
    case play
}


class ViewController: UIViewController,AVAudioRecorderDelegate{

    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer?
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let filename = "temp.wav"
        let filepath =  NSHomeDirectory() + "/record/" + filename
        let fileUrl = URL(fileURLWithPath: filepath)
        let recordSettings:[String:Any] = [
            AVEncoderAudioQualityKey:AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey:16,
            AVNumberOfChannelsKey:2,
            AVSampleRateKey:44100.0
        ]
        do {
            audioRecorder = try AVAudioRecorder.init(url: fileUrl, settings: recordSettings)
            audioRecorder.delegate = self
        } catch  {
            audioRecorder = AVAudioRecorder.init()
            print(error.localizedDescription)
        }
        
    }
    
    
    func setttingAudioSession(mode:AutioSessionMode) {
        let session = AVAudioSession.sharedInstance()
        do {
            switch mode {
            case .play:
                try session.setCategory(AVAudioSession.Category.playAndRecord)
            case .record:
                try session.setCategory(AVAudioSession.Category.playback)
                try session.setActive(true)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK:AudioRecord Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true{
            recorder.url
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
    

    @IBAction func record(_ sender: UIButton) {
        setttingAudioSession(mode: .record)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        isRecording = true
    }

    @IBAction func stopRec(_ sender: UIButton) {
        isRecording = false
        audioRecorder.stop()
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
            audioPlayer?.play()
        }
    }
    
    @IBAction func stopPlay(_ sender: Any) {
    }
    
    
    
}

