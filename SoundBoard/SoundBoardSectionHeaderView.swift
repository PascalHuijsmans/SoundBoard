//
//  SoundBoardSectionHeaderView.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 14/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardSectionHeaderView: NSView {

    @IBOutlet var soundBoardSectionHeaderTextfield: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let background = self.getBackGroundColor()
        background.frame = self.bounds
        self.layer?.insertSublayer(background, at: 0)
        
        soundBoardSectionHeaderTextfield.textColor = NSColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        NSColor(calibratedWhite: 0.8 , alpha: 0.2).set()
        NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
    }
    
    func getBackGroundColor() -> CAGradientLayer {
        let topColor = NSColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        let bottomColor = NSColor(red: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        
        let gradientColors: Array <AnyObject> = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}
