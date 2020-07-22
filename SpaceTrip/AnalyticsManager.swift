//
//  AnalyticsManager.swift
//  SpaceTrip
//
//  Created by Kostya Bershov on 17.02.2020.
//  Copyright © 2020 Syject. All rights reserved.
//


import UIKit
import Foundation

class AnalyticsManager: NSObject{

    static let sharedInstance = AnalyticsManager()

    override init() {
        super.init()
        // Configure 3rd party SDKs here
    }
}

extension AnalyticsManager {
    
    func trackScene(_ name: String) {
        // TODO: Implement tracking
    }
    
}
