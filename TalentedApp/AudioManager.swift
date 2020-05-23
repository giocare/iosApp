//
//  AudioManager.swift
//  TalentedApp
//
//  Created by jess on 5/15/20.
//  Copyright © 2020 giotech. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {

    static let sharedInstance = AudioManager()
    var audioPlayer = AVAudioPlayer()

    func playAudio(fileName: String, fileType: String){

        let sound = Bundle.main.path(forResource: fileName, ofType: fileType)
               do
               {
                   audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    audioPlayer.play()
               }
               catch {
                   print(error)
               }
       }
     

}
