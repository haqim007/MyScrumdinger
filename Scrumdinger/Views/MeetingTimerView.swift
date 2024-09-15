//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib


struct MeetingTimerView: View {
    let speakers: [Speaker]
    let isRecording: Bool
    let theme: SColor
    let accentColor: SColor
    
    private var currentSpeaker: String {
      speakers.first(where: { !$0.isCompleted })?.name ?? Strings().get(id: SharedRes.strings().meeting_timer_someone)
    }
    
    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Text(currentSpeaker)
                        .font(.title)
                    Text(Strings().get(id: SharedRes.strings().meeting_timer_is_speaking))
                    Image(systemName: isRecording ? "mic" : "mic.slash")
                        .font(.title)
                        .padding(.top)
                        .accessibilityLabel(
                          isRecording ?
                          Strings()
                            .get(
                              id: SharedRes
                                .strings()
                                .meeting_timer_accessibility_with_transcription
                            ) :
                            Strings()
                            .get(
                              id:SharedRes
                                .strings()
                                .meeting_timer_accessibility_without_transcription
                            )
                        )
                }
                .accessibilityElement(children: .combine)
                .foregroundStyle(accentColor)
            }
            .overlay{
                ForEach(speakers, id: \.self.id) { speaker in
                    if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                            .rotation(Angle(degrees: -90))
                            .stroke(theme, lineWidth: 12)
                    }
                }
            }
    }
}


struct MeetingTimerView_Previews: PreviewProvider {
    static var speakers: [Speaker] {
        [
            Speaker(name: "Bill", isCompleted: true, id: generateUniqueId(salt: 1)),
         Speaker(name: "Cathy", isCompleted: false, id: generateUniqueId(salt: 2))]
    }
    
    static var previews: some View {
        MeetingTimerView(speakers: speakers, isRecording: false, theme: Color("yellow"), accentColor: Color("white"))
    }
}
