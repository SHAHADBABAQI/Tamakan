//
//  Untitled.swift
//  voiceTamakan
//
//  Created by nouransalah on 27/05/1447 AH.
//

import AVFoundation
import Combine
class AudioRecordingViewModel: ObservableObject {
   
    
    let audioEngine = AVAudioEngine()
    var audioFile: AVAudioFile?
    var player: AVAudioPlayer?


    func startRecording() {
        //premtion
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Session error: \(error)")
        }
        
        //input from microfone
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        
        // Create file to save audio
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording.caf")

        do {
            audioFile = try AVAudioFile(forWriting: url, settings: format.settings)
        } catch {
            print("File error: \(error)")
        }
        
        
        
        
        //preper tap on pipline
        inputNode.removeTap(onBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
            print("Captured audio: \(buffer.frameLength)")
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("Write error: \(error)")
            }
        }
        //start engine
        do {
            try audioEngine.start()
            print("Engine started")
        } catch {
            print("Engine start error: \(error)")
        }
    }//start

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("Engine stopped")
    }//stop
    
    
    

    func playRecording() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("recording.caf")

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Playback error: \(error)")
        }
    }
}//class
