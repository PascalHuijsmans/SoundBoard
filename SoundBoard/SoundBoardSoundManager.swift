//
//  SoundBoardSoundManager.swift
//  Soundboard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 pascal huijsmans. All rights reserved.
//

import Foundation
import AVFoundation

class SoundBoardSoundManager {
    var audioPlayer : AVAudioPlayer
    
    init() {
        self.audioPlayer = AVAudioPlayer()
    }
    
    func play(url: URL, volume: Double?) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.updateAudioPlayerValue(volume: volume)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getSoundDuration(sound: URL) -> Double? {
        do {
            let player = try AVAudioPlayer(contentsOf: sound)
            return player.duration
        } catch {
            return nil
        }
    }
    
    func updateAudioPlayerValue(volume: Double?) {
        if let volume = volume {
            self.audioPlayer.volume = Float(volume)
        }
    }
}
