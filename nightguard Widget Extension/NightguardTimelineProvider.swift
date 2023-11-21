//
//  NightguardTimelineProvider.swift
//  nightguard
//
//  Created by Dirk Hermanns on 02.04.23.
//  Copyright © 2023 private. All rights reserved.
//

import Foundation
import WidgetKit

struct NightguardTimelineProvider: TimelineProvider {
    
    func getSnapshot(in context: Context, completion: @escaping (NightscoutDataEntry) -> Void) {
        
        getTimelineData { nightscoutDataEntry in
            completion(nightscoutDataEntry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NightscoutDataEntry>) -> Void) {
        
        getTimelineData { nightscoutDataEntry in
            
            var entries: [NightscoutDataEntry] = []
            entries.append(nightscoutDataEntry)
            // ask for a refresh after 5 Minutes:
            completion(Timeline(entries: entries, policy:
                    .after(Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date())))
        }
    }
    
    
    var displayName: String = ""
    
    public init(displayName: String) {
        self.displayName = displayName
    }
    
    func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
        return [
            IntentRecommendation(intent: ConfigurationIntent(), description: displayName)
        ]
    }
    
    func placeholder(in context: Context) -> NightscoutDataEntry {
        
        NightscoutDataEntry(configuration: ConfigurationIntent())
    }

    /*func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NightscoutDataEntry) -> ()) {
        
        completion(getTimelineData(configuration: configuration))
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<NightscoutDataEntry>) -> ()) {
        
        var entries: [NightscoutDataEntry] = []

        entries.append(getTimelineData())
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }*/
    
    private func getTimelineData(completion: @escaping (NightscoutDataEntry) -> Void) {
        
        let data = NightscoutDataRepository.singleton.loadCurrentNightscoutData()
        
        NightscoutService.singleton.readTodaysChartData(oldValues: []) { (bloodSugarValues: [BloodSugar]) in
            
            let bgEntries = bloodSugarValues.map() {bgValue in
                return BgEntry(
                    value: UnitsConverter.mgdlToDisplayUnits(String(bgValue.value)),
                    valueColor: UIColorChanger.getBgColor(String(bgValue.value)),
                    delta: "0", timestamp: bgValue.timestamp)
            }
            var reducedEntries = bgEntries
            if bgEntries.count > 3 {
                reducedEntries = []
                for i in bgEntries.count-4..<bgEntries.count {
                    reducedEntries.append(bgEntries[i])
                }
            }
            
            let reducedEntriesWithDelta = calculateDeltaValues(reducedEntries)
            
            let entry = NightscoutDataEntry(
                date: Date(timeIntervalSince1970: data.time.doubleValue / 1000),
                sgv: UnitsConverter.mgdlToDisplayUnits(data.sgv),
                sgvColor: UIColorChanger.getBgColor(data.sgv),
                bgdeltaString: UnitsConverter.mgdlToDisplayUnitsWithSign(data.bgdeltaString),
                bgdeltaColor: UIColorChanger.getDeltaLabelColor(data.bgdelta),
                bgdeltaArrow: data.bgdeltaArrow,
                bgdelta: data.bgdelta,
                time: data.time,
                battery: data.battery,
                iob: data.iob,
                cob: data.cob,
                lastBGValues: reducedEntriesWithDelta.reversed(),
                configuration: ConfigurationIntent())
            
            completion(entry)
        }
    }
    
    private func calculateDeltaValues(_ reducedEntries: [BgEntry]) -> [BgEntry] {
        
        var preceedingEntry: BgEntry?
        var newEntries: [BgEntry] = []
        for bgEntry in reducedEntries {
            if preceedingEntry?.value != nil {
                let v1AsFloat: Float = Float(bgEntry.value) ?? Float.zero
                let v2AsFloat: Float = Float(preceedingEntry?.value ?? bgEntry.value) ?? v1AsFloat
                let newEntry = BgEntry(
                    value: bgEntry.value,
                    valueColor: UIColorChanger.getBgColor(bgEntry.value),
                    delta: Float(v1AsFloat - v2AsFloat).cleanSignedValue,
                    timestamp: bgEntry.timestamp)
                newEntries.append(newEntry)
            }
            preceedingEntry = bgEntry
        }
        
        return newEntries
    }
}
