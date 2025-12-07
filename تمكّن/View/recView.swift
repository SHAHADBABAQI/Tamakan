//
//  ContentView.swift
//  تمكّن
//
//  Created by shahad khaled on 27/05/1447 AH.
//

import SwiftUI
import AVFoundation
import Combine

struct recView: View {
    @Environment(\.modelContext) private var context
   
    
    @EnvironmentObject var recViewModel: RecViewModel
    @StateObject var audioVM = AudioRecordingViewModel()
    @State var isRecording = false
<<<<<<< HEAD
   
=======

>>>>>>> main
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack(spacing: 50){
                    Spacer()
                    // Top image positioned to the top-right and partly out of frame
                    Image("effect")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .offset(x: 150, y: -40)
                    
                    Spacer()
                    Image("effect")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                VStack{
                    
<<<<<<< HEAD
                    VStack(alignment: .leading) {
                        Text(audioVM.currentChunk.isEmpty ? "Say something..." : audioVM.currentChunk)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 25))
                            .lineLimit(2)     // يعرض فقط سطرين
                            .frame(width: 300, alignment: .leading)                       .animation(.easeInOut, value: audioVM.currentChunk)
                        
                    }
                    .onAppear {
                        audioVM.startAutoAdvance()
                    }
                    .onDisappear {
                        audioVM.stopAutoAdvance()
                    }

=======
                    VStack(alignment: .leading){
//                        Text("Hello i'm a student at apple")
//                            .font(.title)
//                            .foregroundColor(.gray)
//                        Text("and it's challenge three")
//                            .font(.title)
                        // HERE 👇 YOUR LIVE TRANSCRIPTION
                        Text(audioVM.finalText.isEmpty ? "Say something..." : audioVM.finalText)
                            .font(.title)
                            
                            .animation(.easeInOut, value: audioVM.finalText)
                        
                        Button(action: {
                                        audioVM.playRecording() // call your function
                        }) { Text("Play Recording") }
                    }
>>>>>>> main
                    
                    ZStack{
                        Circle()
                            .blur(radius: 10)
                            .frame(width: 200, height: 200)
                            .foregroundStyle(Color.aud1)
                            .scaleEffect(recViewModel.size)

                        Circle()
                            .blur(radius: 4)
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.aud2)
                            .scaleEffect(recViewModel.size1)

                        Circle()
                            .blur(radius: 4)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.aud3)
                            .scaleEffect(recViewModel.size)

                        Circle()
                            .blur(radius: 5)
                            .frame(width: 65, height: 65)
                            .foregroundStyle(Color.white)
                            .scaleEffect(recViewModel.size1)
                        
                        Circle()
                            .blur(radius: 5)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.black)
                            .scaleEffect(recViewModel.size)
                        
                        Circle()
                            .frame(width: 50 , height: 50 )
                            .foregroundStyle(Color.black)
                        
                        Button {
                            if isRecording {
                                audioVM.stopRecording()
                                recViewModel.stopSizeLoop()
                                recViewModel.stopTimer()
                                
                            } else {
                                audioVM.startRecording()
                                recViewModel.startSizeLoop()
                                recViewModel.startTimer()
                               
                            }
                            isRecording.toggle()
                        } label: {
                            Image(isRecording ? "Mic4" : "Mic")   // changes image while recording
                                .frame(width: 60, height: 60)
                                .padding()
                        }
                        
                    }
                    .frame(width: 200, height: 200) // fixed layout footprint for animated stack
                    // Place this ZStack just above the time label with a tight gap
                    .offset(x: 0, y: 60)
                    .padding(.bottom, 8)
                    
                    let hours = Int(recViewModel.time) / 3600
                    let minutes = (Int(recViewModel.time) % 3600) / 60
                    let seconds = Int(recViewModel.time) % 60
                    let milliseconds = Int((recViewModel.time.truncatingRemainder(dividingBy: 1)) * 100)
                    
                    Text(String(format : "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds, recViewModel.time))
                        .offset(x: 0, y: 55)
                        .monospacedDigit()
                    
                    ZStack{
                        Text("Take a Breath")
                            .bold()
                            .padding()
                            .frame(minWidth: 350, minHeight: 180, alignment: .topLeading)
                            .glassEffect(.clear, in: .rect(cornerRadius: 35))
                            .offset(x: 0, y: 80)
                        
                        Button("Skip") {
                            
                        }
                        .buttonStyle(.glass)
                        .offset(x: 125, y: 130)
                    }
                }
                .ignoresSafeArea() // allow content to extend beyond the screen edges
            }
            .onAppear {
                audioVM.context = context   // ← FIXED HERE
            }
            .navigationTitle("") // optional: empty title if you want only buttons
            .toolbarTitleDisplayMode(.inline) // correct API
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: records()) {
                        Text("Cancel")
                    }
                }
