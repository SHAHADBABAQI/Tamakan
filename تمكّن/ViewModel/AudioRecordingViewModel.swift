//
//  AudioRecordingViewModel.swift
//  voiceTamakan
//
//  Created by Nouran Salah
//

import AVFoundation
import Combine
import WhisperKit
import SwiftData
import SwiftUI

class AudioRecordingViewModel: ObservableObject {

    // MARK: - Published UI variables
    @Published var finalText: String = ""
<<<<<<< HEAD
    @Published var displayedText: String = ""      // shows 2 lines only
    private var allChunks: [String] = []           // stores every chunk
    private let maxWordsPerLine = 5                // you wanted max 5 words per line
    private let linesPerScreen = 2                 // show only 2 lines
    @Published var currentChunk: String = ""           // chunk الحالي المعروض
    @Published private var textChunks: [String] = []   // جميع الـ chunks
    private var chunkTimer: Timer?
=======

>>>>>>> main
    // MARK: - Audio
    private let audioEngine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    private var player: AVAudioPlayer?
    private var lastRecordingURL: URL?

    private var bufferQueue: [AVAudioPCMBuffer] = []

    // MARK: - Whisper model (single instance)
    private var whisper: WhisperKit?

    
    
   // @Environment(\.presentationMode) var presentationMode
   // @Environment(\.modelContext) private var context
    var context: ModelContext?
    // MARK: - Init (load model only once)
    init() {
        Task {
            do {
                print("⏳ Loading Whisper model...")
                //whisper = try await WhisperKit(WhisperKitConfig(model: "large"))
                whisper = try await WhisperKit(WhisperKitConfig(model: "medium"))
                print("✅ Whisper model loaded successfully")
            } catch {
                print("❌ Whisper init error:", error.localizedDescription)
            }
        }
    }


    // MARK: - Start Recording
    func startRecording() {

        // Request microphone and start session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            print("🎙️ Session READY")
        } catch {
            print("❌ Session error:", error)
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        let timestamp = Date().timeIntervalSince1970
        let fileName = "recording_\(timestamp).caf"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        lastRecordingURL = url
        //i created func that create object object
        //save object in context
        addRecord(RcordName :fileName, duration: 0.0 ,date: Date(), finalText: finalText ,url: url)
        

        do {
            audioFile = try AVAudioFile(forWriting: url, settings: format.settings)
            print("📁 File created: \(fileName)")
        } catch {
            print("❌ File creation error:", error)
        }

        bufferQueue.removeAll()
        inputNode.removeTap(onBus: 0)

        // Install audio tap
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self = self else { return }

            // Write buffer to main recording file
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("❌ Write error:", error)
            }

            self.bufferQueue.append(buffer)
            print("🎧 Captured audio: \(buffer.frameLength)")

            // Every ~2–3 seconds → process chunk
            let requiredFrames = AVAudioFrameCount(format.sampleRate * 2.5)
            let totalFrames = self.bufferQueue.reduce(0) { $0 + $1.frameLength }

            if totalFrames >= requiredFrames {
                let chunk = self.mergeBuffers(self.bufferQueue, format: format)
                self.bufferQueue.removeAll()

                let tempURL = self.saveBufferToFile(chunk)
                self.transcribeChunk(at: tempURL)
            }
        }

        // Start engine
        do {
            try audioEngine.start()
            print("▶️ Engine started")
        } catch {
            print("❌ Engine start error:", error)
        }
    }


    // MARK: - Stop Recording
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("⏹️ Engine stopped")
    }


    // MARK: - Play last recording
    func playRecording() {
        guard let url = lastRecordingURL else {
            print("⚠️ No recording found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("🔊 Playing recording")
        } catch {
            print("❌ Playback error:", error)
        }
    }
<<<<<<< HEAD
    private func updateDisplayedText() {
        // Combine all chunks into words
        let words = allChunks.joined(separator: " ").split(separator: " ")

        // Split into lines of max 5 words
        let lines = stride(from: 0, to: words.count, by: maxWordsPerLine)
            .map { Array(words[$0..<min($0 + maxWordsPerLine, words.count)]) }
            .map { $0.joined(separator: " ") }

        // Show last 2 lines only
        let lastLines = lines.suffix(linesPerScreen)

        displayedText = lastLines.joined(separator: "\n")
    }
=======

>>>>>>> main

    func updateChunks() {
            textChunks = finalText
                .components(separatedBy: .whitespacesAndNewlines)
                .chunked(into: 5)                         // كل 5 كلمات = سطر واحد
                .map { $0.joined(separator: " ") }
                .chunked(into: 2)                         // كل سطرين = chunk
                .map { $0.joined(separator: "\n") }

            if !textChunks.isEmpty {
                currentChunk = textChunks[0]
            }
        }
    
    func startAutoAdvance() {
           chunkTimer?.invalidate()
           chunkTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
               guard let self = self else { return }
               self.advanceChunk()
           }
       }
    private func advanceChunk() {
           guard !textChunks.isEmpty else { return }
           if let idx = textChunks.firstIndex(of: currentChunk), idx + 1 < textChunks.count {
               currentChunk = textChunks[idx + 1]
           }
       }


       func stopAutoAdvance() {
           chunkTimer?.invalidate()
           chunkTimer = nil
       }
    // MARK: - Transcription
    private func transcribeChunk(at url: URL) {
        Task { [weak self] in
            guard let self = self, let whisper = self.whisper else {
                print("⚠️ Whisper model not ready")
                return
            }

            do {
                print("⏳ Transcribing chunk...")

                let results = try await whisper.transcribe(audioPath: url.path)
                let text = results.first?.text ?? ""

                DispatchQueue.main.async {
                    if !text.isEmpty {
<<<<<<< HEAD
                        // Store chunk
                        self.allChunks.append(text)

                        // Update finalText (full transcript)
                        self.finalText += text + " "

                        // Update displayed window
                        self.updateDisplayedText()
=======
                        self.finalText += text + " "
                        print("🟢 Transcribed:", text)
                    } else {
                        print("⚠️ Empty transcription")
>>>>>>> main
                    }
                }

            } catch {
                print("❌ Transcription error:", error.localizedDescription)
            }
        }
    }

