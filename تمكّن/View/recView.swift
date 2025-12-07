//
//  recView.swift
//  تمكّن
//

import SwiftUI
import AVFoundation
import Combine

struct recView: View {

    // MARK: - Environment
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject var recViewModel: RecViewModel
    @StateObject var audioVM = AudioRecordingViewModel()

    // MARK: - State
    @State private var showCancelAlert = false
    @State private var showSaveAlert = false
    @State private var showBreathBox = true

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: BACKGROUND EFFECT
                VStack(spacing: 50){
                    Spacer()
                    Image("effect")
                        .alignmentGuide(.leading) { d in d[.trailing] }
                        .offset(x: 150, y: -40)

                    Spacer()
                    Image("effect")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()

                VStack {

                    // MARK: - LIVE TEXT
                    VStack(alignment: .leading) {
                        Text(audioVM.displayedText.isEmpty ? "Say something..." : audioVM.displayedText)
                            .lineLimit(2)
                            .frame(width: 300, alignment: .leading)
                            .font(.system(size: 25))
                            .animation(.easeInOut, value: audioVM.displayedText)
                    }

                    // MARK: - RECORD UI
                    ZStack {
                        
                        Circle().blur(radius: 10)
                            .frame(width: 200, height: 200)
                            .foregroundStyle(Color.aud1)
                            .scaleEffect(recViewModel.size)

                        Circle().blur(radius: 4)
                            .frame(width: 150, height: 150)
                            .foregroundStyle(Color.aud2)
                            .scaleEffect(recViewModel.size1)

                        Circle().blur(radius: 4)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.aud3)
                            .scaleEffect(recViewModel.size)

                        Circle().blur(radius: 5)
                            .frame(width: 65, height: 65)
                            .foregroundStyle(.white)
                            .scaleEffect(recViewModel.size1)

                        Circle().blur(radius: 5)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)
                            .scaleEffect(recViewModel.size)

                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.black)

                        // MARK: - BUTTON
                        Button {
                            if audioVM.isRecording {
                                audioVM.stopRecording()
                                recViewModel.stopSizeLoop()
                                recViewModel.stopTimer()
                            } else {
                                audioVM.startRecording()
                                recViewModel.startSizeLoop()
                                recViewModel.startTimer()
                            }
                        } label: {
                            Image(audioVM.isRecording ? "Mic4" : "Mic")
                                .frame(width: 60, height: 60)
                                .padding()
                        }

                    }
                    .frame(width: 200, height: 200)
                    .offset(y: 60)
                    .padding(.bottom, 8)

                    // MARK: - TIMER
                    let hours = Int(recViewModel.time) / 3600
                    let minutes = (Int(recViewModel.time) % 3600) / 60
                    let seconds = Int(recViewModel.time) % 60
                    let milliseconds = Int((recViewModel.time.truncatingRemainder(dividingBy: 1)) * 100)

                    Text(String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds))
                        .offset(y: 55)
                        .monospacedDigit()

                    Spacer().frame(height: 40)

                    // MARK: - COMMENTS BOX
                    if showBreathBox {
                        ZStack {
                            Text("Take a Breath")
                                .bold()
                                .padding()
                                .frame(minWidth: 350, minHeight: 180, alignment: .topLeading)
                                .glassEffect(.clear, in: .rect(cornerRadius: 35))
                                .offset(y: 80)

                            Button("Skip") {
                                withAnimation {
                                    showBreathBox = false
                                }
                            }
                            .buttonStyle(.glass)
                            .offset(x: 125, y: 130)
                        }
                    }

                }
                .ignoresSafeArea()
            }

            .onAppear {
                audioVM.context = context
            }

            .toolbar {
                // CANCEL BUTTON
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showCancelAlert = true
                    }
                }

                // SAVE BUTTON
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        showSaveAlert = true
                    }
                }
            }

        }
        .navigationBarBackButtonHidden(true)

        // MARK: - CANCEL ALERT
        .alert("Discard recording?", isPresented: $showCancelAlert) {
            Button("Discard", role: .destructive) {
                audioVM.discardRecording()
                dismiss()
            }
            Button("Keep Recording", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }

        // MARK: - SAVE ALERT
        .alert("Save recording?", isPresented: $showSaveAlert) {
            Button("Save") {
                audioVM.saveRecording()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Would you like to save your recording?")
        }
    }
}

#Preview {
    recView()
        .environmentObject(RecViewModel())
}
