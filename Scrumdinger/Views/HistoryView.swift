//
//  HistoryView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib


struct HistoryView: View {
    let history: IHistory


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Attendees")
                    .font(.headline)
                Text(history.attendees.toString)
                if let transcript = history.transcript {
                    Text("Transcript")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(Date(from: history.dateTimeUTC), style: .date))
        .padding()
    }
}


extension Array where Element == DailyScrum.Attendee {
    var toString: String {
        ListFormatter.localizedString(byJoining: self.map { $0.name })
    }
}


struct HistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        HistoryView(
            history: History(
                id: generateUniqueId(),
                dateTimeUTC: Date().toISO8601String(),
                attendees: [
                    DailyScrum.Attendee(
                        id: generateUniqueId(salt: 1),
                        name: "Jon"
                    ),
                    DailyScrum.Attendee(
                        id: generateUniqueId(salt: 2),
                        name: "Darla"
                    ),
                    DailyScrum.Attendee(
                        id: generateUniqueId(salt: 3),
                        name: "Luis"
                    ),
                ],
                transcript: "Darla, would you like to start today? Sure, yesterday I reviewed Luis' PR and met with the design team to finalize the UI..."
            )
        )
    }
}
