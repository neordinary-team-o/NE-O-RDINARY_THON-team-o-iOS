//
//  AppFont.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

enum AppFont {
    static let title = AppFontStyle(size: 24, lineHeight: 32, letterSpacingEm: -0.023)
    static let heading = AppFontStyle(size: 20, lineHeight: 28, letterSpacingEm: -0.012)
    static let headline = AppFontStyle(size: 18, lineHeight: 26, letterSpacingEm: -0.002)
    static let bodyNormal = AppFontStyle(size: 16, lineHeight: 24, letterSpacingEm: 0.0057)
    static let bodyReading = AppFontStyle(size: 16, lineHeight: 26, letterSpacingEm: 0.0057)
    static let labelNormal = AppFontStyle(size: 14, lineHeight: 20, letterSpacingEm: 0.0145)
    static let labelReading = AppFontStyle(size: 14, lineHeight: 22, letterSpacingEm: 0.0145)
    static let caption = AppFontStyle(size: 12, lineHeight: 16, letterSpacingEm: 0.0252)
}

struct AppFontStyle: Equatable, Hashable {
    let size: CGFloat
    let lineHeight: CGFloat
    let letterSpacingEm: CGFloat

    var lineHeightRatio: CGFloat {
        guard size > 0 else { return 0 }
        return lineHeight / size
    }

    var lineSpacing: CGFloat {
        max(lineHeight - size, 0)
    }

    var letterSpacing: CGFloat {
        size * letterSpacingEm
    }

    func font(_ pretendardFont: PretendardFont = .regularFont) -> Font {
        pretendardFont.asFont(size: size)
    }
}

extension Text {
    func appFont(
        _ style: AppFontStyle,
        font pretendardFont: PretendardFont = .regularFont
    ) -> some View {
        self
            .font(style.font(pretendardFont))
            .tracking(style.letterSpacing)
            .lineSpacing(style.lineSpacing)
    }
}
