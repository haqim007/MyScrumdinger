//
//  NewScrumSheet.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct NewScrumSheet: View {
    @State private var newScrum = DailyScrum.companion.emptyScrum
    @ObservedObject private(set) var viewModel: ViewModel
    @Binding var isPresentingNewScrumView: Bool


    var body: some View {
        NavigationStack {
            DetailEditView(scrum: $viewModel.newScrum)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewScrumView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            isPresentingNewScrumView = false
                            viewModel.saveScrum()
                        }
                    }
                }
        }
    }
}


struct NewScrumSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewScrumSheet(viewModel: .preview(),isPresentingNewScrumView: .constant(true))
    }
}



extension NewScrumSheet{
    
    @MainActor
    class ViewModel: ObservableObject{
        private let addScrumUseCase = AddDailyScrumUseCase()
        @Published var result: Resource = .idle
        @Published var newScrum = DailyScrum.companion.emptyScrum
        
        func saveScrum() {
           Task {
               do {
                   self.result = .loading
                   try await addScrumUseCase.invoke(
                    title: newScrum.title,
                    lengthInMinutes: newScrum.lengthInMinutes,
                    theme: newScrum.theme,
                    attendees: newScrum.attendees
                   )
                   self.result = .success
               } catch {
                   self.result = .error(message: error.localizedDescription)
               }
           }
        }
        
        static func preview() -> ViewModel {
            let viewModel = ViewModel()
            
            return viewModel
        }
    }
}
