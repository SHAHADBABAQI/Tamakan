////
////  Untitled.swift
////  تمكّن
////
////  Created by noura on 01/12/2025.
////
//
import SwiftUI
import SwiftData

//
//  records.swift
//  تمكّن
//
//  Created by noura on 01/12/2025.
//

import SwiftUI
import SwiftData

//
struct records: View {
    @Environment(\.modelContext) var context
    @ObservedObject var audioVM = AudioRecordingViewModel()
    @State private var searchText = ""
    @State private var expandedID: UUID? = nil
    @Query private var record :[RecordingModel]
    @State var progress: Double = 0.2
    @Environment(\.layoutDirection) var layoutDirection


    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Image("Image1")
                            .frame(width: 180, height: 180)
                            .opacity(0.9)
                            .padding(.leading, 10)
                            .padding(.top, 0)
                        Spacer()
                    }
                    Spacer()
                }//v
                
                VStack(alignment: layoutDirection == .rightToLeft ? .trailing : .leading, spacing: 20) {
                            Spacer()

                            Text("Records")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity,
                                       alignment: layoutDirection == .rightToLeft ? .trailing : .leading)
                                .padding(.horizontal, 25)

                            TextField("search...", text: $searchText)
                                .padding(12)
                                .foregroundColor(.primary)
                                .background(.primary.opacity(0.08))
                                .cornerRadius(14)
                                .multilineTextAlignment(layoutDirection == .rightToLeft ? .trailing : .leading)
                                .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 18) {
//hereeeeeeeeeeeeeee
                            
                            
                            ForEach(record) { rec in
                                RecordingCardView(
                                    id: rec.id,
                                    title: rec.recordname,
                                    date: rec.date,
                                    duration: rec.duration,
                                    progress: $progress,
                                    isExpanded: expandedID == rec.id,
                                    recordURL: rec.audiofile,
                                    onTap: {
                                        withAnimation {
                                            expandedID = (expandedID == rec.id ? nil : rec.id)
                                        }
                                    }
                                )
                            }
                            
                            }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        
        VStack {
            Spacer()
            
            ZStack {
                Image("Image2")
                    .frame(height: 180)
                    .opacity(0.9)
                    .cornerRadius(20)
                    .padding(.bottom, -20)
                
                Image("Image3")
                    .frame(height: 180)
                    .opacity(0.9)
                    .cornerRadius(20)
                    .padding(.bottom, -15)
                
                NavigationLink(destination: recView()) {
                    Image("mic11")
                        .frame(width: 80, height: 80)
                        .padding(.bottom, -50)
                        .padding(.trailing,-5)
                }
            }
            .padding(.bottom, -30)
        }
    }
            .onAppear {
                audioVM.context = context
            }
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
        }//nav
}//view


}//struct



struct SecondView: View {
    var body: some View {
        Text("هذه الصفحة الثانية")
            .font(.largeTitle)
            .foregroundColor(.black)
    }
}


#Preview {
    records()
}
