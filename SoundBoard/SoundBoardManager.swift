//
//  SoundboardManager.swift
//  Soundboard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 pascal huijsmans. All rights reserved.
//
import Cocoa
import Foundation

class SoundBoardManager {
    static let sharedInstance = SoundBoardManager()
    
    let soundBoardFileManager : SoundBoardFileManager
    let soundBoardSoundManager : SoundBoardSoundManager
    
    var soundBoardKeycodes : [String]
    
    init() {
        self.soundBoardFileManager = SoundBoardFileManager()
        self.soundBoardSoundManager = SoundBoardSoundManager()
        self.soundBoardKeycodes = [""]
        self.startKeysEventsListener()
    }
    
    func canMakeSoundboardFoldersAndFiles() -> Bool {
        return self.soundBoardFileManager.checkSoundboardFoldersAndFiles()
    }
    
    func canAccessAccessibilityPrivileges() -> Bool {
        var options: [String: Bool] = [:]
        options[kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String] = true
        return AXIsProcessTrustedWithOptions(options as CFDictionary?)
    }
    
    func getSoundBoardKeys() -> [SoundBoardKey] {
        var soundBoardKeyItems = [SoundBoardKey]()
        
        if let keysDictionary = NSDictionary(contentsOf: self.soundBoardFileManager.availableKeysPropertyListFile) {
            self.soundBoardKeycodes = [""]
            
            var soundDictionary = NSDictionary()
            if let soundDictionaryContents = NSDictionary(contentsOf: self.soundBoardFileManager.soundboardPropertyListFile) {
                soundDictionary = soundDictionaryContents
            }
                
            for (key, value) in keysDictionary {
                let values = value as! NSDictionary
                
                self.soundBoardKeycodes.append(key as! String)
                
                let soundBoardKey = SoundBoardKey(keyCode: key as! String, keyLabel: values["KeyboardKeyLabel"]! as! String, position: values["SoundBoardPosition"]! as! Int, section: values["SoundBoardSection"]! as! Int)
                    
                if (soundDictionary[soundBoardKey.keyCode] != nil) {
                    if let soundEntry = soundDictionary[soundBoardKey.keyCode] as? NSDictionary {
                        soundBoardKey.sound = SoundBoardSound(name: soundEntry["LabelName"] as! String, filename: soundEntry["SoundName"] as! String, filetype: soundEntry["SoundType"] as! String, duration: Double(soundEntry["SoundDuration"] as! String)!, volume: Double(soundEntry["SoundVolume"] as! String)!)
                    }
                }
                soundBoardKeyItems.append(soundBoardKey)
            }
        }
        return soundBoardKeyItems
    }
    
    func getSoundBoardKeyByKeyCode(keyCode: String) -> SoundBoardKey? {
        if let soundBoardKey = self.getSoundBoardKeys().first(where: { $0.keyCode == keyCode }) {
            return soundBoardKey
        }
        return nil
    }
    
    func addNewSoundForSoundBoardKey(soundBoardKey: SoundBoardKey, soundFileURL: URL) -> SoundBoardKey {
        let newFileName = "sound_" + soundBoardKey.keyCode + "." + soundFileURL.pathExtension
        let newFileURL = self.soundBoardFileManager.soundsDirectory.appendingPathComponent(newFileName)
     
        let labelName = soundFileURL.deletingPathExtension().lastPathComponent
        
        if (self.soundBoardFileManager.fileDirectoryExists(url: newFileURL)) {
            _ = self.soundBoardFileManager.removeFile(url: newFileURL)
        }
        
        if (self.soundBoardFileManager.copyFile(at: soundFileURL, to: newFileURL)) {
            if let duration = self.soundBoardSoundManager.getSoundDuration(sound: newFileURL) {
                
                let soundBoardSound = SoundBoardSound(name: labelName, filename: newFileURL.deletingPathExtension().lastPathComponent, filetype: newFileURL.pathExtension, duration: duration, volume: 1.0)
                
                if let dictionary = NSMutableDictionary(contentsOf: self.soundBoardFileManager.soundboardPropertyListFile) {
                    
                    let newSoundItemDictionary = ["LabelName": labelName, "SoundName": soundBoardSound.filename, "SoundType": soundBoardSound.filetype, "SoundDuration": String(soundBoardSound.duration), "SoundVolume": String(soundBoardSound.volume)]
                    
                    dictionary[soundBoardKey.keyCode] = newSoundItemDictionary
            
                    if (dictionary.write(to: self.soundBoardFileManager.soundboardPropertyListFile, atomically: false)) {
                        soundBoardKey.sound = soundBoardSound
                    }
                }
            }
        }
        
        return soundBoardKey
    }
    
    func playSoundForSoundBoardKey(soundBoardKey: SoundBoardKey) {
        if let soundBoardSound = soundBoardKey.sound {
            let fileName = soundBoardSound.filename + "." + soundBoardSound.filetype
            let fileURL = self.soundBoardFileManager.soundsDirectory.appendingPathComponent(fileName)
            if (self.soundBoardFileManager.fileDirectoryExists(url: fileURL)) {
                self.soundBoardSoundManager.play(url: fileURL, volume: soundBoardSound.volume)
            }
        }
    }
    
    func updateVolumeForSoundBoardKey(soundBoardKey: SoundBoardKey) {
        if let dictionary = NSMutableDictionary(contentsOf: self.soundBoardFileManager.soundboardPropertyListFile) {
            if (dictionary[soundBoardKey.keyCode] != nil) {
                if let soundEntry = dictionary[soundBoardKey.keyCode] as? NSMutableDictionary {
                    if let sound = soundBoardKey.sound {
                        soundEntry["SoundVolume"] = String(sound.volume)
                        self.soundBoardSoundManager.updateAudioPlayerValue(volume: sound.volume)
                        dictionary.write(to: self.soundBoardFileManager.soundboardPropertyListFile, atomically: false)
                    }
                }
            }
        }
    }
    
    private func startKeysEventsListener() {
        let mask = NSEventMask.keyDown
        
        NSEvent.addGlobalMonitorForEvents(matching: mask, handler: {(event: NSEvent!) -> Void in
            if (event.modifierFlags.contains([.control]) && self.soundBoardKeycodes.contains(String(event.keyCode))) {
                self.playSoundForSoundBoardKey(soundBoardKey: self.getSoundBoardKeyByKeyCode(keyCode: event.keyCode.description)!)
            }
        });
        
        NSEvent.addLocalMonitorForEvents(matching: mask, handler: {(event: NSEvent!) -> NSEvent? in
            if (event.modifierFlags.contains([.control]) && self.soundBoardKeycodes.contains(String(event.keyCode))) {
                self.playSoundForSoundBoardKey(soundBoardKey: self.getSoundBoardKeyByKeyCode(keyCode: event.keyCode.description)!)
            }
            return nil
        });
    }
    
    func alert(message: String, info: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = info
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
