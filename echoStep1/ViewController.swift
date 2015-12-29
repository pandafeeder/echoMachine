//
//  ViewController.swift
//  echoStep1
//
//  Created by qusr on 11/22/15.
//  Copyright © 2015 qusr. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var recordBTN: UIButton!
    @IBOutlet var table: UITableView!

    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer   : AVAudioPlayer!
    var recordCount = 0
    var fileList = [NSURL]()
    
    let longPressRec = UILongPressGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        longPressRec.addTarget(self, action: "longPressRecordAndReleasePlay")
        recordBTN.addGestureRecognizer(longPressRec)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getFileURL()->NSURL {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDir = path[0]
        let stringName = String(recordCount) + ".m4a"
        let fileName = documentDir.stringByAppendingString(stringName)
        let audioURL = NSURL(fileURLWithPath: fileName)
        fileList.append(audioURL)
        //print(fileList)
        return audioURL
    }
    
    
    func longPressRecordAndReleasePlay () {
        
        let FileURL = getFileURL()
        switch longPressRec.state{
            
        case  .Began:
            
            //print("began")
            let settings = [
                AVSampleRateKey : NSNumber(float: Float(44100.0)),
                AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
                AVNumberOfChannelsKey : NSNumber(int: 1),
                AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue)),
                AVEncoderBitRateKey : NSNumber(int: Int32(320000)) ]
            
            do {
                soundRecorder = try AVAudioRecorder(URL: FileURL, settings: settings)
                soundRecorder.delegate = self
                soundRecorder.prepareToRecord()
                soundRecorder.record()
            } catch {
                print("Recorder Error")
            }
            
        case .Ended:
            
            //print("ended")
            do {
                soundRecorder.stop()
                soundPlayer = try AVAudioPlayer(contentsOfURL: FileURL)
                soundPlayer.delegate = self
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 1.0
                soundPlayer.play()
                recordCount += 1
                table.reloadData()
            } catch {
                print("Player Error")
            }
            
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var fileListDivide2 = [NSURL]()
        for file in Array(Set(fileList)) {
            fileListDivide2.append(file)
        }
        let cell:UITableViewCell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        //cell.textLabel?.text = tryArray[indexPath.row]
        //let cellLable = cell.viewWithTag(1) as! UILabel
        //let textArray = ["sdfsadfs","sdfsadf","xxxxxx","etert","bvfhfgsdfg"]
        //cellLable.text = textArray[indexPath.row]
        //cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }
    
}

