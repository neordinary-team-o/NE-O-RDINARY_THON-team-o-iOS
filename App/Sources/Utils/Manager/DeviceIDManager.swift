//
//  DeviceIDManager.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation
import UIKit

enum DeviceIDManager {
    private static let fallbackDeviceIDKey = "fallbackDeviceID"

    static var userID: Int64 {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? fallbackDeviceID
        return stablePositiveInt64(from: deviceID)
    }

    private static var fallbackDeviceID: String {
        if let savedID = UserDefaults.standard.string(forKey: fallbackDeviceIDKey) {
            return savedID
        }

        let newID = UUID().uuidString
        UserDefaults.standard.set(newID, forKey: fallbackDeviceIDKey)
        return newID
    }

    private static func stablePositiveInt64(from value: String) -> Int64 {
        var hash: UInt64 = 14_695_981_039_346_656_037

        for byte in value.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1_099_511_628_211
        }

        return Int64(hash & 0x7FFF_FFFF_FFFF_FFFF)
    }
}
