//
//  AppColor.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI

enum AppColor {
    static let GrayScaleBlack = AppColorToken(hexCode: "#111111")
    static let GrayScale900 = AppColorToken(hexCode: "#212121")
    static let GrayScale800 = AppColorToken(hexCode: "#2C2C32")
    static let GrayScale700 = AppColorToken(hexCode: "#424248")
    static let GrayScale600 = AppColorToken(hexCode: "#83838B")
    static let GrayScale500 = AppColorToken(hexCode: "#98979F")
    static let GrayScale400 = AppColorToken(hexCode: "#B5B5BB")
    static let GrayScale300 = AppColorToken(hexCode: "#C8C8D1")
    static let GrayScale200 = AppColorToken(hexCode: "#DADAE3")
    static let GrayScale100 = AppColorToken(hexCode: "#F9F9FD")
    static let GrayScaleWhite = AppColorToken(hexCode: "#FFFFFF")

    static let GreenLight = AppColorToken(hexCode: "#E6FFF0")
    static let GreenLightHover = AppColorToken(hexCode: "#D9FFE8")
    static let GreenLightActive = AppColorToken(hexCode: "#B1FFD0")
    static let GreenNormal = AppColorToken(hexCode: "#03FF67")
    static let GreenNormalHover = AppColorToken(hexCode: "#03E65D")
    static let GreenNormalActive = AppColorToken(hexCode: "#02CC52")
    static let GreenDark = AppColorToken(hexCode: "#02BF4D")
    static let GreenDarkHover = AppColorToken(hexCode: "#02993E")
    static let GreenDarkActive = AppColorToken(hexCode: "#01732E")
    static let GreenDarker = AppColorToken(hexCode: "#015924")

    static let SemanticRedLight = AppColorToken(hexCode: "#FFE6EA")
    static let SemanticRedLightHover = AppColorToken(hexCode: "#FFD9E0")
    static let SemanticRedLightActive = AppColorToken(hexCode: "#FFB0BE")
    static let SemanticRedNormal = AppColorToken(hexCode: "#FF002D")
    static let SemanticRedNormalHover = AppColorToken(hexCode: "#E60029")
    static let SemanticRedNormalActive = AppColorToken(hexCode: "#CC0024")
    static let SemanticRedDark = AppColorToken(hexCode: "#BF0022")
    static let SemanticRedDarkHover = AppColorToken(hexCode: "#99001B")
    static let SemanticRedDarkActive = AppColorToken(hexCode: "#730014")
    static let SemanticRedDarker = AppColorToken(hexCode: "#590010")
}

struct AppColorToken {
    let uiColor: UIColor

    var color: Color {
        Color(uiColor: uiColor)
    }

    init(hexCode: String) {
        self.uiColor = UIColor(hexCode: hexCode)
    }
}
