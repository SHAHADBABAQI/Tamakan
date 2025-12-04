//___FILEHEADER___

import SwiftUI
import SwiftData

@main
struct TamakanApp: App {
    @StateObject private var recViewModel = RecViewModel()
    var body: some Scene {
        WindowGroup {
            
                        GetStarted()
                            .environmentObject(RecViewModel())
//            recView()
//                .environmentObject(recViewModel)
        }.modelContainer(for: RecordingModel.self)
//        WindowGroup {
//            //GetStarted()
//            GetStarted()
//                .environmentObject(RecViewModel())
//                //.environmentObject(recViewModel)
//        }.modelContainer(for: RecordingModel.self)
    }
}

