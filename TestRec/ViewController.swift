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
        let fileDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0] + "/temp"
        let fileMgr = FileManager.default
        
        do {
            try fileMgr.createDirectory(at: URL(fileURLWithPath: fileDir), withIntermediateDirectories: true, attributes: nil)
        } catch  {
            print(error.localizedDescription)
        }
        let filepath =  fileDir + filename
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
            print(error.localizedDescription)
        }
        
    }
    
    
    func setttingAudioSession(mode:AutioSessionMode) {
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { (answer) in
            print(answer)
        }
        do {
            switch mode {
            case .record:
                try session.setCategory(AVAudioSession.Category.playAndRecord)
            case .play:
                try session.setCategory(AVAudioSession.Category.playback)
                try session.setActive(false)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK:AudioRecord Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true{
            print("錄成功")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            } catch  {
                print(error.localizedDescription)
            }
        }else{
            print("錄失敗")
        }
    }
    

    @IBAction func record(_ sender: UIButton) {
        print("開始錄")
        setttingAudioSession(mode: .record)
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        isRecording = true
    }

    @IBAction func stopRec(_ sender: UIButton) {
        print("結束錄")
        isRecording = false
        audioRecorder.stop()
        self.setttingAudioSession(mode: .play)
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        print("play")
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
            audioPlayer?.play()
        }
    }
    
    @IBAction func stopPlay(_ sender: Any) {
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
        }
    }
    
    
    
}

