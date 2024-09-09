//
//  ContentView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 05/08/24.
//

import SwiftUI
import AVFoundation
import ScrumdingerKMMLib

struct MeetingView: View {
    let scrum: DailyScrum
    @StateObject private var viewModel: ViewModel = .init()
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
            .fill(scrum.themeString.toThemeColor)
            VStack {
                MeetingViewHeader(
                    secondsElapsed: scrumTimer.secondsElapsed,
                    secondsRemaining: scrumTimer.secondsRemaining
                )
                
                Spacer()
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.themeString.toThemeColor, accentColor: scrum.accentColor.toThemeColor)
                Spacer()
                MeetingViewFooter(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
            .padding()
            .foregroundStyle(scrum.accentColor.toThemeColor)
            .onAppear {
               startScrum()
            }
            .onDisappear {
                endScrum()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func startScrum() {
        scrumTimer.reset(lengthInMinutes: Int(scrum.lengthInMinutes), attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
           player.seek(to: .zero)
           player.play()
        }
        
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
        scrumTimer.startScrum()
   }
    
    private func endScrum() {
        viewModel.addHistory(
            scrumId: scrum.id,
            dateTimeUTC: Date().toISO8601String(),
            attendees: scrum.attendees,
            transcript: speechRecognizer.transcript
        )
        scrumTimer.stopScrum()
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
}

#Preview {
    MeetingView(scrum: sampleData()[0])
}


extension MeetingView{
    
    @MainActor
    class ViewModel: ObservableObject{
        private let addHistoryUseCase = AddDailyScrumHistoryUseCase()
        @Published var result: Resource = .idle
        @Published var scrum = DailyScrum.companion.emptyScrum
        
        func addHistory(scrumId: Int64, dateTimeUTC: String, attendees: [DailyScrum.Attendee], transcript: String) {
            Task{
                do{
                    self.result = .loading
                    try await addHistoryUseCase.invoke(
                        transcript: transcript,
                        attendees: attendees,
                        dateTimeUTC: dateTimeUTC,
                        scrumId: scrumId
                    )
                    self.result = .success
                } catch {
                    self.result = .error(message: error.localizedDescription)
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

struct MeetingViewHeader: View {
    
    let secondsElapsed: Int
    let secondsRemaining: Int
    
    private var totalSeconds: Int {
        secondsElapsed + secondsRemaining
    }
    private var progress: Double {
        guard totalSeconds > 0 else { return 1 }
        return Double(secondsElapsed) / Double(totalSeconds)
    }
    private var minutesRemaining: Int {
       secondsRemaining / 60
   }
    
    var body: some View {
        VStack{
            ProgressView(value: progress)
            HStack{
                VStack(alignment: .leading) {
                  Text(SharedRes.strings().speaker_seconds_elapsed)
                    Text("Seconds Elapsed")
                        .font(.caption)
                    Label("\(secondsElapsed)", systemImage: "hourglass.tophalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)
                    Label("\(secondsRemaining)", systemImage: "hourglass.bottomhalf.fill")
                        .labelStyle(.trailingIcon)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Time Remaining")
            .accessibilityValue("\(minutesRemaining) Minutes")
            .padding([.top, .horizontal])
        }
    }
}

struct MeetingViewFooter: View {
    let speakers: [Speaker]
    var skipAction: ()->Void
    
    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil }
        return index + 1
    }
    
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    
    var body: some View {
        VStack {
            HStack{
                if isLastSpeaker {
                    Text("Last Speaker")
                } else {
                    Text("\(speakerText)")
                    Spacer()
                    Button(action: skipAction){
                        Image(systemName: "forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
            }
        }
        .padding([.bottom, .horizontal])
    }
}
