//
//  SongController.swift
//  MusicApp
//
//  Created by Hoang Anh Tuan on 4/12/19.
//  Copyright © 2019 Hoang Anh Tuan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class SongController: UIViewController, AVAudioPlayerDelegate {
    
    var timerSongSlider: Timer!
    var timerRotate: Timer!
    var goc: Int = 0
    
    
    var player: AVAudioPlayer = AVAudioPlayer()
    var index = Int()
    var allSongs = [Song]()
    var isPlaying = true
    var isRepeat = false
    var isShuffle = false
    
    let currentTimeSongSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.value = 0
        slider.becomeFirstResponder()
        slider.addTarget(self, action: #selector(handleChangeTimeSong), for: .valueChanged)
        slider.addTarget(self, action: #selector(handlePlayNewTimeSong), for: .touchUpInside)
        return slider
    }()
    
    @objc func handleChangeTimeSong () {
        if isPlaying == true {
            timerSongSlider.invalidate()
            DispatchQueue.main.async {
                self.currentTimeSongLabel.text = self.currentTimeSongSlider.value.stringFromFloat()
            }
        }
        else {
            DispatchQueue.main.async {
                self.currentTimeSongLabel.text = self.currentTimeSongSlider.value.stringFromFloat()
            }
        }
    }
    
    @objc func handlePlayNewTimeSong() {
        
        let value = self.currentTimeSongSlider.value
        self.player.currentTime = TimeInterval(value)
        if isPlaying == true {
            setupSliderValue()

        }
    }
    
    let currentTimeSongLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "00:00"
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }()
    
    let durationTimeSongLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 10)
        return lb
    }()
    
    
    let viewBackground: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let songName: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.textColor = .white
        return lb
    }()
    
    let goBackButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "down"), for: .normal)
        bt.tintColor = .white
        bt.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleGoBack() {
        self.dismiss(animated: true, completion: nil)
        stopTimer()
    }
    
    func stopTimer() {
        timerRotate.invalidate()
        timerRotate = nil
        timerSongSlider.invalidate()
        timerSongSlider = nil
    }
    
    let songImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let playButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        bt.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()

    let nextButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        bt.setImage(UIImage(named: "next")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()

    let previousButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        bt.setImage(UIImage(named: "previous")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()

    let repeatButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "repeat"), for: .normal)
        bt.tintColor = .lightGray
        bt.addTarget(self, action: #selector(handleRepeatSong), for: .touchUpInside)
        return bt
    }()
    
    let shuffleButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "shuffle"), for: .normal)
        bt.tintColor = .lightGray
        bt.addTarget(self, action: #selector(handleShuffleSong), for: .touchUpInside)
        return bt
    }()
    
    @objc func handlePlay() {
        if isPlaying == true {
            player.pause()
            self.playButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            isPlaying = false
        }
        else {
            player.play()
            self.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            isPlaying = true
        }
        rotateImageSong()
        setupSliderValue()
    }

    @objc func handleNext() {
        goc = 0
        if isPlaying == false {
            isPlaying = true
            self.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            stopTimer()
        }
        DispatchQueue.main.async {
            self.currentTimeSongSlider.value = 0
            self.currentTimeSongLabel.text = "00:00"
        }
        
        playNextSong()
        
    }
    
    func playNextSong() {
        if isShuffle == false {
            if index < allSongs.count - 1 {
                index = index + 1
                self.updateView()
                playSongAtIndex(index: index)
            }
            else {
                index = 0
                self.updateView()
                playSongAtIndex(index: index)
            }
        }
        else {
            index = Int.random(in: 0..<allSongs.count)
            self.updateView()
            playSongAtIndex(index: index)
        }
    }
    
    @objc func handlePrevious() {
        goc = 0
        if isPlaying == false {
            isPlaying = true
            self.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else {
            stopTimer()
        }
        DispatchQueue.main.async {
            self.currentTimeSongSlider.value = 0
            self.currentTimeSongLabel.text = "00:00"
        }
        
        playPreviousSong()
    }
    
    func playPreviousSong() {
        if index > 0 {
            index = index - 1
            self.updateView()
            playSongAtIndex(index: index)
        }
        else {
            index = allSongs.count - 1
            self.updateView()
            playSongAtIndex(index: index)
        }
    }
    
    @objc func handleRepeatSong() {
        if isRepeat == false {
            isRepeat = true
            repeatButton.setImage(UIImage(named: "repeat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else{
            isRepeat = false
            repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
            repeatButton.tintColor = .white
        }
    }
    
    @objc func handleShuffleSong() {
        if isShuffle == false {
            isShuffle = true
            shuffleButton.setImage(UIImage(named: "shuffle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else{
            isShuffle = false
            shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
            shuffleButton.tintColor = .white
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupPlayButton()
        
        updateView()
        playSongAtIndex(index: self.index)
        
    }
    
    
    fileprivate func setupButtons() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        view.addSubview(viewBackground)
        view.addSubview(blurEffectView)
        view.addSubview(songName)
        view.addSubview(goBackButton)
        view.addSubview(songImage)
        
        
        viewBackground.anchor(top: view.topAnchor, paddingtop: 0, left: view.leftAnchor, paddingleft: 0, right: view.rightAnchor, paddingright: 0, bot: view.bottomAnchor, botpadding: 0, height: 0, width: 0)
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor , paddingtop: 10, left: view.leftAnchor, paddingleft: 4, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 30, width: 30)
        let widthSongName = view.frame.width - 108
        songName.anchor(top: goBackButton.topAnchor, paddingtop: 0, left: nil, paddingleft: 0, right: nil, paddingright: 0, bot: goBackButton.bottomAnchor, botpadding: 0, height: 0, width: widthSongName)
        songName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let width = view.frame.width - 32
        songImage.anchor(top: songName.bottomAnchor, paddingtop: 50, left: nil, paddingleft: 0, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: width, width: width)
        songImage.layer.cornerRadius = width/2
        songImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func setupPlayButton() {
        let stackview = UIStackView(arrangedSubviews: [previousButton, playButton, nextButton])
        stackview.distribution = .fillEqually
        view.addSubview(stackview)
        stackview.anchor(top: nil, paddingtop: 0, left: nil, paddingleft: 0, right: nil, paddingright: 0, bot: view.safeAreaLayoutGuide.bottomAnchor, botpadding: -10, height: 60, width: 300)
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(repeatButton)
        view.addSubview(shuffleButton)
        view.addSubview(currentTimeSongSlider)
        view.addSubview(durationTimeSongLabel)
        view.addSubview(currentTimeSongLabel)
        durationTimeSongLabel.anchor(top: nil, paddingtop: 0, left: nil, paddingleft: 0, right: view.rightAnchor, paddingright: -8, bot:  playButton.topAnchor, botpadding: -20, height: 10, width: 30)
        currentTimeSongLabel.anchor(top: nil, paddingtop: 0, left: view.leftAnchor, paddingleft: 8, right: nil, paddingright: 0, bot: durationTimeSongLabel.bottomAnchor, botpadding: 0, height: 10, width: 30)
        currentTimeSongSlider.anchor(top: nil, paddingtop: 0, left: currentTimeSongLabel.rightAnchor, paddingleft: 10, right: durationTimeSongLabel.leftAnchor, paddingright: -10, bot: playButton.topAnchor, botpadding: -20, height: 10, width: 0)
        
        repeatButton.anchor(top: nil, paddingtop: 0, left: nil, paddingleft: 0, right: view.rightAnchor, paddingright: -20, bot: nil, botpadding: 0, height: 25, width: 25)
        repeatButton.centerYAnchor.constraint(equalTo: stackview.centerYAnchor).isActive = true

        shuffleButton.anchor(top: nil, paddingtop: 0, left: view.leftAnchor, paddingleft: 20, right: nil, paddingright: 0, bot: nil, botpadding: 0, height: 25, width: 25)
        shuffleButton.centerYAnchor.constraint(equalTo: stackview.centerYAnchor).isActive = true
    }
    
    fileprivate func updateView() {
        DispatchQueue.main.async {
            self.songName.text = self.allSongs[self.index].nameSong
            self.viewBackground.image = UIImage(named: self.allSongs[self.index].image)
            self.songImage.image = UIImage(named: self.allSongs[self.index].image)
        }
    }
    
    fileprivate func playSongAtIndex(index: Int) {
        guard let urlString = Bundle.main.path(forResource: allSongs[index].nameSong, ofType: ".mp3") else { return }
        let url = URL(fileURLWithPath: urlString)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
            player.delegate = self
            let image = UIImage(named: allSongs[index].nameSong)
            let artwork = MPMediaItemArtwork.init(boundsSize: image!.size, requestHandler: { (size) -> UIImage in
                return image!
            })
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                MPMediaItemPropertyTitle : allSongs[index].nameSong,
                MPMediaItemPropertyArtwork: artwork,
                MPMediaItemPropertyPlaybackDuration : player.duration
            ]
            UIApplication.shared.beginReceivingRemoteControlEvents()
            becomeFirstResponder()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            } catch let err {
                print("cant play background: \(err)")
            }
        } catch let err {
            print("Cant play music: \(err)")
        }
        
        DispatchQueue.main.async {
            self.durationTimeSongLabel.text = self.player.duration.stringFromTimeInterval()
        }
        
        self.currentTimeSongSlider.maximumValue = Float(player.duration)
        rotateImageSong()
        setupSliderValue()
    }
    
    func rotateImageSong () {
        if isPlaying == true {
            timerRotate = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: { (timer) in
                self.goc += 1
                self.songImage.transform = CGAffineTransform(rotationAngle: (CGFloat(self.goc) * CGFloat(M_PI)) / 180)
            })
        }
        else {
            timerRotate.invalidate()
            timerRotate = nil
        }
    }
    
    func setupSliderValue() {
        if isPlaying == true {
            timerSongSlider = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.currentTimeSongSlider.value = Float(self.player.currentTime)
                self.currentTimeSongLabel.text = self.currentTimeSongSlider.value.stringFromFloat()
            })
        }
        else {
            timerSongSlider.invalidate()
            timerSongSlider = nil
        }
    }
    
    func finishASong() {
        goc = 0
        stopTimer()
        
        DispatchQueue.main.async {
            self.currentTimeSongSlider.value = 0
            self.currentTimeSongLabel.text = "00:00"
        }
        
        if isRepeat == false {
            playNextSong()
        }
            
        else {
            playSongAtIndex(index: index)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishASong()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if let event = event {
            if event.type == .remoteControl {
                switch event.subtype {
                    case .remoteControlPlay:
                        handlePlay()
                    case .remoteControlPause:
                        handlePlay()
                    case .remoteControlNextTrack:
                        handleNext()
                    case .remoteControlPreviousTrack:
                        handlePrevious()
                    default:
                        print("chua xac dinh")
                }
            }
        }
    }
}
