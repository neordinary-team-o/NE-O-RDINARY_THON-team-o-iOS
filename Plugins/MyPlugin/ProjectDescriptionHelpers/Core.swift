//
//  Core.swift
//  MyPlugin
//
//  Created by Jae hyung Kim on 3/12/26.
//

import Foundation
import ProjectDescription

// MARK: UI
public extension TargetDependency {
    
    static let popupView: Self = .external(name: "PopupView", condition: nil)
    static let imageCompressor: Self = .external(name: "SwiftImageCompressor", condition: .none)
    static let alamofire: Self = .external(name: "Alamofire", condition: .none)
    static let swiftyBeaver: Self = .external(name: "SwiftyBeaver", condition: .none)
    static let kingFisher: Self = .external(name: "Kingfisher", condition: .none)
}
