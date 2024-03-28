//
//  AppDelegate.swift
//  Mike Demo
//
//  Created by Michael Bean on 02/10/2021.
//

import Foundation
import UIKit
import NewRelic

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NewRelic.setMaxEventBufferTime(10)
        NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_SwiftInteractionTracing)
        NewRelic.enableFeatures(NRMAFeatureFlags.NRFeatureFlag_DistributedTracing)
        
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let dict = keys {
            let newRelicKey = dict["newRelicKey"] as? String
            
            NewRelic.start(withApplicationToken: newRelicKey!)
        }

        return true
    }
}
