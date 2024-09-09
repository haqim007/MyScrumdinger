//
//  Theme.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import SwiftUI
import ScrumdingerKMMLib

extension String{
  var toThemeColor: SwiftUI.Color {
      Color(String(describing: self))
  }
}


extension Theme{
//    var accentColor: Color {
//        switch self {
//        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
//        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
//        }
//    }
//    var mainColor: Color {
//        Color(String(describing: self))
//    }
//  
  static func fromString(_ source: String) -> Theme {
    return Theme.companion.fromColorName(colorName: source) ?? .yellow
  }
}

//enum Theme: String, CaseIterable, Identifiable, Codable{
//    case bubblegum
//    case buttercup
//    case indigo
//    case lavender
//    case magenta
//    case navy
//    case orange
//    case oxblood
//    case periwinkle
//    case poppy
//    case purple
//    case seafoam
//    case sky
//    case tan
//    case teal
//    case yellow
//    
//    var accentColor: Color {
//        switch self {
//        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow: return .black
//        case .indigo, .magenta, .navy, .oxblood, .purple: return .white
//        }
//    }
//    var mainColor: Color {
//        Color(rawValue)
//    }
//    var name: String {
//        rawValue.capitalized
//    }
//    var id: String {
//        name
//    }
//}
