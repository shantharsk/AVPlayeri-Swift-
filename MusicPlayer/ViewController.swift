//
//  ViewController.swift
//  MusicPlayer
//
//  Created by shantha on 4/18/16.
//  Copyright © 2016 sridama. All rights reserved.
//

import UIKit
import MediaPlayer


class ViewController: UIViewController,AVAudioPlayerDelegate {
    
   
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progreesView: UIProgressView!
    var player : AVAudioPlayer! = nil
   
    @IBOutlet weak var imgAudio: UIImageView!
   
    private var progress: UInt8 = 0

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sliderProgress: UISlider!
    
    var audioPlayer = AVAudioPlayer()
    var activitySound = NSURL()
    
    var updater : CADisplayLink! = nil // tracks the time into the track
    var updater_running : Bool = false // did the updater start?
    var playing : Bool = false //indicates if track was started playing

    
    override func viewDidLoad() {
        super.viewDidLoad()
         UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
         let audioPath:NSURL! = NSBundle.mainBundle().URLForResource("Dhushta", withExtension: "mp3")
        
        let audioInfo = MPNowPlayingInfoCenter.defaultCenter()
        let audioName = audioPath.lastPathComponent!
        audioInfo.nowPlayingInfo = [ MPMediaItemPropertyTitle: audioName, MPMediaItemPropertyArtist:"artistName"]
        
        
        let playerItem = AVPlayerItem(URL: audioPath)
        let metadataList = playerItem.asset.commonMetadata 
        for item in metadataList {
            if item.commonKey == "title" {
                print("Title = " + item.stringValue!)
            }
            if item.commonKey == "artist" {
                print("Artist = " + item.stringValue!)
            }
            if item.commonKey  == "artwork" {
                if let image = UIImage(data: item.dataValue!) {
                    
                    self.imgAudio.image = image
//                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
                    print(image.description)
                }
            }
        }
        
        
//        let file = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("file1", ofType: "mp3")!)
//        audioPlayer = try! AVAudioPlayer(contentsOfURL: file, fileTypeHint: nil)
//        audioPlayer.delegate = self
        
        sliderProgress.continuous = false
        
//        configureFourColorCircularProgress()
//        configureStarProgress()
//                NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view, typically from a nib.
    }

    // method makes sure updater gets stopped when leaving view controller, because otherwise it will run indefinitely in background
    override func viewWillDisappear(animated: Bool) {
        if playing == true {
            audioPlayer.stop()
        }
        updater.invalidate()
        updater_running = false
        super.viewWillDisappear(animated)
    }

    
    @IBAction func btnPlay(sender: AnyObject) {
        
//        let path = NSBundle.mainBundle().pathForResource("Dhushta", ofType:"mp3")
//        let fileURL = NSURL(fileURLWithPath: path!)
//        
//        updater = CADisplayLink(target: self, selector: Selector("trackAudio"))
//        updater.frameInterval = 1
//        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
////        player = AVAudioPlayer(contentsOfURL: fileURL, fileTypeHint: nil)
//        player = try! AVAudioPlayer(contentsOfURL: fileURL)
////      NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
//        player.numberOfLoops = -1 // play indefinitely
//        player.prepareToPlay()
//        player.delegate = self
//        player.play()
//        
//        sliderProgress.minimumValue = 0
//        sliderProgress.maximumValue = 100 // Percentage
        
        
        if (playing == false) {
                    let path = NSBundle.mainBundle().pathForResource("Dhushta", ofType:"mp3")
                    let fileURL = NSURL(fileURLWithPath: path!)
            updater = CADisplayLink(target: self, selector: Selector("updateProgress"))
            updater.frameInterval = 1
            updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            updater_running = true
             audioPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
             audioPlayer.delegate = self
            audioPlayer.play()
            playButton.selected = true // pause image is assigned to "selected"
            playing = true
            updateProgress()
        } else {
            updateProgress()  // update track time
            audioPlayer.pause()  // then pause
            playButton.selected = false  // show play image (unselected button)
            playing = false // note track has stopped playing
        }

        
        
//        updater = CADisplayLink(target: self, selector: ("updateSliderProgress"))
//        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func updateProgress() {
        let total = Float(audioPlayer.duration/60)
        let current_time = Float(audioPlayer.currentTime/60)
        sliderProgress.minimumValue = 0.0
        sliderProgress.maximumValue = Float(audioPlayer.duration)
        sliderProgress.setValue(Float(audioPlayer.currentTime), animated: true)
//        timeLabel.text = NSString(format: "%.2f/%.2f", current_time, total) as String
    }

    
    @IBAction func slidePrgressMove(sender: UISlider) {
        var wasPlaying : Bool = false
        if playing == true {
            audioPlayer.pause()
            wasPlaying = true
        }
        audioPlayer.currentTime = NSTimeInterval(round(sliderProgress.value))
        updateProgress()
        // starts playing track again it it had been playing
        if (wasPlaying == true) {
            audioPlayer.play()
            wasPlaying = false
        }

        
    }
    
    
//    func trackAudio() {
//        var normalizedTime = Float(player.currentTime * 100.0 / player.duration)
//        sliderProgress.value = normalizedTime
//    }
//    
//    func updateSliderProgress(){
//        var progress = player.currentTime / player.duration
//        print(progress)
////        sliderProgress.minimumValue = 0.0
////        sliderProgress.maximumValue = Float(progress)
////        sliderProgress.minimumValue = 0
////        self.sliderProgress.maximumValue = Float(progress)
//        self.sliderProgress.setValue(Float(progress), animated: false)
////        self.progreesView = progress
//    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
