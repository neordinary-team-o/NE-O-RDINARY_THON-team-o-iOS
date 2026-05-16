//
//  CommonTextField.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI
import UIKit

public struct CommonTextField: View {
    @Binding private var text: String
    private let placeHolder: String
    private let isActiveMode: Bool
    private let keyboardType: UIKeyboardType
    private let isSecure: Bool
    private let isSearch: Bool

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeHolder: String,
        isActiveMode: Bool = true,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        isSearch: Bool = false
    ) {
        self._text = text
        self.placeHolder = placeHolder
        self.isActiveMode = isActiveMode
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.isSearch = isSearch
    }

    public var body: some View {
        HStack(spacing: AppSpacing.xs) {
            if isSearch {
                Image(AppImages.searchIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            inputView
                .focused($isFocused)
                .keyboardType(keyboardType)
                .font(AppFont.bodyNormal.font())
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .tint(AppColor.GreenNormal.color)
        }
        .padding(.horizontal, AppSpacing.md + AppSpacing.xxs)
        .padding(.vertical, AppSpacing.md)
        .background(AppColor.GrayScale800.color, in: Capsule())
        .overlay {
            Capsule()
                .stroke(
                    isFocused && isActiveMode ? AppColor.GreenNormal.color : .clear,
                    lineWidth: 1
                )
        }
    }

    @ViewBuilder
    private var inputView: some View {
        if isSecure {
            SecureField("", text: $text, prompt: placeholderText)
        } else {
            TextField("", text: $text, prompt: placeholderText)
        }
    }

    private var placeholderText: Text {
        Text(placeHolder)
            .foregroundStyle(AppColor.GrayScale600.color)
    }
}

#if DEBUG
#Preview {
    CommonTextField(
        text: .constant(""),
        placeHolder: "예: 온라인 교육 플랫폼 만족도 조사",
        isActiveMode: true,
        keyboardType: .default,
        isSecure: false,
        isSearch: true
    )
    .padding(AppSpacing.md)
    .background(Color.black)
}
#endif
