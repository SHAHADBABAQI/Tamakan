//
//  RecordingModel.swift
//  تمكّن
//
//  Created by nouransalah on 08/06/1447 AH.
//
import SwiftUI
import SwiftData
//need init
@Model
class RecordingModel: Identifiable {
    //var id:UUID
    @Attribute(.unique) var id: UUID
    var recordname: String
    var duration: Double
    var date: Date
    var transcript: String
    var audiofile: URL
    var countStuttringWords: Int
    //i have to intilise all data i can not init some of data
    init(recordname: String, duration: Double, date: Date, transcript: String, audiofile: URL ,countStuttringWords :Int ) {
        self.id = UUID()
        self.recordname = recordname
        self.duration = duration
        self.date = date
        self.transcript = transcript
        self.audiofile = audiofile
        self.countStuttringWords = countStuttringWords
    }
    
    
}//class

struct StutterComment: Identifiable, Hashable {
    let id = UUID()
    let type: String        // e.g., "مد", "blocking", "repetition"
    let word: String        // the word that was stuttered or blocked
    let strategy: String    // optional strategy or note
}
