//
//  Untitled.swift
//  تمكّن
//
//  Created by noura on 01/12/2025.
//

import SwiftUI

struct records: View {
    @EnvironmentObject var recViewModel: RecViewModel   // 👈 ناخذ التسجيلات من هنا
    @State private var searchText = ""
    @State private var expandedID: Int? = nil

    // فلترة حسب البحث
    var filteredRecordings: [Recording] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return recViewModel.recordings
        } else {
            return recViewModel.recordings.filter { rec in
                rec.title.contains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                // الخلفية العلوية
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
                }

                // المحتوى الرئيسي
                VStack(alignment: .trailing, spacing: 20) {
                    Spacer()

                    Text("التسجيلات")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 12)

                    TextField("ابحث…", text: $searchText)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(.primary.opacity(0.08))
                        .cornerRadius(14)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal, 20)

                    ScrollView {
                        VStack(spacing: 18) {
                            ForEach(filteredRecordings) { rec in
                                RecordingCard(
                                    id: rec.id,
                                    title: rec.title,
                                    date: rec.date,
                                    duration: rec.duration,
                                    isExpanded: expandedID == rec.id
                                ) {
                                    withAnimation(.spring(response: 0.35,
                                                          dampingFraction: 0.75)) {
                                        expandedID = (expandedID == rec.id ? nil : rec.id)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                }

                // زر المايك تحت
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

                        NavigationLink(destination: recView().environmentObject(recViewModel)) {
                            Image("mic11")
                                .frame(width: 80, height: 80)
                                .padding(.bottom, -50)
                                .padding(.trailing,-5)
                        }
                    }
                    .padding(.bottom, -30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
}

// كرت التسجيل نفسه اللي كنتِ حاطته
struct RecordingCard: View {
    @State private var showText = false

    let id: Int
    var title: String
    var date: String
    var duration: String
    var isExpanded: Bool
    var onTap: () -> Void

    @State private var progress: Double = 0.2

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {

            HStack {
                Text(duration)
                    .foregroundColor(.primary.opacity(0.8))

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(title)
                        .foregroundColor(.primary)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    Text(date)
                        .foregroundColor(.primary.opacity(0.6))
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { onTap() }

            if isExpanded {
                VStack(spacing: 12) {
                    Slider(value: $progress)
                        .tint(.primary)
                        .padding(.horizontal, 4)

                    HStack {
                        Text("-1:10")
                        Spacer()
                        Text("0:00")
                    }
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))

                    HStack(spacing: 28) {
                        Button {
                            showText = true
                        } label: {
                            Image(systemName: "text.bubble")
                        }
                        .sheet(isPresented: $showText) {
                            ShowText()
                        }

                        Image(systemName: "gobackward.15")
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 42))
                        Image(systemName: "goforward.15")
                        Image(systemName: "trash")
                    }
                    .foregroundColor(.primary)
                    .padding(.top, 4)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: isExpanded ? 200 : 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.primary.opacity(0.10))
        )
        .animation(.easeInOut, value: isExpanded)
    }
}

#Preview {
    records()
        .environmentObject(RecViewModel())   // 👈 مهم للـ Preview
}

