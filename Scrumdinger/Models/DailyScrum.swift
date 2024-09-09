//
//  DailyScrum.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 06/08/24.
//

import Foundation
import ScrumdingerKMMLib

extension DailyScrum{
  
    func makeCopy() -> DailyScrum{
        return DailyScrum(
            id: self.id,
            title: self.title,
            attendees: self.attendees, 
            lengthInMinutes: self.lengthInMinutes,
            theme: self.theme, 
            history: []
        )
    }
}
