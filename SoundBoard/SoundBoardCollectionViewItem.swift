//
//  SoundBoardCollectionViewItem.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardCollectionViewItem : NSCollectionViewItem {

    @IBOutlet var soundBoardCollectionViewItemControllerView: SoundBoardCollectionViewItemControllerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.borderWidth = 1.0
        view.layer?.borderColor = NSColor(red: 80.0/255.0, green: 80.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        view.layer?.cornerRadius = 2.5
        view.layer?.masksToBounds = true
        
        let background = self.getBackGroundColor()
        background.frame = view.bounds
        view.layer?.insertSublayer(background, at: 0)
    }
    
    func getBackGroundColor() -> CAGradientLayer {
        let topColor = NSColor(red: 140.0/255.0, green: 140.0/255.0, blue: 140.0/255.0, alpha: 1.0)
        let bottomColor = NSColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        
        let gradientColors: Array <AnyObject> = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    
    var soundBoardKey: SoundBoardKey? {
        didSet {
            guard isViewLoaded else { return }
            if let soundBoardKey = soundBoardKey {
                soundBoardCollectionViewItemControllerView.soundBoardKey = soundBoardKey
            }
        }
    }
}
