//
//  ViewController.swift
//  ScreenRecoder
//
//  Created by 林暐秦 on 2019/11/28.
//  Copyright © 2019 imappUITests. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var colorPicker: UISegmentedControl!
    @IBOutlet var colorDisplay: UIView!
    @IBOutlet var micToggle: UISwitch!
    @IBOutlet var recordButton: UIButton!

    let recorder = RPScreenRecorder.shared()
    private var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recordButton.layer.cornerRadius = 32.5
    }
    
    func viewReset() {
        micToggle.isEnabled = true
        statusLabel.text = "Ready to Record"
        statusLabel.textColor = UIColor.black
        recordButton.backgroundColor = UIColor.green
    }
    
    func startRecording() {
        print(1)
        guard recorder.isAvailable else {
            print("Recording is not available at this.time.")
            return
        }
         print(2)
        recorder.isMicrophoneEnabled = micToggle.isOn
         print(3)
        if #available(iOS 10.0, *) {
            recorder.startRecording { [unowned self] (error) in
                guard error == nil else {
                    print("There was an error starting the recording.")
                    return
                }
                print(4)
                // 3
                print("Started Recording Successfully")
                self.micToggle.isEnabled = false
                self.recordButton.backgroundColor = UIColor.red
                self.statusLabel.text = "Recording..."
                self.statusLabel.textColor = UIColor.red
                
                self.isRecording = true
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func stopRecording() {
        print("stop Recording start")
        recorder.stopRecording { [unowned self] (preview, error) in
            guard preview != nil else {
                print("Preview controller is not available.")
                return
            }
            print("Stopped recording")
            let alert = UIAlertController(title: "Recording Finished", message: "Would you like to edit or delete your recording?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction) in
                self.recorder.discardRecording(handler: { () -> Void in
                    print("Recording suffessfully deleted.")
                })
            })
            
            let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction) -> Void in
                preview?.previewControllerDelegate = self
                self.present(preview!, animated: true, completion: nil)
            })
            
            alert.addAction(editAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
            
            self.isRecording = false
            print("stop Recording viewReset")
            self.viewReset()
            
        }
        print("stop Recording end")
    }
    
    @IBAction func colors(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            colorDisplay.backgroundColor = UIColor.red
        case 1:
            colorDisplay.backgroundColor = UIColor.blue
        case 2:
            colorDisplay.backgroundColor = UIColor.orange
        case 3:
            colorDisplay.backgroundColor = UIColor.green
        default:
            colorDisplay.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        print(isRecording)
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

