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
                TextField("Title", text: $scrum.title)
                HStack {
                    Slider(value: $lengthInMinutesAsDouble, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    .onAppear{
                        lengthInMinutesAsDouble = scrum.lengthInMinutesAsDouble
                    }
                    .onChange(of: lengthInMinutesAsDouble){old, new in
                        scrum.lengthInMinutesAsDouble = new
                    }
                    .accessibilityValue("\(Int(lengthInMinutesAsDouble)) minutes")
                    Spacer()
                    Text("\(Int(lengthInMinutesAsDouble)) minutes")
                        .accessibilityHidden(true)
                }
                ThemePicker(selection: $scrum.theme)
            } header: {
                Text("Meeting info")
            }
            
            Section{
                ForEach(scrum.attendees, id: \.self.id) { attendee in
                    Text(attendee.name)
                }
                .onDelete { indices in
                    scrum.attendees.remove(atOffsets: indices)
                }
                
                HStack {
                    TextField("New Attendee", text: $newAttendeeName)
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
                            .accessibilityLabel("Add attendee")
                    }
                    .disabled(newAttendeeName.isEmpty)
                }
            } header: {
                Text("Attendees")
            }
        }
    }
}

#Preview {
    DetailEditView(scrum: .constant(DailyScrum.companion.emptyScrum))
}