<<<<<<< HEAD

            }
        }
        .navigationBarBackButtonHidden(true)
=======
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("add text") {
//                        // handle add text
//                    }
//                }
            }
        }

>>>>>>> main
    }
}

#Preview {
    recView()
        .environmentObject(RecViewModel())
}



//import SwiftUI
//import AVFoundation
//import Combine
//import SwiftData
//
//struct recView: View {
//    @Environment(\.modelContext) private var context
<<<<<<< HEAD
//
=======
//    
>>>>>>> main
//    @EnvironmentObject var recViewModel: RecViewModel
//    @StateObject var audioVM = AudioRecordingViewModel()
//    @State var isRecording = false
//    @Environment(\.dismiss) private var dismiss
//
//
<<<<<<< HEAD
//
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//
=======
//    
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                
>>>>>>> main
//                VStack(spacing: 50){
//                    Spacer()
//                    // Top image positioned to the top-right and partly out of frame
//                    Image("effect")
//                        .alignmentGuide(.leading) { d in d[.trailing] }
//                        .offset(x: 150, y: -40)
<<<<<<< HEAD
//
=======
//                    
>>>>>>> main
//                    Spacer()
//                    Image("effect")
//                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding()
<<<<<<< HEAD
//
//                VStack{
//
=======
//                
//                VStack{
//                    
>>>>>>> main
//                    VStack(alignment: .leading){
////                        Text("Hello i'm a student at apple")
////                            .font(.title)
////                            .foregroundColor(.gray)
////                        Text("and it's challenge three")
////                            .font(.title)
//                    //TRANSCIPTED TEXT HERE ⚠️ FRONT END NEED TO BE FIXED
//                    Text(audioVM.finalText.isEmpty ? "Say something..." : audioVM.finalText)
//                        .font(.title)
<<<<<<< HEAD
//
//                        .animation(.easeInOut, value: audioVM.finalText)
//                    }
//
=======
//                        
//                        .animation(.easeInOut, value: audioVM.finalText)
//                    }
//                    
>>>>>>> main
//                    ZStack{
//                        Circle()
//                            .blur(radius: 10)
//                            .frame(width: 200, height: 200)
//                            .foregroundStyle(Color.aud1)
//                            .scaleEffect(recViewModel.size)
//
//                        Circle()
//                            .blur(radius: 4)
//                            .frame(width: 150, height: 150)
//                            .foregroundStyle(Color.aud2)
//                            .scaleEffect(recViewModel.size1)
//
//                        Circle()
//                            .blur(radius: 4)
//                            .frame(width: 100, height: 100)
//                            .foregroundStyle(Color.aud3)
//                            .scaleEffect(recViewModel.size)
//
//                        Circle()
//                            .blur(radius: 5)
//                            .frame(width: 65, height: 65)
//                            .foregroundStyle(Color.white)
//                            .scaleEffect(recViewModel.size1)
<<<<<<< HEAD
//
=======
//                        
>>>>>>> main
//                        Circle()
//                            .blur(radius: 5)
//                            .frame(width: 50, height: 50)
//                            .foregroundStyle(Color.black)
//                            .scaleEffect(recViewModel.size)
<<<<<<< HEAD
//
//                        Circle()
//                            .frame(width: 50 , height: 50 )
//                            .foregroundStyle(Color.black)
//
=======
//                        
//                        Circle()
//                            .frame(width: 50 , height: 50 )
//                            .foregroundStyle(Color.black)
//                        
>>>>>>> main
//                        Button {
//                            if isRecording {
//                                // 🔴 إيقاف التسجيل
//                                audioVM.stopRecording()
//                                recViewModel.stopSizeLoop()
//                                recViewModel.stopTimer()
//
//                                // ✅ نحفظ التسجيل في الـ ViewModel
//                                recViewModel.addCurrentRecording()
//
//                                // (اختياري) نفضّي الوقت والنص
//                                recViewModel.time = 0
//                                audioVM.finalText = ""
//
//                                // ✅ نرجع لصفحة التسجيلات
//                                dismiss()
//
//                            } else {
//                                // 🟢 بدء التسجيل
//                                audioVM.startRecording()
//                                recViewModel.startSizeLoop()
//                                recViewModel.startTimer()
//                            }
//
//                            isRecording.toggle()
//
//                        } label: {
//                            Image(isRecording ? "Mic4" : "Mic")
//                                .frame(width: 60, height: 60)
//                                .padding()
//                        }
<<<<<<< HEAD
//
=======
//                        
>>>>>>> main
//                    }
//                    .frame(width: 200, height: 200) // fixed layout footprint for animated stack
//                    // Place this ZStack just above the time label with a tight gap
//                    .offset(x: 0, y: 60)
//                    .padding(.bottom, 8)
<<<<<<< HEAD
//
=======
//                    
>>>>>>> main
//                    let hours = Int(recViewModel.time) / 3600
//                    let minutes = (Int(recViewModel.time) % 3600) / 60
//                    let seconds = Int(recViewModel.time) % 60
//                    let milliseconds = Int((recViewModel.time.truncatingRemainder(dividingBy: 1)) * 100)
<<<<<<< HEAD
//
//                    Text(String(format : "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds, recViewModel.time))
//                        .offset(x: 0, y: 55)
//                        .monospacedDigit()
//
=======
//                    
//                    Text(String(format : "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds, recViewModel.time))
//                        .offset(x: 0, y: 55)
//                        .monospacedDigit()
//                    
>>>>>>> main
//                    ZStack{
//                        Text("Take a Breath")
//                            .bold()
//                            .padding()
//                            .frame(minWidth: 350, minHeight: 180, alignment: .topLeading)
//                            .glassEffect(.clear, in: .rect(cornerRadius: 35))
//                            .offset(x: 0, y: 80)
<<<<<<< HEAD
//
//                        Button("Skip") {
//
=======
//                        
//                        Button("Skip") {
//                            
>>>>>>> main
//                        }
//                        .buttonStyle(.glass)
//                        .offset(x: 125, y: 130)
//                    }
//                    .navigationBarBackButtonHidden(true)
//                }
//                .ignoresSafeArea() // allow content to extend beyond the screen edges
//            }
//            .onAppear {
//                audioVM.context = context   // ← FIXED HERE
//            }
//            .navigationTitle("") // optional: empty title if you want only buttons
//            .toolbarTitleDisplayMode(.inline) // correct API
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: records()) {
//                        Text("Cancel")
//                    }
//                }
//
//                }
<<<<<<< HEAD
//            .navigationBarBackButtonHidden(true)
=======
//            .navigationBarBackButtonHidden(true) 
>>>>>>> main
//            }
//        .preferredColorScheme(.dark)
//
//        }
////        .preferredColorScheme(.dark)
//    }
//
//
//#Preview {
//    recView()
//        .environmentObject(RecViewModel())
//}
//
