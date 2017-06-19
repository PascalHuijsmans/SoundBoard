//
//  SoundBoardWindowController.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 16/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func showWindow(_ sender: Any?) {
        if var window = self.window {
            window = self.configureSoundBoardWindow(window: window)
        }
        super.showWindow(nil)
    }
    
    func configureSoundBoardWindow(window: NSWindow) -> NSWindow {
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0)
        window.setContentSize(NSSize(width: 1200.0, height: 602.0))
        window.titleVisibility = .hidden
        window.styleMask.remove(NSWindowStyleMask.fullSizeContentView)
        window.styleMask.remove(NSWindowStyleMask.resizable)
        window.toolbar?.isVisible = true
        
        if let titlebarController = self.storyboard?.instantiateController(withIdentifier: "titlebarViewController") as? NSTitlebarAccessoryViewController {
            titlebarController.layoutAttribute = .left
            window.addTitlebarAccessoryViewController(titlebarController)
        }
        return window
    }
}
