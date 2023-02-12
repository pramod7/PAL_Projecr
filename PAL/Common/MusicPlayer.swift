//
//  MusicPlayer.swift
//  PAL
//
//  Created by Akshay Shah on 21/06/22.
//

import Foundation
import AVFoundation

class MusicPlayer {
    public static var instance = MusicPlayer()
    var player = AVPlayer()
    
    func initPlayer(url: URL) {
//        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        player = AVPlayer(playerItem: playerItem)
        player.volume = 1
        player.play()
        playAudioBackground()
    }
    
    func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")           
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
            NotificationCenter.default.post(name: Notification.Name("NotificationPlay"), object: nil)
        } catch {
            print(error)
        }
    }
    
    func pause(){
        player.pause()
    }
    
    func play() {
        player.play()
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        NotificationCenter.default.post(name: Notification.Name("NotificationOver"), object: nil)
        appdelegate.btnSelectedVoice = false
        appdelegate.selectedIndex = 99999
    }
}


