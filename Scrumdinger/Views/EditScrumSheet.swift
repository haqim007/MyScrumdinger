//
//  EditScrumSheet.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI

struct EditScrumSheet: View {
    @Binding var scrum: DailyScrum
    @State private var editingScrum = DailyScrum.emptyScrum
    @Binding var isPresentingEditView: Bool
    
    var body: some View {
        NavigationStack{
            DetailEditView(scrum: $editingScrum)
                .navigationTitle(scrum.title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresentingEditView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isPresentingEditView = false
                            scrum = editingScrum
                        }
                    }
                }
        }
        .onAppear{
            editingScrum = scrum
        }
    }
}

#Preview {
    EditScrumSheet(
        scrum: .constant(DailyScrum.sampleData[0]),
        isPresentingEditView: .constant(true)
    )
}
