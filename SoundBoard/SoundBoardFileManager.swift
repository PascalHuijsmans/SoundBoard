//
//  SoundBoardFileManager.swift
//  Soundboard
//
//  Created by Pascal Huijsmans on 10/02/2017.
//  Copyright © 2017 pascal huijsmans. All rights reserved.
//

import Foundation

class SoundBoardFileManager {
    
    let fileManager : FileManager
    let documentDirectory : URL
    let appDirectory : URL
    let soundsDirectory : URL
    let soundboardKeysListFile : URL
    let availableKeysPropertyListFile : URL
    let soundboardPropertyListFile : URL
    
    init() {
        self.fileManager = FileManager.default
        self.availableKeysPropertyListFile = Bundle.main.url(forResource: "AvailableKeys", withExtension: "plist")!
        self.soundboardKeysListFile = Bundle.main.url(forResource: "SoundBoardKeys", withExtension: "plist")!
        self.documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.deletingLastPathComponent()
        self.appDirectory = documentDirectory.appendingPathComponent(".sounboard")
        self.soundsDirectory = appDirectory.appendingPathComponent("sounds")
        self.soundboardPropertyListFile = appDirectory.appendingPathComponent("SounBoardKeys.plist")
    }
    
    func checkSoundboardFoldersAndFiles() -> Bool {
        var appDirectory = true
        if (!self.fileDirectoryExists(url: self.appDirectory)) {
            appDirectory = self.createDirectory(url: self.appDirectory)
        }
        
        var soundsDirectory = true
        if (!self.fileDirectoryExists(url: self.soundsDirectory)) {
            soundsDirectory = self.createDirectory(url: self.soundsDirectory)
        }
        
        var soundboardPropertyListFile = true
        if (!self.fileDirectoryExists(url: self.soundboardPropertyListFile)) {
            if let dataAvailableKeysPropertyListFile = self.readFile(url: self.soundboardKeysListFile){
                soundboardPropertyListFile = self.createFile(url: self.soundboardPropertyListFile, data: dataAvailableKeysPropertyListFile)
            } else {
                soundboardPropertyListFile = false
            }
        }
        
        return appDirectory && soundsDirectory && soundboardPropertyListFile
    }
    
    func fileDirectoryExists(url: URL) -> Bool {
        var isDirectory : ObjCBool = false
        if self.fileManager.fileExists(atPath: url.path, isDirectory:&isDirectory) {
            return true
        }
        return false;
    }
    
    func createDirectory(url: URL) -> Bool {
        do {
            try self.fileManager.createDirectory(atPath: url.path, withIntermediateDirectories: false, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    func createFile(url: URL, data: Data?) -> Bool {
        return self.fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func copyFile(at: URL, to: URL) -> Bool {
        do {
            try fileManager.copyItem(at: at, to: to)
            return true
        }
        catch {
            return false
        }
    }
    
    func readFile(url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
    
    func removeFile(url: URL) -> Bool {
        do {
            try fileManager.removeItem(at: url)
            return true
        }
        catch {
            return false
        }
    }
}
