//
//  Analytics.swift
//  Analytics
//
//  Created by Nathan Larson on 3/5/19.
//  Copyright © 2019 Nathan Larson. All rights reserved.
//

import UIKit

public class Pies {
    
    fileprivate struct KeychainKeys {
        static let appId = "analytics-keychain-key-app-id"
        static let apiKey = "analytics-keychain-key-api-key"
        static let deviceId = "analytics-keychain-key-device-id"
        static let installDate = "analytics-keychain-key-install-date"
    }
    
    fileprivate static var keychain: KeychainSwift = {
        let keychain = KeychainSwift()
        keychain.synchronizable = false
        return keychain
    }()
    
}

public extension Pies {
    
    /// Configure Analytics with your appId and apiKey that can be found in your email.
    static func configure(appId: String, apiKey: String, enableLogging: Bool = false) {
        if appId.isEmpty || apiKey.isEmpty {
            fatalError("You must provide a valid appId and valid apiKey.")
        }
        PiesHelper.shared.loggingEnabled = enableLogging
        Pies.keychain.set(appId, forKey: KeychainKeys.appId)
        Pies.keychain.set(apiKey, forKey: KeychainKeys.apiKey)
        checkForNewInstall()
        
        PiesHelper.shared.startListening()
        
        
        
    }
    
    
    
}

public extension Pies {
    
    /// Log when an IAP purchase happens and see it live on the dashboard.
    static func logInAppPurchase(name: String, amount: Double) {
        guard let appId = Pies.keychain.get(KeychainKeys.appId),
            let apiKey = Pies.keychain.get(KeychainKeys.apiKey),
            let deviceId = Pies.keychain.get(KeychainKeys.deviceId) else {
                return
        }
        guard let request = APIBuilder.requestForIAP(appId: appId, apiKey: apiKey, deviceId: deviceId, name: name, amount: amount) else { return }
        
        let op = APIOperation(request: request) { (data) in
            PLog("Do something here if desired.")
        }
        
        APIQueues.shared.defaultQueue.addOperation(op)
    }
    
    
}

private extension Pies {
    static func checkForNewInstall() {
        
        if PiesHelper.shared.loggingEnabled {
            print("\n\n-------------------\n\nChecking if app is a new install.\n\n-------------------\n\n")
        }
        //if install date == build install date then it's an install
        if Pies.keychain.get(KeychainKeys.installDate) != nil {
            if PiesHelper.shared.loggingEnabled {
                print("\n\n-------------------\n\nApp was previously installed with Pies - cancelling new install check.\n\n-------------------\n\n")
            }
            return
        }
        
        var installed: Date?
        var buildInstalled: Date?
        if let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            if let installDate = try? FileManager.default.attributesOfItem(atPath: documentsFolder.path)[.creationDate] as? Date {
                installed = installDate
            }
        }
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let buildInstallDate = try? FileManager.default.attributesOfItem(atPath: path)[.creationDate] as? Date {
                buildInstalled = buildInstallDate
            }
        }

        if let installed = installed, let buildInstalled = buildInstalled {
            let installedComps = Calendar.current.dateComponents([.day, .year, .month, .minute, .hour], from: installed)
            let buildInstalledComps = Calendar.current.dateComponents([.day, .year, .month, .minute, .hour], from: buildInstalled)
            
            guard let iYear = installedComps.year, let iMonth = installedComps.month, let iDay = installedComps.day, let iHour = installedComps.hour, let iMin = installedComps.minute else { return }
            
            guard let bYear = buildInstalledComps.year, let bMonth = buildInstalledComps.month, let bDay = buildInstalledComps.day, let bHour = buildInstalledComps.hour, let bMin = buildInstalledComps.minute else { return }
            
            if iYear == bYear, iMonth == bMonth, iDay == bDay, iHour == bHour, iMin == bMin {
                Pies.keychain.set("installed", forKey: KeychainKeys.installDate)
                if Pies.keychain.get(KeychainKeys.deviceId) != nil {
                    return
                }
                
                let id = NSUUID().uuidString
                Pies.keychain.set(id, forKey: KeychainKeys.deviceId)
                
                guard let appId = Pies.keychain.get(KeychainKeys.appId),
                let apiKey = Pies.keychain.get(KeychainKeys.apiKey),
                    let deviceId = Pies.keychain.get(KeychainKeys.deviceId) else {
                        return
                }
                
                guard let request = APIBuilder.requestForNewInstall(appId: appId, apiKey: apiKey, deviceId: deviceId) else { return }
                
                let op = APIOperation(request: request) { (data) in
                    PLog("Do something here if desired.")
                }
                APIQueues.shared.defaultQueue.addOperation(op)
            }
        }
        
        
        
    }
    
    
    
}
