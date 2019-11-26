//
//  AnalyticsHelper.swift
//  Analytics
//
//  Created by Nathan Larson on 3/19/19.
//  Copyright © 2019 Nathan Larson. All rights reserved.
//

import UIKit

class PiesHelper {
    static let shared = PiesHelper()
    
    var loggingEnabled: Bool = false
    
    struct KeychainKeys {
        static let appId = "analytics-keychain-key-app-id"
        static let apiKey = "analytics-keychain-key-api-key"
        static let deviceId = "analytics-keychain-key-device-id"
    }
    
    var keychain: KeychainSwift = {
        let keychain = KeychainSwift()
        keychain.synchronizable = false
        return keychain
    }()
    
    func startListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResign), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willResign() {
        if PiesHelper.shared.loggingEnabled {
            print("\n\n-------------------\n\nApp session ended.\n\n-------------------\n\n")
        }
        guard let appId = keychain.get(KeychainKeys.appId),
            let apiKey = keychain.get(KeychainKeys.apiKey),
            let deviceId = keychain.get(KeychainKeys.deviceId) else {
                return
        }
        guard let request = APIBuilder.requestForSessionEnd(appId: appId, apiKey: apiKey, deviceId: deviceId) else { return }
        
        let op = APIOperation(request: request) { (data) in
            PLog("Do something here if desired.")
        }
        
        APIQueues.shared.defaultQueue.addOperation(op)
    }
    
    @objc func becameActive() {
        if PiesHelper.shared.loggingEnabled {
            print("\n\n-------------------\n\nNew app session started\n\n-------------------\n\n")
        }
        guard let appId = keychain.get(KeychainKeys.appId),
            let apiKey = keychain.get(KeychainKeys.apiKey),
            let deviceId = keychain.get(KeychainKeys.deviceId) else {
                return
        }
        guard let request = APIBuilder.requestForSessionStart(appId: appId, apiKey: apiKey, deviceId: deviceId) else { return }
        
        let op = APIOperation(request: request) { (data) in
            PLog("Do something here if desired.")
        }
        
        APIQueues.shared.defaultQueue.addOperation(op)
    }
}
