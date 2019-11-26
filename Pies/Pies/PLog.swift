//
//  PLog.swift
//  Pies
//
//  Created by Nathan Larson on 3/5/19.
//  Copyright © 2019 Nathan Larson. All rights reserved.
//

import Foundation

func PLog(_ message: String, file: String = #file, line: Int = #line, function: String = #function) {
    #if DEBUG
    var filename = ""
    if let file = file.split(separator: "/").last {
        filename = String(file)
    }
    if PiesHelper.shared.loggingEnabled {
        print("\n----------\n\nMessage: \(message)\nFunction: \(function)\nLine: \(line)\nFilename: \(filename)\n\n----------\n")
    }
    #endif
}
