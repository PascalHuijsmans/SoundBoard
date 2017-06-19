//
//  SoundBoardCollectionViewItemDropViewBordedView.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 20/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardCollectionViewItemDropViewBordedView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let dashHeight: CGFloat = 1
        let dashLength: CGFloat = 3
        let dashColor: NSColor = NSColor(red: 108.0/255.0, green: 108.0/255.0, blue: 108.0/255.0, alpha: 1.0)

        let currentContext = NSGraphicsContext.current()!.cgContext
        currentContext.setLineWidth(dashHeight)
        currentContext.setLineDash(phase: 0, lengths: [dashLength])
        currentContext.setStrokeColor(dashColor.cgColor)

        currentContext.addRect(bounds.insetBy(dx: dashHeight, dy: dashHeight))
        currentContext.strokePath()
    }
}