<<<<<<< HEAD

=======
>>>>>>> main
    // MARK: - Buffer merge
    private func mergeBuffers(_ buffers: [AVAudioPCMBuffer], format: AVAudioFormat) -> AVAudioPCMBuffer {
        let totalFrames = buffers.reduce(0) { $0 + $1.frameLength }
        guard let merged = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: totalFrames) else {
            return buffers[0]
        }

        merged.frameLength = totalFrames

        var offset: AVAudioFrameCount = 0
        for buffer in buffers {
            for ch in 0..<Int(format.channelCount) {
                let src = buffer.floatChannelData![ch]
                let dst = merged.floatChannelData![ch]
                memcpy(dst.advanced(by: Int(offset)),
                       src,
                       Int(buffer.frameLength) * MemoryLayout<Float>.size)
            }
            offset += buffer.frameLength
        }
        return merged
    }


    // MARK: - Save buffer to temp file
    private func saveBufferToFile(_ buffer: AVAudioPCMBuffer) -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("chunk.caf")

        do {
            let file = try AVAudioFile(forWriting: url, settings: buffer.format.settings)
            try file.write(from: buffer)
            print("📦 Chunk saved:", url.path)
        } catch {
            print("❌ Error saving chunk:", error)
        }

        return url
    }
    
    
    // MARK: - func save record in object

//    func addRecord(RcordName :String, duration: Double ,date: Date, finalText: String ,url: URL) {
//        let newRecord = RecordingModel(recordname: RcordName, duration: 0.0, date: date, transcript: finalText, audiofile: url)
//        //add record to arr
//        context.insert(newRecord)
//        print("📦📦📦📦📦📦OBJECT CREATED")
//    }
    
    // MARK: - Save new record
    func addRecord(RcordName: String, duration: Double, date: Date, finalText: String, url: URL) {

        guard let context else {
            print("❌ ERROR: No ModelContext found.")
            return
        }

        let newRecord = RecordingModel(
            recordname: RcordName,
            duration: duration,
            date: date,
            transcript: finalText,
            audiofile: url
        )

        context.insert(newRecord)

        print("📦 Record saved:", RcordName)
    }
}


