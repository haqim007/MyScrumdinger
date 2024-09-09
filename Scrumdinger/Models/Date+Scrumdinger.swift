//
//  Date+Scrumdinger.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 16/08/24.
//

import Foundation
import ScrumdingerKMMLib

extension Date {
    init(epochMillis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(epochMillis) / 1000.0)
    }
    
    init(kotlinDateTime: Kotlinx_datetimeLocalDateTime){
        self = Date(
            timeIntervalSince1970: TimeInterval(
                kotlinDateTime.toEpochMillis(
                    timeZone: Kotlinx_datetimeTimeZone.companion.currentSystemDefault()
                )
            ) / 1000.0
        )
    }
    
    init(from iso8601String: String) {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: iso8601String) {
            self = date
        } else {
            // Handle the case where the date could not be parsed
            self = Date() // Default to current date or handle error as needed
        }
    }
    
    func toISO8601String() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
}
