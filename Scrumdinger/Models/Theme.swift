//
//  Theme.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

extension String{
  var toThemeColor: SColor {
      Color(String(describing: self))
  }
  var toTheme: Theme {
      Theme.companion.fromColorName(colorName: self) ?? .yellow
  }
  var toThemeAccentColor: SColor{
    Color(Theme.companion.fromColorName(colorName: self)?.accentColor ?? Theme.yellow.accentColor)
  }
}


extension Theme{
  static func fromString(_ source: String) -> Theme {
    return Theme.companion.fromColorName(colorName: source) ?? .yellow
  }
}
