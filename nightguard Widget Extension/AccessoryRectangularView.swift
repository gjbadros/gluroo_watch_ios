//
//  AccessoryRectangularView.swift
//  nightguard
//
//  Created by Dirk Hermanns on 02.04.23.
//  Copyright © 2023 private. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

struct AccessoryRectangularView : View {
    
    var entry: NightscoutDataEntry
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    ForEach(entry.lastBGValues, id: \.self.id) { bgEntry in
                        Text("\(calculateAgeInMinutes(from:NSNumber(value: bgEntry.timestamp)))m")
                            .foregroundColor(Color(entry.sgvColor))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                VStack {
                    ForEach(entry.lastBGValues, id: \.self.id) { bgEntry in
                        Text("\(String(bgEntry.value)) \(bgEntry.delta)")
                            .foregroundColor(Color(entry.sgvColor))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                if entry.lastBGValues.isEmpty {
                    Text("--- --- ---")
                }
            }
            Text("\(snoozedForMinutes(snoozeTimestamp: entry.snoozedUntilTimestamp))min Snoozed")
        }
        .widgetAccentable(true)
        .unredacted()
    }
    
    func snoozedForMinutes(snoozeTimestamp: TimeInterval) -> Int {
        let currentTimestamp = Date().timeIntervalSince1970
        let snoozedMinutes = Int((snoozeTimestamp - currentTimestamp) / 60)
        if snoozedMinutes < 0 {
            return 0
        }
        return snoozedMinutes
    }
}
