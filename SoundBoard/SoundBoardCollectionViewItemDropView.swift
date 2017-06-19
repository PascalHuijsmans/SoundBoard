//
//  SoundBoardCollectionViewItemDropView.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 18/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardCollectionViewItemDropView: NSView {
    var delegate : SoundBoardCollectionViewItemDropViewDelegate?
    let expectedExt = ["mp3", "aiff"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
        self.setDropLabelHidden(hidden: true)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.layer?.backgroundColor = NSColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.85).cgColor
            self.setDropLabelHidden(hidden: false)
            return .copy
        } else {
            return NSDragOperation()
        }
    }
    
    fileprivate func checkExtension(_ drag: NSDraggingInfo) -> Bool {
        guard let board = drag.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = board[0] as? String
            else { return false }
        
        let suffix = URL(fileURLWithPath: path).pathExtension
        for ext in self.expectedExt {
            if ext.lowercased() == suffix {
                return true
            }
        }
        return false
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.setDropLabelHidden(hidden: true)
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.clear.cgColor
        self.setDropLabelHidden(hidden: true)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            var path = pasteboard[0] as? String
            else { return false }
        
            path = "file://" + path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if let url = URL(string: path) {
                delegate?.filePathRecievedFromDropView(soundFileURL: url)
            }
        return true
    }
    
    func setDropLabelHidden(hidden: Bool) {
        if let subview = self.subviews.first {
            subview.isHidden = hidden
        }
    }
}

protocol SoundBoardCollectionViewItemDropViewDelegate {
    func filePathRecievedFromDropView (soundFileURL: URL)
}
