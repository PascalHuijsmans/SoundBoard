//
//  ViewController.swift
//  SoundBoard
//
//  Created by Pascal Huijsmans on 12/02/2017.
//  Copyright © 2017 Pascal Huijsmans. All rights reserved.
//

import Cocoa

class SoundBoardViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    
    @IBOutlet var soundBoardCollectionView: NSCollectionView!
    
    let soundBoardManager = SoundBoardManager.sharedInstance
    var soundBoardKeySectionsValuesData = [Int:[SoundBoardKey]]()
    var soundBoardKeyItems = [SoundBoardKey]()
    var soundBoardKeySections = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSoundBoardCollectionView()
        self.getDataForSoundBoardCollectionView()
    }
    
    private func configureSoundBoardCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 140.0, height: 120.0)
        flowLayout.sectionInset = EdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        self.soundBoardCollectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
    }
    
    private func getDataForSoundBoardCollectionView(){
        self.soundBoardKeyItems = self.soundBoardManager.getSoundBoardKeys().sorted { $0.position < $1.position }
        
        self.soundBoardKeySectionsValuesData = [Int:[SoundBoardKey]]()
        
        for soundBoardKeyItem in self.soundBoardKeyItems {
            let section = soundBoardKeyItem.section
            
            if self.soundBoardKeySectionsValuesData.index(forKey: section) == nil {
                self.soundBoardKeySectionsValuesData[section] = [soundBoardKeyItem]
            } else {
                self.soundBoardKeySectionsValuesData[section]?.append(soundBoardKeyItem)
            }
        }
        self.soundBoardKeySections = Array(self.soundBoardKeySectionsValuesData.keys).sorted(by: <)
        self.soundBoardCollectionView.reloadData()
    }
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return self.soundBoardKeySectionsValuesData.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.soundBoardKeySectionsValuesData[soundBoardKeySections[section]]!.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    
        let item = collectionView.makeItem(withIdentifier: "SoundBoardCollectionViewItem", for: indexPath)
        guard let collectionViewItem = item as? SoundBoardCollectionViewItem else {return item}

        collectionViewItem.soundBoardKey = soundBoardKeySectionsValuesData[soundBoardKeySections[indexPath.section]]![indexPath.item]
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionElementKindSectionHeader, withIdentifier: "SoundBoardSectionHeaderView", for: indexPath) as! SoundBoardSectionHeaderView
        view.soundBoardSectionHeaderTextfield.stringValue = "Keyboard Row \((indexPath as NSIndexPath).section + 1)"
        return view
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: self.soundBoardCollectionView.frame.size.width, height: 20)
    }
}
