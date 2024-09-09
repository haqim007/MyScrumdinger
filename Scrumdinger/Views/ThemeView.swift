//
//  ThemeView.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

struct ThemeView: View {
    let theme: Theme
    var body: some View {
        Text(theme.name)
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(theme.colorName.toThemeColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .foregroundColor(theme.accentColor.toThemeColor)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: .buttercup)
    }
}
