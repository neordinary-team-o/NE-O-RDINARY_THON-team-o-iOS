//
//  AppButtonStyles.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

public struct BounceButtonStyle: PrimitiveButtonStyle {
    public init() { }

    public func makeBody(configuration: Configuration) -> some View {
        Button(action: configuration.trigger) {
            configuration.label
        }
        .buttonStyle(BounceEffectButtonStyle())
    }
}

private struct BounceEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(
                .bouncy(duration: 0.24, extraBounce: 0.18),
                value: configuration.isPressed
            )
    }
}

public extension PrimitiveButtonStyle where Self == BounceButtonStyle {
    static var bounce: BounceButtonStyle { BounceButtonStyle() }
}
