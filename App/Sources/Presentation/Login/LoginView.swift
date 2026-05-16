//
//  LoginView.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

struct LoginView: View {
    let onLogin: () -> Void

    @State private var nickname = ""
    @State private var password = ""

    var body: some View {
        ZStack(alignment: .top) {
            background

            VStack(spacing: 0) {
                Spacer(minLength: AppSpacing.xxl + AppSpacing.xl)

                hero

                Spacer(minLength: AppSpacing.xxl + AppSpacing.lg)

                form
                    .padding(.horizontal, AppSpacing.md + AppSpacing.xxs)

                Spacer(minLength: AppSpacing.xxl)
            }
        }
    }

    private var background: some View {
        ZStack(alignment: .top) {
            AppColor.GrayScaleBlack.color
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    AppColor.GreenNormal.color.opacity(0.42),
                    AppColor.GreenNormalActive.color.opacity(0.26),
                    AppColor.GreenNormalActive.color.opacity(0.10),
                    AppColor.GreenNormal.color.opacity(0)
                ],
                center: .top,
                startRadius: AppSpacing.xs,
                endRadius: AppSpacing.xxl * 4
            )
            .frame(height: AppSpacing.xxl * 5)
            .blur(radius: AppSpacing.lg)
            .ignoresSafeArea(edges: .top)
        }
    }

    private var hero: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(AppImages.appLogo)
                .resizable()
                .scaledToFit()
                .aspectRatio(LoginLayout.logoAspectRatio, contentMode: .fit)
                .frame(maxWidth: LoginLayout.logoMaxWidth)
                .accessibilityLabel("앱 로고")

            Text("차트 병동에 갇히기엔\n당신의 안목이 너무 아깝잖아.")
                .appFont(AppFont.bodyNormal)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColor.GrayScale500.color)
                .accessibilityLabel("차트 병동에 갇히기엔 당신의 안목이 너무 아깝잖아.")
        }
        .frame(maxWidth: .infinity)
    }

    private var form: some View {
        VStack(spacing: AppSpacing.xxl) {
            VStack(spacing: AppSpacing.md) {
                loginField(
                    title: "닉네임",
                    placeholder: "닉네임을 입력해주세요.",
                    text: $nickname,
                    isSecure: false
                )

                loginField(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력해주세요.",
                    text: $password,
                    isSecure: true
                )
            }

            ctaButton
        }
        .frame(maxWidth: .infinity)
    }

    private func loginField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .appFont(AppFont.labelNormal, font: .semiFont)
                .foregroundStyle(AppColor.GrayScaleWhite.color)

            inputField(placeholder: placeholder, text: text, isSecure: isSecure)
                .font(AppFont.bodyNormal.font())
                .foregroundStyle(AppColor.GrayScaleWhite.color)
                .tint(AppColor.GreenNormal.color)
                .padding(.horizontal, AppSpacing.md + AppSpacing.xxs)
                .padding(.vertical, AppSpacing.md)
                .background(fieldBackground, in: Capsule())
        }
    }

    @ViewBuilder
    private func inputField(
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        if isSecure {
            SecureField("", text: text, prompt: placeholderText(placeholder))
        } else {
            TextField("", text: text, prompt: placeholderText(placeholder))
        }
    }

    private func placeholderText(_ placeholder: String) -> Text {
        Text(placeholder)
            .foregroundStyle(AppColor.GrayScale600.color)
    }

    private var fieldBackground: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: AppColor.GrayScale800.color.opacity(0.35), location: 0),
                .init(color: AppColor.GrayScale800.color, location: 0.5),
                .init(color: AppColor.GrayScale800.color.opacity(0.35), location: 1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var ctaButton: some View {
        Text("발굴 시작하기")
            .appFont(AppFont.headline, font: .semiFont)
            .foregroundStyle(AppColor.GrayScaleBlack.color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(ctaGradient, in: Capsule())
            .contentShape(Capsule())
            .asButton(haptic: true, action: onLogin)
            .accessibilityAddTraits(.isButton)
    }

    private var ctaGradient: LinearGradient {
        LinearGradient(
            colors: [
                AppColor.GreenNormalActive.color,
                AppColor.GreenNormal.color,
                AppColor.GreenNormalActive.color
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private enum LoginLayout {
    static let logoMaxWidth: CGFloat = 160
    static let logoAspectRatio: CGFloat = 160 / 38.22
}

#Preview {
    LoginView { }
}
