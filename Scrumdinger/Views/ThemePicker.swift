//
//  ThemePicker.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct ThemePicker: View {
    @Binding var selection: Theme
    
    /// must duplicate the binding into a state, otherwise it will not work
    @State private var selectionState: Theme = Theme.yellow
    
    var body: some View {
        Picker("Theme", selection: $selectionState) {
            ForEach(Theme.allCases , id: \.self) { theme in
                ThemeView(theme: theme)
                   .tag(theme)
            }
        }
        .pickerStyle(.navigationLink)
        .onAppear{
            selectionState = selection
      }
        .onChange(of: selectionState){old, new in
            selection = selectionState
        }
    }
    
//    var body: some View {
//        Picker("Theme", selection: $selection) {
//            ForEach(Theme.allCases, id: \.self) { theme in
//                ThemeView(theme: theme)
//                   .tag(theme)
//            }
//        }
//        .pickerStyle(.navigationLink)
//    }
}

struct ThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ThemePicker(selection: .constant(.periwinkle))
    }
}
