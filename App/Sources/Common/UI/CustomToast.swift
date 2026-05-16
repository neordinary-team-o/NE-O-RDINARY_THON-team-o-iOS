import SwiftUI

public enum CustomToastPosition {
    case leading
    case top
    case trailing
    case bottom

    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .top:
            return .top
        case .trailing:
            return .trailing
        case .bottom:
            return .bottom
        }
    }

    func hiddenOffset(distance: CGFloat) -> CGSize {
        switch self {
        case .leading:
            return CGSize(width: -distance, height: 0)
        case .top:
            return CGSize(width: 0, height: -distance)
        case .trailing:
            return CGSize(width: distance, height: 0)
        case .bottom:
            return CGSize(width: 0, height: distance)
        }
    }

    var scaleAnchor: UnitPoint {
        switch self {
        case .leading:
            return .leading
        case .top:
            return .top
        case .trailing:
            return .trailing
        case .bottom:
            return .bottom
        }
    }
}

public struct CustomToastModifier<ToastContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    let position: CustomToastPosition
    let edgePadding: CGFloat
    let dismissOnTap: Bool
    let autoHidden: Bool
    let toastContent: () -> ToastContent

    @State private var isMounted: Bool = false
    @State private var isVisible: Bool = false
    @State private var presentationID: UUID = UUID()

    private let animation: Animation = .easeInOut(duration: 0.28)
    private let offsetDistance: CGFloat = 24
    private let dismissDelay: Double = 0.28
    private let autoHideDelay: Double = 2.0

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: position.alignment) {
                if isMounted {
                    toastContent()
                        .padding(paddingEdges, edgePadding)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.98, anchor: position.scaleAnchor)
                        .offset(isVisible ? .zero : position.hiddenOffset(distance: offsetDistance))
                        .animation(animation, value: isVisible)
                        .onTapGesture {
                            if dismissOnTap {
                                isPresented = false
                            }
                        }
                        .zIndex(1_001)
                }
            }
            .zIndex(isMounted ? 1_000 : 0)
            .onAppear {
                syncPresentation(isPresented)
            }
            .onChange(of: isPresented) { newValue in
                syncPresentation(newValue)
            }
    }

    private var paddingEdges: Edge.Set {
        switch position {
        case .leading:
            return [.leading, .vertical]
        case .top:
            return [.top, .horizontal]
        case .trailing:
            return [.trailing, .vertical]
        case .bottom:
            return [.bottom, .horizontal]
        }
    }

    private func syncPresentation(_ show: Bool) {
        if show {
            if !isMounted {
                isMounted = true
            }

            DispatchQueue.main.async {
                withAnimation(animation) {
                    isVisible = true
                }
            }

            if autoHidden {
                let currentID = UUID()
                presentationID = currentID

                DispatchQueue.main.asyncAfter(deadline: .now() + autoHideDelay) {
                    if presentationID == currentID, isPresented {
                        isPresented = false
                    }
                }
            }
        } else {
            withAnimation(animation) {
                isVisible = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + dismissDelay) {
                if !isPresented {
                    isMounted = false
                }
            }
        }
    }
}

public extension View {
    func showToast<ToastContent: View>(
        isPresented: Binding<Bool>,
        position: CustomToastPosition = .bottom,
        edgePadding: CGFloat = 16,
        dismissOnTap: Bool = true,
        autoHidden: Bool = true,
        @ViewBuilder child: @escaping () -> ToastContent
    ) -> some View {
        modifier(
            CustomToastModifier(
                isPresented: isPresented,
                position: position,
                edgePadding: edgePadding,
                dismissOnTap: dismissOnTap,
                autoHidden: autoHidden,
                toastContent: child
            )
        )
    }
}
