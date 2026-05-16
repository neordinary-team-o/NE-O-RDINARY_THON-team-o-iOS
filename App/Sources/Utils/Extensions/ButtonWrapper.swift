//
//  ButtonWrapper.swift
//  ChartTest
//
//  Created by Jae hyung Kim on 3/12/26.
//

import SwiftUI

public struct ButtonWrapper<Style: PrimitiveButtonStyle>: ViewModifier {
    public let action: () -> Void
    public let haptic: Bool
    public let style: Style

    public init(
        haptic: Bool = false,
        style: Style,
        action: @escaping () -> Void
    ) {
        self.haptic = haptic
        self.style = style
        self.action = action
    }

    public func body(content: Content) -> some View {
        Button(
            action: {
                if haptic {
                    HapticFeedbackManager.shared.impact(style: .soft)
                }

                action()
            },
            label: {
                content
                    .contentShape(Rectangle())
                    .background(Color.clear)
            }
        )
        .buttonStyle(style)
    }
}

public struct LiquidGlassButtonWrapper: ViewModifier {
    
    public let type: LiquidGlassButtonStyleType
    
    public let action: () -> Void
    
    /// LiquidGlassButtonWrapper init
    /// - Parameters:
    ///   - action: callBack
    public init(
        type: LiquidGlassButtonStyleType = .glass,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            switch type {
            case .glass:
                button(content)
                    .buttonStyle(.glass)
            case .glassProminent:
                button(content)
                    .buttonStyle(.glassProminent)
            }
        } else {
            content
                .modifier(ButtonWrapper(style: PlainButtonStyle(), action: action))
        }
    }
    
    private func button(_ content: Content) -> some View {
        Button(
            action: action,
            label: {
                content
                    .contentShape(Rectangle())
                    .background(Color.clear)
            }
        )
    }
}

public enum LiquidGlassButtonStyleType {
    case glass
    case glassProminent
}
