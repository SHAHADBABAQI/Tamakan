////
////  ContentView.swift
////  تمكّن
////
////  Created by shahad khaled on 27/05/1447 AH.
////
//
//import SwiftUI
//
//import AVFoundation
//import SwiftUI
//
//
//
//struct ContentView: View {
////    @StateObject var audioVM = AudioRecordingViewModel()
////    @State var isRecording = false
////    @EnvironmentObject var recViewModel : RecViewModel
////
////
////    var body: some View {
////        VStack {
////            Button(isRecording ? "" : "") {
////                if isRecording {
////                    audioVM.stopRecording()
////                } else {
////                    audioVM.startRecording()
////                }
////                isRecording.toggle()
////            }
////            ZStack{
////                Circle()
////                    .blur(radius: 10)
////                    .frame(width: 200 * recViewModel.size, height: 200 * recViewModel.size)
////                    .foregroundStyle(Color.aud1)
////
////                
////                Circle()
////                    .blur(radius: 4)
////                    .frame(width: 150 * recViewModel.size1, height: 150 * recViewModel.size1)
////                    .foregroundStyle(Color.aud2)
////
////                Circle()
////                    .blur(radius: 4)
////                    .frame(width: 100 * recViewModel.size, height: 100 * recViewModel.size)
////                    .foregroundStyle(Color.aud3)
////
////                Circle()
////                    .blur(radius: 5)
////                    .frame(width: 65 * recViewModel.size1, height: 65 * recViewModel.size1)
////                    .foregroundStyle(Color.white)
////                
////                
////                Circle()
////                    .blur(radius: 5)
////                    .frame(width: 50 * recViewModel.size, height: 50 * recViewModel.size)
////                    .foregroundStyle(Color.black)
////                
////                Circle()
////                    .frame(width: 50 , height: 50 )
////                    .foregroundStyle(Color.black)
////                
////                Button {
////                        if isRecording {
////                            audioVM.stopRecording()
////                            recViewModel.stopSizeLoop()
////                            
////                        } else {
////                            audioVM.startRecording()
////                            recViewModel.startSizeLoop()
////                        }
////                        isRecording.toggle()
////                    } label: {
////                        Image(isRecording ? "Mic4" : "Mic")   // changes image while recording
////                            .frame(width: 60, height: 60)
////                            .padding()
////                    }
////                
////            }
////            
////
////            Button("تت") {
////                           audioVM.playRecording()
////                       }
////        }
////        .padding()
////    }
//}//struct
//
//#Preview {
//    ContentView()
//}
//
//
