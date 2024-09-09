//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import Foundation
import SwiftUI
import ScrumdingerKMMLib

@MainActor
class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("scrums.data")
    }
    
    func load() async throws {
        self.scrums = DailyScrum.companion.sampleData
    }
    
    func save(scrums: [DailyScrum]) async throws {
//        let task = Task {
//            let data = try JSONEncoder().encode(scrums)
//            let outfile = try Self.fileURL()
//            try data.write(to: outfile)
//        }
//        _ = try await task.value
    }
}


