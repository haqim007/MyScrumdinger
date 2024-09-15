//
//  HelloView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 15/09/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct HelloView: View {
    var body: some View {
      Text(Strings().get(id: SharedRes.strings().detail_edit_accessibility_add_attendee_btn))
    }
}

#Preview {
    HelloView()
}
