//
//  AppDelegate.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let soundBoardManager = SoundBoardManager.sharedInstance

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if (self.soundBoardManager.canAccessAccessibilityPrivileges()) {
            if (!self.soundBoardManager.canMakeSoundboardFoldersAndFiles()) {
                self.soundBoardManager.alert(message: "Files/Folder Check", info: "Could not make/read the desire folder structure in the 'Documents' folder of the user.")
            }
        } else {
            self.soundBoardManager.alert(message: "Accessibility Permission", info: "Soundboard relies upon having permission to 'control your computer' for getting key combinations.")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
