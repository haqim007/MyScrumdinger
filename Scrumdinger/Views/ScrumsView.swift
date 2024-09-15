//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct ScrumsView: View {
    @State private var isPresentingNewScrumView = false
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private(set) var viewModel: ViewModel
  
    @Environment(\.isPreview) private var isPreview: Bool
    
    var body: some View {
        NavigationStack{
            listView()
            .navigationTitle(Strings().get(id: SharedRes.strings().scrums_daily_scrums))
            .toolbar{
                Button(action: {
                    isPresentingNewScrumView = true
                }){
                    Image(systemName: "plus")
                }
                .accessibilityLabel(
                  Strings().get(id: SharedRes.strings().scrums_accessibility_add_new_scrum)
                )
            }
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NewScrumSheet(viewModel: .init(), isPresentingNewScrumView: $isPresentingNewScrumView)
        }.task {
          if !isPreview {
            await viewModel.loadData()
          }
        }
    }
    
    @ViewBuilder
    private func listView() -> some View {
        switch viewModel.resourceData {
        case .success:
          List(viewModel.scrums){ scrum in
              NavigationLink(destination: {
                  DetailView(scrumId: Int(scrum.id))
              }){
                  MeetingCardView(scrum: scrum)
              }
              .listRowBackground(scrum.themeString.toThemeColor)
          }
        case .error(let message):
          Text(message).multilineTextAlignment(.center)
        default:
          Text(
            Strings().get(id: SharedRes.strings().scrums_loading)
          ).multilineTextAlignment(.center)
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(viewModel: .preview())
          .environment(\.isPreview, true)
    }
}

extension DailyScrum: Identifiable { }

extension ScrumsView{
    
    @MainActor
    class ViewModel: ObservableObject{
        private let getAllDailyScrum = GetAllDailyScrumUseCase()
        @Published var resourceData: Resource = .idle
        @Published var scrums: [DailyScrum] = []
        
        func loadData() async {
            do {
                self.resourceData = .loading
                for try await newScrums in getAllDailyScrum.invoke(){
                    self.scrums = newScrums
                    
                    self.resourceData = .success
                }
            } catch {
                self.resourceData = .error(message: error.localizedDescription)
            }
        }
        
        static func preview() -> ViewModel {
            let viewModel = ViewModel()
            
            viewModel.scrums = sampleData()
            viewModel.resourceData = .success
            
            return viewModel
        }
    }
}

