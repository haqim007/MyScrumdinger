//
//  CardView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct MeetingCardView: View {
    let scrum: DailyScrum
    var body: some View {
        VStack(alignment: .leading) {
            Text(scrum.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack{
                Label("\(scrum.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel(
                      Strings().get(id: SharedRes.strings().meeting_card_accessibility_total_attendees, args: [scrum.attendees.count])
                    )
                Spacer()
                Label("\(scrum.lengthInMinutes)", systemImage: "clock")
                    .accessibilityLabel(
                      Strings().get(
                        id: SharedRes.strings().accessibility_meeting_duration_minutes,
                        args: [scrum.lengthInMinutes]
                      )
                    )
                    .padding(.trailing, 20)
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(scrum.accentColor.toThemeColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var scrum = DailyScrum.companion.sampleData[1]
    static var previews: some View {
        MeetingCardView(scrum: scrum)
        .background(scrum.themeString.toThemeColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
