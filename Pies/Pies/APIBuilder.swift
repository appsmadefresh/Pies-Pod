//
//  APIBuilder.swift
//  Analytics
//
//  Created by Nathan Larson on 3/5/19.
//  Copyright © 2019 Nathan Larson. All rights reserved.
//

import Foundation

struct EventType {
    static let newInstall = "New Install"
    static let sessionStart = "Session Start"
    static let sessionEnd = "Session End"
    static let inAppPurchase = "In App Purchase"
}

class APIBuilder {
    
    static func requestForNewInstall(appId: String, apiKey: String, deviceId: String) -> URLRequest? {
        
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/pies-d01b8/databases/(default)/documents/Events/") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dictionary = ["name": "",
                          "fields": [
                            "appId": ["stringValue": appId],
                            "apiKey": ["stringValue": apiKey],
                            "eventType": ["stringValue": EventType.newInstall],
                            "deviceId": ["stringValue": deviceId],
                            "created": ["doubleValue": Date().timeIntervalSince1970]]] as [String : Any]
        
        var json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            PLog(error.localizedDescription)
            return nil
        }
        
        guard let jsonData = json else { return nil }
        request.httpBody = jsonData
        
        return request
    }
    
    static func requestForReInstall() -> URLRequest? {
        
        
        return nil
    }
    
    static func requestForSessionStart(appId: String, apiKey: String, deviceId: String) -> URLRequest? {
        
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/pies-d01b8/databases/(default)/documents/Events/") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dictionary = ["name": "",
                          "fields": [
                            "appId": ["stringValue": appId],
                            "apiKey": ["stringValue": apiKey],
                            "eventType": ["stringValue": EventType.sessionStart],
                            "deviceId": ["stringValue": deviceId],
                            "created": ["doubleValue": Date().timeIntervalSince1970]]] as [String : Any]
        
        var json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            PLog(error.localizedDescription)
            return nil
        }
        
        guard let jsonData = json else { return nil }
        request.httpBody = jsonData
        
        return request
    }
    
    static func requestForSessionEnd(appId: String, apiKey: String, deviceId: String) -> URLRequest? {
        
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/pies-d01b8/databases/(default)/documents/Events/") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dictionary = ["name": "",
                          "fields": [
                            "appId": ["stringValue": appId],
                            "apiKey": ["stringValue": apiKey],
                            "eventType": ["stringValue": EventType.sessionEnd],
                            "deviceId": ["stringValue": deviceId],
                            "created": ["doubleValue": Date().timeIntervalSince1970]]] as [String : Any]
        
        var json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            PLog(error.localizedDescription)
            return nil
        }
        
        guard let jsonData = json else { return nil }
        request.httpBody = jsonData
        
        return request
    }
    
    static func requestForIAP(appId: String, apiKey: String, deviceId: String, name: String, amount: Double) -> URLRequest? {
        
        guard let url = URL(string: "https://firestore.googleapis.com/v1/projects/pies-d01b8/databases/(default)/documents/Events/") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dictionary = ["name": "",
                          "fields": [
                            "appId": ["stringValue": appId],
                            "apiKey": ["stringValue": apiKey],
                            "eventType": ["stringValue": EventType.inAppPurchase],
                            "name": ["stringValue": name],
                            "amount": ["doubleValue": amount],
                            "deviceId": ["stringValue": deviceId],
                            "created": ["doubleValue": Date().timeIntervalSince1970]]] as [String : Any]
        
        var json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch {
            PLog(error.localizedDescription)
            return nil
        }
        
        guard let jsonData = json else { return nil }
        request.httpBody = jsonData
        
        return request
    }
}
