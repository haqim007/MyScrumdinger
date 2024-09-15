//
//  DetailView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct DetailView: View {
    let scrumId: Int
    @StateObject private var viewModel: ViewModel = .init()
    @State private var isPresentingEditView = false
    @Environment(\.isPreview) private var isPreview: Bool
  
    var body: some View {
      List {
          Section{
              NavigationLink{
                MeetingView(scrum: viewModel.scrum)
              } label: {
                  Label(
                    Strings().get(id: SharedRes.strings().start_meeting),
                    systemImage: "timer"
                  )
                      .font(.headline)
                      .foregroundColor(.accentColor)
              }
              HStack {
                  Label(
                    Strings().get(id: SharedRes.strings().detail_meeting_length),
                    systemImage: "clock"
                  )
                  Spacer()
                Text(
                  Strings().get(
                    id: SharedRes.strings().detail_meeting_length_minutes,
                    args: [viewModel.scrum.lengthInMinutes]
                  )
                )
              }
              .accessibilityElement(children: .combine)
              HStack {
                  Label(
                    Strings().get(
                      id: SharedRes.strings().detail_meeting_theme
                    ),
                    systemImage: "paintpalette"
                  )
                  Spacer()
                Text(viewModel.scrum.themeString)
                      .padding(4)
                      .foregroundColor(viewModel.scrum.accentColor.toThemeColor)
                      .background(viewModel.scrum.themeString.toThemeColor)
                      .cornerRadius(4)
              }
              .accessibilityElement(children: .combine)
          } header: {
              Text(
                Strings().get(
                  id: SharedRes.strings().detail_meeting_meeting_info
                )
              )
          }
          
          Section{
            ForEach(viewModel.scrum.attendees, id: \.self.id) { attendee in
                  Label(attendee.name, systemImage: "person")
              }
          } header: {
              Text(Strings().get(id: SharedRes.strings().detail_meeting_attendees))
          }
          
          Section{
            if viewModel.scrum.history.isEmpty{
                  Label(
                    Strings().get(id: SharedRes.strings().detail_meeting_no_meetings_yet),
                    systemImage: "calendar.badge.exclamationmark"
                  )
              }
            ForEach(viewModel.scrum.history) { history in
                  NavigationLink(
                      destination: HistoryView(history: history)
                  ) {
                      HStack {
                          Image(systemName: "calendar")
                          Text(
                              Date(from: history.dateTimeUTC),
                              style: .date
                          )
                          .padding(.trailing, 1)
                        
                          Text(
                              Date(from: history.dateTimeUTC),
                              style: .time
                          )
                      }
                  }
              }
          } header: {
              Text(Strings().get(id: SharedRes.strings().detail_meeting_history))
          }
          .onReceive(viewModel.$scrum) { scrum in
            print(scrum.history)
          }
      }
      .navigationTitle(viewModel.scrum.title)
      .sheet(isPresented: $isPresentingEditView) {
          EditScrumSheet(
            scrum: viewModel.scrum,
              viewModel: .init(),
              isPresentingEditView: $isPresentingEditView
          )
      }
      .toolbar {
          Button(Strings().get(id: SharedRes.strings().detail_meeting_btn_edit)) {
              isPresentingEditView = true
          }
      }
      .onAppear{
        if isPreview {
          viewModel.setDummyScrum()
        }else{
          viewModel.getScrum(scrumId: scrumId)
        }
          
      }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
          DetailView(scrumId: Int(sampleData()[0].id))
            .environment(\.isPreview, true)
        }
    }
}

extension History: Identifiable{}

extension DetailView{
    
    @MainActor
    class ViewModel: ObservableObject{
        private let getScrumUseCase = GetDailyScrumUseCase()
        @Published var result: Resource = .idle
        @Published var scrum: DailyScrum = .companion.emptyScrum
        
        func getScrum(scrumId: Int) {
            Task{
                do{
                    self.result = .loading
                    for try await scrumData in getScrumUseCase.invoke(scrumId: Int64(scrumId)){
                        if scrumData != nil{
                            self.scrum = scrumData!
                            self.result = .success
                        }else{
                            self.result = .error(message: Strings().get(id: SharedRes.strings().detail_meeting_error_not_found_msg))
                        }
                    }
                } catch {
                    self.result = .error(message: error.localizedDescription)
                }
            }
        }
      
      func setDummyScrum(){
        scrum = sampleData()[0]
      }
    }
  
  
}

