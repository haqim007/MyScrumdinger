//
//  Dummy.swift
//  Scrumdinger
//
//  Created by Quipper Indonesia on 04/09/24.
//

import ScrumdingerKMMLib


func sampleData()-> [DailyScrum]{
  var sampleData = [DailyScrum]()
  DailyScrum.companion.sampleData.forEach{ data in
    sampleData.append(data)
  }
  
  return sampleData
}
