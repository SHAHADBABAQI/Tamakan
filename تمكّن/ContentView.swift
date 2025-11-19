//
//  ContentView.swift
//  تمكّن
//
//  Created by shahad khaled on 27/05/1447 AH.
//

import SwiftUI

import AVFoundation
import SwiftUI



struct ContentView: View {
    @StateObject var audioVM = AudioRecordingViewModel()
    @State var isRecording = false

    var body: some View {
        VStack {
            Button(isRecording ? "Stop" : "Start") {
                if isRecording {
                    audioVM.stopRecording()
                } else {
                    audioVM.startRecording()
                }
                isRecording.toggle()
            }

            Button("Play Recording") {
                           audioVM.playRecording()
                       }
        }
        .padding()
    }
}//struct

#Preview {
    ContentView()
}