//import AVFoundation
//import Combine
//import WhisperKit
//import SwiftData
//import SwiftUI
//
//class AudioRecordingViewModel: ObservableObject {
//
//    // MARK: - Published UI variables
//    @Published var finalText: String = ""
//
//    // MARK: - Audio
//    private let audioEngine = AVAudioEngine()
//    private var audioFile: AVAudioFile?
//    private var player: AVAudioPlayer?
//    private var lastRecordingURL: URL?
//
//    private var bufferQueue: [AVAudioPCMBuffer] = []
//
//    // MARK: - Whisper model (single instance)
//    private var whisper: WhisperKit?
//    
//    var context: ModelContext?
//
//    // MARK: - Init (load model only once)
//    init() {
//        Task {
//            do {
//                print("⏳ Loading Whisper model...")
//                //whisper = try await WhisperKit(WhisperKitConfig(model: "large"))
//                whisper = try await WhisperKit(WhisperKitConfig(model: "medium"))
//                print("✅ Whisper model loaded successfully")
//            } catch {
//                print("❌ Whisper init error:", error.localizedDescription)
//            }
//        }
//    }
//
//
//    // MARK: - Start Recording
//    func startRecording() {
//
//        // Request microphone and start session
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setCategory(.playAndRecord, mode: .default)
//            try session.setActive(true)
//            print("🎙️ Session READY")
//        } catch {
//            print("❌ Session error:", error)
//        }
//
//        let inputNode = audioEngine.inputNode
//        let format = inputNode.inputFormat(forBus: 0)
//
//        let timestamp = Date().timeIntervalSince1970
//        let fileName = "recording_\(timestamp).caf"
//        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            .appendingPathComponent(fileName)
//        lastRecordingURL = url
//        //i created func that create object object
//        //save object in context
//        addRecord(RcordName :fileName, duration: 0.0 ,date: Date(), finalText: finalText ,url: url)
//
//        do {
//            audioFile = try AVAudioFile(forWriting: url, settings: format.settings)
//            print("📁 File created: \(fileName)")
//        } catch {
//            print("❌ File creation error:", error)
//        }
//
//        bufferQueue.removeAll()
//        inputNode.removeTap(onBus: 0)
//
//        // Install audio tap
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
//            guard let self = self else { return }
//
//            // Write buffer to main recording file
//            do {
//                try self.audioFile?.write(from: buffer)
//            } catch {
//                print("❌ Write error:", error)
//            }
//
//            self.bufferQueue.append(buffer)
//            print("🎧 Captured audio: \(buffer.frameLength)")
//
//            // Every ~2–3 seconds → process chunk
//            let requiredFrames = AVAudioFrameCount(format.sampleRate * 2.5)
//            let totalFrames = self.bufferQueue.reduce(0) { $0 + $1.frameLength }
//
//            if totalFrames >= requiredFrames {
//                let chunk = self.mergeBuffers(self.bufferQueue, format: format)
//                self.bufferQueue.removeAll()
//
//                let tempURL = self.saveBufferToFile(chunk)
//                self.transcribeChunk(at: tempURL)
//            }
//        }
//
//        // Start engine
//        do {
//            try audioEngine.start()
//            print("▶️ Engine started")
//        } catch {
//            print("❌ Engine start error:", error)
//        }
//    }
//
//
//    // MARK: - Stop Recording
//    func stopRecording() {
//        audioEngine.stop()
//        audioEngine.inputNode.removeTap(onBus: 0)
//        print("⏹️ Engine stopped")
//    }
//
//
//    // MARK: - Play last recording
//    func playRecording() {
//        guard let url = lastRecordingURL else {
//            print("⚠️ No recording found")
//            return
//        }
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//            print("🔊 Playing recording")
//        } catch {
//            print("❌ Playback error:", error)
//        }
//    }
//
//
//    // MARK: - Transcription
//    private func transcribeChunk(at url: URL) {
//        Task { [weak self] in
//            guard let self = self, let whisper = self.whisper else {
//                print("⚠️ Whisper model not ready")
//                return
//            }
//
//            do {
//                print("⏳ Transcribing chunk...")
//
//                let results = try await whisper.transcribe(audioPath: url.path)
//                let text = results.first?.text ?? ""
//
//                DispatchQueue.main.async {
//                    if !text.isEmpty {
//                        self.finalText += text + " "
//                        print("🟢 Transcribed:", text)
//                    } else {
//                        print("⚠️ Empty transcription")
//                    }
//                }
//
//            } catch {
//                print("❌ Transcription error:", error.localizedDescription)
//            }
//        }
//    }
//
//    // MARK: - Buffer merge
//    private func mergeBuffers(_ buffers: [AVAudioPCMBuffer], format: AVAudioFormat) -> AVAudioPCMBuffer {
//        let totalFrames = buffers.reduce(0) { $0 + $1.frameLength }
//        guard let merged = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: totalFrames) else {
//            return buffers[0]
//        }
//
//        merged.frameLength = totalFrames
//
//        var offset: AVAudioFrameCount = 0
//        for buffer in buffers {
//            for ch in 0..<Int(format.channelCount) {
//                let src = buffer.floatChannelData![ch]
//                let dst = merged.floatChannelData![ch]
//                memcpy(dst.advanced(by: Int(offset)),
//                       src,
//                       Int(buffer.frameLength) * MemoryLayout<Float>.size)
//            }
//            offset += buffer.frameLength
//        }
//        return merged
//    }
//
//
//    // MARK: - Save buffer to temp file
//    private func saveBufferToFile(_ buffer: AVAudioPCMBuffer) -> URL {
//        let url = FileManager.default.temporaryDirectory.appendingPathComponent("chunk.caf")
//
//        do {
//            let file = try AVAudioFile(forWriting: url, settings: buffer.format.settings)
//            try file.write(from: buffer)
//            print("📦 Chunk saved:", url.path)
//        } catch {
//            print("❌ Error saving chunk:", error)
//        }
//
//        return url
//    }
//    
//    // MARK: - Save new record
//    func addRecord(RcordName: String, duration: Double, date: Date, finalText: String, url: URL) {
//
//        guard let context else {
//            print("❌ ERROR: No ModelContext found.")
//            return
//        }
//
//        let newRecord = RecordingModel(
//            recordname: RcordName,
//            duration: duration,
//            date: date,
//            transcript: finalText,
//            audiofile: url
//        )
//
//        context.insert(newRecord)
//
//        print("📦 Record saved:", RcordName)
//    }
//}
