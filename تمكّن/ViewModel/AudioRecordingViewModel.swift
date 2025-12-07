//
//  AudioRecordingViewModel.swift
//  voiceTamakan
//
//  Updated by ChatGPT
//

import AVFoundation
import Combine
import WhisperKit
import SwiftData
import SwiftUI

class AudioRecordingViewModel: ObservableObject {

    // MARK: - Published UI variables
    @Published var finalText: String = ""
    @Published var displayedText: String = ""
    private var allChunks: [String] = []

    private let maxWordsPerLine = 5
    private let linesPerScreen = 2

    // Cancel / Save UI
    @Published var showCancelAlert: Bool = false
    @Published var isRecording: Bool = false

    // temporary recording URL while recording (NOT yet saved to Documents/CoreData)
    private(set) var tempRecordingURL: URL?

    // MARK: - Audio
    private let audioEngine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    private var player: AVAudioPlayer?
    private var lastRecordingURL: URL?    // final saved url (set when saved/moved)

    private var bufferQueue: [AVAudioPCMBuffer] = []

    // Whisper
    private var whisper: WhisperKit?

    var context: ModelContext?

    init() {
        Task {
            do {
                whisper = try await WhisperKit(WhisperKitConfig(model: "medium"))
                print("✅ Whisper model loaded")
            } catch {
                print("❌ Whisper init error:", error.localizedDescription)
            }
        }
    }

    // MARK: - Start Recording
    func startRecording() {
        // mark state
        isRecording = true

        // create a unique temp file in tmp directory
        let fileName = "temp_recording_\(UUID().uuidString).caf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        tempRecordingURL = tempURL
        lastRecordingURL = nil  // not yet a final saved file

        // audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("❌ Session error:", error)
        }

        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)

        // create audioFile that writes to tempRecordingURL
        do {
            audioFile = try AVAudioFile(forWriting: tempURL, settings: format.settings)
            print("📁 Temp file created:", tempURL.path)
        } catch {
            print("❌ File creation error:", error)
            audioFile = nil
        }

        bufferQueue.removeAll()
        inputNode.removeTap(onBus: 0)

        // install tap and write to temp audioFile
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self = self else { return }

            // write to the temporary audio file
            do {
                try self.audioFile?.write(from: buffer)
            } catch {
                print("❌ Write error:", error)
            }

            self.bufferQueue.append(buffer)

            // Every ~2–3 seconds → process chunk for transcription (uses temp chunk file)
            let requiredFrames = AVAudioFrameCount(format.sampleRate * 2.5)
            let totalFrames = self.bufferQueue.reduce(0) { $0 + $1.frameLength }

            if totalFrames >= requiredFrames {
                let chunk = self.mergeBuffers(self.bufferQueue, format: format)
                self.bufferQueue.removeAll()

                let tempChunkURL = self.saveBufferToFile(chunk)
                self.transcribeChunk(at: tempChunkURL)
            }
        }

        do {
            try audioEngine.start()
            print("▶️ Engine started (recording to temp)")
        } catch {
            print("❌ Engine start error:", error)
        }
    }

    // MARK: - Stop Recording
    func stopRecording() {
        isRecording = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        audioFile = nil
        print("⏹️ Engine stopped (temp file kept until save/discard)")
    }

    // MARK: - SAVE Recording (move temp -> Documents + addRecord)
    func saveRecording() {
        stopRecording()

        guard let tempURL = tempRecordingURL else {
            print("⚠️ No temp recording to save")
            return
        }

        // build final filename and destination
        let timestamp = Date().timeIntervalSince1970
        let finalFileName = "recording_\(timestamp).caf"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let finalURL = documentsURL.appendingPathComponent(finalFileName)

        do {
            // move temp -> final
            if FileManager.default.fileExists(atPath: finalURL.path) {
                try FileManager.default.removeItem(at: finalURL)
            }
            try FileManager.default.moveItem(at: tempURL, to: finalURL)
            print("✅ Recording moved to:", finalURL.path)

            // save Core Data record (use current finalText). duration is left as 0.0 unless you compute it.
            addRecord(RcordName: finalFileName, duration: 0.0, date: Date(), finalText: finalText, url: finalURL)

            // update lastRecordingURL and clear temp
            lastRecordingURL = finalURL
            tempRecordingURL = nil

        } catch {
            print("❌ Error saving recording:", error.localizedDescription)
        }
    }

    // MARK: - DISCARD Recording (delete temp and clear state)
    func discardRecording() {
        stopRecording()

        // delete temp file if exists
        if let tempURL = tempRecordingURL {
            try? FileManager.default.removeItem(at: tempURL)
            tempRecordingURL = nil
            print("🗑️ Temp recording deleted")
        }

        // clear transcription state
        finalText = ""
        displayedText = ""
        allChunks.removeAll()
        bufferQueue.removeAll()
    }

    // MARK: - Update displayed 2-line window
    private func updateDisplayedText() {
        let words = allChunks.joined(separator: " ").split(separator: " ")

        let lines = stride(from: 0, to: words.count, by: maxWordsPerLine)
            .map { Array(words[$0..<min($0 + maxWordsPerLine, words.count)]) }
            .map { $0.joined(separator: " ") }

        let lastLines = lines.suffix(linesPerScreen)
        displayedText = lastLines.joined(separator: "\n")
    }

    // MARK: - Transcription
    private func transcribeChunk(at url: URL) {
        Task { [weak self] in
            guard let self = self, let whisper = self.whisper else { return }

            do {
                let results = try await whisper.transcribe(audioPath: url.path)
                let text = results.first?.text ?? ""

                DispatchQueue.main.async {
                    if !text.isEmpty {
                        self.allChunks.append(text)
                        self.finalText += text + " "
                        self.updateDisplayedText()
                    } else {
                        print("⚠️ Empty transcription")
                    }
                }
            } catch {
                print("❌ Transcription error:", error.localizedDescription)
            }
        }
    }

    // MARK: - Merge buffers
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

    // Save small temp chunk to a temp file for transcription
    private func saveBufferToFile(_ buffer: AVAudioPCMBuffer) -> URL {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("chunk.caf")
        do {
            let file = try AVAudioFile(forWriting: url, settings: buffer.format.settings)
            try file.write(from: buffer)
        } catch {
            print("❌ Error saving chunk:", error)
        }
        return url
    }

    // MARK: - CoreData (SwiftData) insert
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

    // optional: play last saved recording
    func playLastRecording() {
        guard let url = lastRecordingURL else {
            print("⚠️ No saved recording found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❌ Playback error:", error)
        }
    }
}
