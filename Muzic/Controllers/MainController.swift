//
//  MainController.swift
//  MusicApp
//
//  Created by Hoang Anh Tuan on 4/7/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var allSongs = [Song]()
    var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SongCell.self, forCellWithReuseIdentifier: cellID)
        
        gettingSongname()
    }
    
    func gettingSongname() {
        guard let resourcesPath = Bundle.main.resourcePath else { return }
        let folderUrl = URL(fileURLWithPath: resourcesPath)
        do{
            let songPath = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath {
                var mySong = song.absoluteString
                if mySong.contains(".mp3") {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count - 1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    let newSong = Song(nameSong: mySong, image: mySong)
                    allSongs.append(newSong)
                }
            }
            collectionView.reloadData()
        } catch {
        
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSongs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SongCell
        cell.song = allSongs[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let songController = SongController()
        songController.allSongs = self.allSongs
        songController.index = indexPath.item
        self.present(songController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
