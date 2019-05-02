//
//  SongCell.swift
//  MusicApp
//
//  Created by Hoang Anh Tuan on 4/12/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

class SongCell: UICollectionViewCell {
    
    var song: Song? {
        didSet {
            guard let songImageName = song?.image else { return }
            DispatchQueue.main.async {
                self.songName.text = self.song?.nameSong
                self.songImage.image = UIImage(named: songImageName)
            }
        }
    }
    
    let songImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let songName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .black
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(songImage)
        addSubview(songName)
        
        let separatelineView = UIView()
        separatelineView.backgroundColor = .black
        addSubview(separatelineView)
        
        songImage.anchor(top: nil, paddingtop: 0, left: leftAnchor, paddingleft: 12, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 64, width: 64)
        songImage.layer.cornerRadius = 32
        songImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        songName.anchor(top: songImage.topAnchor, paddingtop: 0, left: songImage.rightAnchor, paddingleft: 8, right: rightAnchor, paddingright: 0, bot: songImage.bottomAnchor, botpadding: 0, height: 0, width: 0)
        separatelineView.anchor(top: songName.bottomAnchor, paddingtop: 0, left: songName.leftAnchor, paddingleft: 0, right: songName.rightAnchor, paddingright: 0, bot: nil, botpadding: 0, height: 0.5, width: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

