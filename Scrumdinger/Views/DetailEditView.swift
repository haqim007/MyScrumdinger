//
//  DetailEditView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct DetailEditView: View {
    @Binding var scrum: DailyScrum
    @State private var newAttendeeName = ""
    @State private var lengthInMinutesAsDouble = 0.0
  
  
    
    var body: some View {
        Form {
            Section{
                TextField(
                  Strings().get(id: SharedRes.strings().detail_edit_title_field_label),
                  text: $scrum.title
                )
                HStack {
                    Slider(value: $lengthInMinutesAsDouble, in: 5...30, step: 1) {
                        Text(Strings().get(id: SharedRes.strings().detail_edit_slide_meeting_length))
                    }
                    .onAppear{
                        lengthInMinutesAsDouble = scrum.lengthInMinutesAsDouble
                    }
                    .onChange(of: lengthInMinutesAsDouble){old, new in
                        scrum.lengthInMinutesAsDouble = new
                    }
                    .accessibilityValue(
                      Strings().get(
                        id: SharedRes.strings().detail_edit_accessibility_length_minutes,
                        args: [Int(lengthInMinutesAsDouble)]
                      )
                    )
                    Spacer()
                    Text(
                      Strings().get(
                        id: SharedRes.strings().detail_edit_length_minutes,
                        args: [Int(lengthInMinutesAsDouble)]
                      )
                    )
                        .accessibilityHidden(true)
                }
              ThemePicker(selection: $scrum.theme)
            } header: {
                Text(Strings().get(id: SharedRes.strings().detail_edit_meeting_info))
            }
            
            Section{
                ForEach(scrum.attendees, id: \.self.id) { attendee in
                    Text(attendee.name)
                }
                .onDelete { indices in
                    scrum.attendees.remove(atOffsets: indices)
                }
                
                HStack {
                    TextField(
                      Strings().get(id: SharedRes.strings().detail_edit_new_attendee_field_label),
                      text: $newAttendeeName
                    )
                    Button(action: {
                        withAnimation {
                            let attendee = DailyScrum.Attendee(
                                id: generateUniqueId(),
                                name: newAttendeeName
                            )
                            scrum.attendees.append(attendee)
                            newAttendeeName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel(
                              Strings()
                                .get(
                                  id:SharedRes
                                    .strings()
                                    .detail_edit_accessibility_add_attendee_btn
                                )
                            )
                    }
                    .disabled(newAttendeeName.isEmpty)
                }
            } header: {
                Text(Strings().get(id:SharedRes.strings().detail_edit_attendees))
            }
        }
    }
}

#Preview {
    DetailEditView(scrum: .constant(DailyScrum.companion.emptyScrum))
}
