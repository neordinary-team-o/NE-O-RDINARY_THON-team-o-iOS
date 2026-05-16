//
//  Logger.swift
//  App
//
//  Created by Jae hyung Kim on 3/15/26.
//

import SwiftyBeaver

public let Logger = SwiftyBeaver.self

public enum AppLogger {
    private static var isConfigured = false

    public static func configure() {
        guard !isConfigured else { return }

        let console = ConsoleDestination()
        console.minLevel = .debug
        console.format = "$DHH:mm:ss.SSS$d $L $M"

        Logger.addDestination(console)
        isConfigured = true
    }
}
