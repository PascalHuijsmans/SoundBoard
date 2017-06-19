//
//  SoundBoardKey.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardKey {
    let keyCode : String
    let keyLabel : String
    let position : Int
    let section : Int
    var sound : SoundBoardSound?
    
    init (keyCode: String, keyLabel: String, position: Int, section: Int){
        self.keyCode = keyCode
        self.keyLabel = keyLabel
        self.position = position
        self.section = section
    }
    
    init (keyCode: String, keyLabel: String, position: Int, section: Int, sound: SoundBoardSound){
        self.keyCode = keyCode
        self.keyLabel = keyLabel
        self.position = position
        self.section = section
        self.sound = sound
    }
}
