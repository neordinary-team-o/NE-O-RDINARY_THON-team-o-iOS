//
//  UserdefaultsManager.swift
//  App
//
//  Created by Jae hyung Kim on 3/15/26.
//

import Foundation

public final actor UserDefaultsManager {
    
    public enum Key: String {
        /// 디바이스 기준 처음 인지
        case firstDevice
        
        /// 루트 로그인 유저인지
        case rootLoginUser
        
        var value: String {
            return self.rawValue
        }
    }
    
    @UserDefaultsWrapper(key: Key.firstDevice.value, placeValue: true)
    public static var firstDevice: Bool
    
    @UserDefaultsWrapper(key: Key.rootLoginUser.value, placeValue: false)
    public static var rootLoginUser: Bool
}

extension UserDefaultsManager {
    
    public static func resetUser() {
        // If Need
    }
}

@propertyWrapper
public struct UserDefaultsWrapper<T: Codable> {
    public let key: String
    public let placeValue: T
    
    private let userDefaults = UserDefaults.standard
    
    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key),
                  let value = try? CodableManager.shared.jsonDecoding(model: T.self, from: data) else {
                return placeValue
            }
            return value
        } set {
            guard let data = try? CodableManager.shared.jsonEncoding(from: newValue)
            else {
                return
            }
            userDefaults.setValue(data, forKey: key)
        }
    }
}
