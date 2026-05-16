import SwiftUI

public enum CustomAlertDirection {
    case top
    case bottom
    case leading
    case trailing

    var edge: Edge {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

public enum CustomAlertAnimationStyle {
    case gentle
    case directional(CustomAlertDirection)

    var animation: Animation {
        switch self {
        case .gentle:
            return .easeInOut(duration: 0.35)
        case .directional:
            return .spring(response: 0.36, dampingFraction: 0.86)
        }
    }

    var dismissDelay: Double {
        switch self {
        case .gentle:
            return 0.35
        case .directional:
            return 0.36
        }
    }

    var hiddenScale: CGFloat {
        switch self {
        case .gentle:
            return 0.96
        case .directional:
            return 1
        }
    }

    func hiddenOffset(distance: CGFloat) -> CGSize {
        switch self {
        case .gentle:
            return .zero
        case .directional(let direction):
            switch direction {
            case .top:
                return CGSize(width: 0, height: -distance)
            case .bottom:
                return CGSize(width: 0, height: distance)
            case .leading:
                return CGSize(width: -distance, height: 0)
            case .trailing:
                return CGSize(width: distance, height: 0)
            }
        }
    }
}

public struct CustomAlertModifier<AlertContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    let dismissOnTap: Bool
    let animationStyle: CustomAlertAnimationStyle
    let alertContent: () -> AlertContent

    @State private var isMounted: Bool = false
    @State private var isVisible: Bool = false

    private let offsetDistance: CGFloat = 32

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isMounted {
                    ZStack {
                        Color.black
                            .opacity(isVisible ? 0.25 : 0)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if dismissOnTap {
                                    isPresented = false
                                }
                            }
                            .allowsHitTesting(isVisible)

                        alertContent()
                            .opacity(isVisible ? 1 : 0)
                            .scaleEffect(isVisible ? 1 : animationStyle.hiddenScale)
                            .offset(isVisible ? .zero : animationStyle.hiddenOffset(distance: offsetDistance))
                    }
                }
            }
            .animation(animationStyle.animation, value: isVisible)
            .onAppear {
                syncPresentation(isPresented)
            }
            .onChange(of: isPresented) { newValue in
                syncPresentation(newValue)
            }
    }

    private func syncPresentation(_ show: Bool) {
        if show {
            if !isMounted {
                isMounted = true
            }

            DispatchQueue.main.async {
                withAnimation(animationStyle.animation) {
                    isVisible = true
                }
            }
        } else {
            withAnimation(animationStyle.animation) {
                isVisible = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + animationStyle.dismissDelay) {
                if !isPresented {
                    isMounted = false
                }
            }
        }
    }
}

public extension View {
    func customAlert<AlertContent: View>(
        isPresented: Binding<Bool>,
        dismissOnTap: Bool = true,
        animationStyle: CustomAlertAnimationStyle = .gentle,
        @ViewBuilder child: @escaping () -> AlertContent
    ) -> some View {
        modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                dismissOnTap: dismissOnTap,
                animationStyle: animationStyle,
                alertContent: child
            )
        )
    }
}
