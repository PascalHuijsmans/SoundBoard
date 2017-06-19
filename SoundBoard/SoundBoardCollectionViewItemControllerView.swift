//
//  SoundBoardCollectionViewItemControllerView.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 21/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardCollectionViewItemControllerView: NSView {
    
    let soundBoardManager = SoundBoardManager.sharedInstance
    var soundBoardKey: SoundBoardKey?

    override func viewWillDraw() {
        let textColor = NSColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        soundBoardKeyNameLabel?.textColor = textColor
        soundBoardKeyKeyLabel?.textColor = textColor
        
        self.soundBoardCollectionViewItemDropView.delegate = self
        
        if let soundBoardKey = self.soundBoardKey {
            self.updateView(soundBoardKey: soundBoardKey)
        }
    }
    
    @IBOutlet var soundBoardCollectionViewItemDropView: SoundBoardCollectionViewItemDropView!
    @IBOutlet var soundBoardKeyNameLabel: NSTextField!
    @IBOutlet var soundBoardKeyKeyLabel: NSTextField!
    @IBOutlet var soundBoardKeyVolumeSlider: NSSlider!
    
    @IBAction func soundBoardKeyVolumeSliderSlide(_ sender: NSSlider) {
        if let soundBoardKey = self.soundBoardKey {
            if let soundBoardSound = soundBoardKey.sound {
                soundBoardSound.volume = sender.doubleValue
                self.soundBoardManager.updateVolumeForSoundBoardKey(soundBoardKey: soundBoardKey)
            }
        }
    }
    
    @IBAction func soundBoardKeyPlayButtonClick(_ sender: NSButton) {
        if let soundBoardKey = self.soundBoardKey {
            self.soundBoardManager.playSoundForSoundBoardKey(soundBoardKey: soundBoardKey)
        }
    }
    
    func updateView (soundBoardKey: SoundBoardKey) {
        soundBoardKeyKeyLabel.stringValue = soundBoardKey.keyLabel
        
        if let soundBoardSound = soundBoardKey.sound {
            soundBoardKeyNameLabel.stringValue = soundBoardSound.name
            soundBoardKeyVolumeSlider.doubleValue = soundBoardSound.volume
        }
    }
}

extension SoundBoardCollectionViewItemControllerView: SoundBoardCollectionViewItemDropViewDelegate {
    func filePathRecievedFromDropView (soundFileURL: URL){
        self.soundBoardKey = soundBoardManager.addNewSoundForSoundBoardKey(soundBoardKey: soundBoardKey!, soundFileURL: soundFileURL)
        if let soundBoardKey = self.soundBoardKey {
            self.updateView(soundBoardKey: soundBoardKey)
        }
    }
}
