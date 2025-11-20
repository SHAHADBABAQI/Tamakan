//
//  recView.swift
//  تمكّن
//
//  Created by shahad khaled on 28/05/1447 AH.
//




//
//  ContentView.swift
//  تمكّن
//
//  Created by shahad khaled on 27/05/1447 AH.
//

import SwiftUI
import AVFoundation

struct recView: View {
    @StateObject var audioVM = AudioRecordingViewModel()
    @State var isRecording = false
//    @State private var scale: CGFloat = 1.0
//       var mic: String
       
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
                    
                    VStack(alignment: .leading){
                        Text("Hello i'm a student at apple")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("and it's challenge three")
                            .font(.title)
                    }
                    
                    ZStack{
                        Image("Aud1")
                        Image("Aud2")
                        Image("Aud3")
                        Image("Aud4")
                        Image("Aud5")
                        Image("Aud6")
                        
                        
                        Button {
                                if isRecording {
                                    audioVM.stopRecording()
                                } else {
                                    audioVM.startRecording()
                                }
                                isRecording.toggle()
                            } label: {
                                Image(isRecording ? "Mic4" : "Mic")   // changes image while recording
                                    .frame(width: 60, height: 60)
                                    .padding()
                            }
                        
                    }
                    // Place this ZStack just above the time label with a tight gap
                    .offset(x: 0, y: 60)
                    .padding(.bottom, 8)
                    
                    Text("00:12.50")
                        .offset(x: 0, y: 55)
                    
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
            .navigationTitle("") // optional: empty title if you want only buttons
            .toolbarTitleDisplayMode(.inline) // correct API
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // handle cancel
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("add text") {
                        // handle add text
                    }
                }
            }
        }
    }
}

#Preview {
    recView()
}
