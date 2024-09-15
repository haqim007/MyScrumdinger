//
//  EditScrumSheet.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct EditScrumSheet: View {
    let scrum: DailyScrum
    @ObservedObject
    var viewModel: ViewModel
    @Binding var isPresentingEditView: Bool
    @Environment(\.isPreview) private var isPreview: Bool
    
    var body: some View {
        NavigationStack{
            DetailEditView(scrum: $viewModel.editingScrum)
                .navigationTitle(scrum.title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(
                          Strings().get(id: SharedRes.strings().edit_scrum_cancel_btn)
                        ) {
                            isPresentingEditView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(
                          Strings().get(id: SharedRes.strings().edit_scrum_done_btn)
                        ) {
                            viewModel.saveScrum()
                            isPresentingEditView = false
                        }
                    }
                }
        }
        .onAppear{
          if !isPreview{
              viewModel.editingScrum = scrum.makeCopy()
          }
        }
    }
}

#Preview {
    EditScrumSheet(
        scrum: sampleData()[0],
        viewModel: .preview(),
        isPresentingEditView: .constant(true)
    )
    .environment(\.isPreview, true)
}


extension EditScrumSheet{
    
    @MainActor
    class ViewModel: ObservableObject{
        private let updateScrumUseCase = UpdateDailyScrumUseCase()
        @Published var result: Resource = .idle
        @Published var editingScrum = DailyScrum.companion.emptyScrum
        
        func saveScrum() {
           Task {
               do {
                   self.result = .loading
                   try await updateScrumUseCase.invoke(data: editingScrum)
                   
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
