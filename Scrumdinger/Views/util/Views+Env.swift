//
//  Views+Env.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 04/09/24.
//

import SwiftUI

struct IsPreviewKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}
