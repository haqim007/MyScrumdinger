//
//  NSArray+Scrumdinger.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 03/09/24.
//

import ScrumdingerKMMLib
import Foundation

extension NSArray{
  func toSwiftArray<T>(ofType type: T.Type) -> [T]? {
      return self as? Array<T>
  }
}

func toSwiftArray<T>(nsArray: NSArray) -> [T]? {
    return nsArray.compactMap { $0 as? T }
}
