//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 05/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

@main
struct ScrumdingerApp: App {
    init() {
         KoinHelper().doInitKoin()
     }
    @StateObject private var store = ScrumStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            ScrumsView(viewModel: .init())
        }
    }
}
