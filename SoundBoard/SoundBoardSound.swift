//
//  SoundBoardSound.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 18/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Foundation

class SoundBoardSound {
    let name : String
    let filename : String
    let filetype : String
    let duration : Double
    var volume : Double
    
    init (name: String, filename: String, filetype: String, duration: Double, volume: Double){
        self.name = name
        self.filename = filename
        self.filetype = filetype
        self.duration = duration
        self.volume = volume
    }
}
