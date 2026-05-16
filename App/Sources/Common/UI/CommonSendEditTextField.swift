//
//  CommonSendEditTextField.swift
//  App
//
//  Created by OpenCode on 5/16/26.
//

import SwiftUI
import UIKit

struct CommonSendEditTextField: View {
    @Binding private var text: String
    @Binding private var isCompleted: Bool

    private let placeHolder: String
    private let keyboardType: UIKeyboardType
    private let onSendTap: (String) -> Void
    private let onEditTap: () -> Void

    @FocusState private var isFocused: Bool

    init(
        text: Binding<String>,
        isCompleted: Binding<Bool>,
        placeHolder: String = "한줄평을 입력해주세요.",
        keyboardType: UIKeyboardType = .default,
        onSendTap: @escaping (String) -> Void,
        onEditTap: @escaping () -> Void = {}
    ) {
        self._text = text
        self._isCompleted = isCompleted
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        self.onSendTap = onSendTap
        self.onEditTap = onEditTap
    }

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.sm) {
            inputView
                .frame(maxWidth: .infinity, alignment: .leading)

            actionButton
        }
        .padding(.leading, CommonSendEditTextFieldLayout.leadingPadding)
        .padding(.trailing, AppSpacing.xs)
        .padding(.vertical, isMultiline ? AppSpacing.md : 0)
        .frame(minHeight: CommonSendEditTextFieldLayout.minHeight)
        .background(AppColor.GrayScale800.color, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(isFocused && !isCompleted ? AppColor.GreenNormal.color : .clear, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var inputView: some View {
        if isCompleted {
            Text(text.isEmpty ? placeHolder : text)
                .appFont(AppFont.bodyNormal)
                .foregroundStyle(text.isEmpty ? AppColor.GrayScale600.color : AppColor.GrayScaleWhite.color)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            TextField("", text: $text, prompt: placeholderText, axis: .vertical)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .font(AppFont.bodyNormal.font())
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .tint(AppColor.GreenNormal.color)
                .lineLimit(1...2)
                .submitLabel(.send)
                .onSubmit(performSendIfPossible)
        }
    }

    private var actionButton: some View {
        ZStack {
            Circle()
                .fill(actionBackgroundColor)

            Image(actionImage)
                .resizable()
                .scaledToFit()
                .frame(width: CommonSendEditTextFieldLayout.iconSize, height: CommonSendEditTextFieldLayout.iconSize)
        }
        .frame(width: CommonSendEditTextFieldLayout.buttonSize, height: CommonSendEditTextFieldLayout.buttonSize)
        .asButton(haptic: isActionEnabled) {
            handleActionTap()
        }
        .disabled(!isActionEnabled)
        .accessibilityLabel(actionAccessibilityLabel)
    }

    private var placeholderText: Text {
        Text(placeHolder)
            .foregroundStyle(AppColor.GrayScale600.color)
    }

    private var isActionEnabled: Bool {
        isCompleted || canSend
    }

    private var canSend: Bool {
        !trimmedText.isEmpty
    }

    private var isMultiline: Bool {
        text.contains("\n") || text.count > CommonSendEditTextFieldLayout.singleLineCharacterLimit
    }

    private var cornerRadius: CGFloat {
        isMultiline ? CommonSendEditTextFieldLayout.multilineRadius : CommonSendEditTextFieldLayout.singleLineRadius
    }

    private var actionImage: String {
        isCompleted ? AppImages.pencil : AppImages.arrowRight
    }

    private var actionBackgroundColor: Color {
        isActionEnabled ? AppColor.GreenNormal.color : AppColor.GrayScale600.color
    }

    private var actionAccessibilityLabel: String {
        isCompleted ? "수정" : "전송"
    }

    private var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func handleActionTap() {
        if isCompleted {
            isCompleted = false
            onEditTap()
            return
        }

        performSendIfPossible()
    }

    private func performSendIfPossible() {
        guard canSend else { return }
        onSendTap(trimmedText)
    }
}

private enum CommonSendEditTextFieldLayout {
    static let minHeight: CGFloat = 56
    static let buttonSize: CGFloat = 40
    static let iconSize: CGFloat = 20
    static let leadingPadding: CGFloat = 20
    static let singleLineRadius: CGFloat = 1000
    static let multilineRadius: CGFloat = 30
    static let singleLineCharacterLimit = 18
}

#if DEBUG
#Preview {
    VStack(spacing: AppSpacing.md) {
        CommonSendEditTextField(
            text: .constant(""),
            isCompleted: .constant(false),
            onSendTap: { _ in }
        )

        CommonSendEditTextField(
            text: .constant("낙엽"),
            isCompleted: .constant(false),
            onSendTap: { _ in }
        )

        CommonSendEditTextField(
            text: .constant("가진 게 없어도 함께라면 영원을 꿈꿀 수 있다는 위로."),
            isCompleted: .constant(true),
            onSendTap: { _ in }
        )
    }
    .padding(AppSpacing.md)
    .background(AppColor.GrayScaleBlack.color)
}
#endif
