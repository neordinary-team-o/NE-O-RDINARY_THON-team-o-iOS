import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(WatchKit)
import WatchKit
#endif

public enum CustomDropDownDirection {
    case automatic
    case up
    case down
}

public struct CustomDropDownMenu<Trigger: View, Child: View>: View {

    private let preferredDirection: CustomDropDownDirection
    private let triggerGap: CGFloat
    private let dismissOnTapOutside: Bool
    private let trigger: () -> Trigger
    private let child: () -> Child

    @State private var isPresented: Bool = false
    @State private var isMounted: Bool = false
    @State private var isVisible: Bool = false

    @State private var containerFrame: CGRect = .zero
    @State private var triggerFrame: CGRect = .zero
    @State private var childSize: CGSize = .zero

    private let animationDuration: Double = 0.24

    public init(
        preferredDirection: CustomDropDownDirection = .automatic,
        triggerGap: CGFloat = 8,
        dismissOnTapOutside: Bool = true,
        @ViewBuilder trigger: @escaping () -> Trigger,
        @ViewBuilder child: @escaping () -> Child
    ) {
        self.preferredDirection = preferredDirection
        self.triggerGap = triggerGap
        self.dismissOnTapOutside = dismissOnTapOutside
        self.trigger = trigger
        self.child = child
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Button {
                    isPresented.toggle()
                } label: {
                    trigger()
                }
                .buttonStyle(.plain)
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: DropDownTriggerFramePreferenceKey.self,
                                value: proxy.frame(in: .global)
                            )
                    }
                }

                if isMounted {
                    Rectangle()
                        .fill(Color.black.opacity(isVisible ? 0.001 : 0))
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            if dismissOnTapOutside {
                                isPresented = false
                            }
                        }
                        .allowsHitTesting(isVisible)

                    child()
                        .background {
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(
                                        key: DropDownChildSizePreferenceKey.self,
                                        value: proxy.size
                                    )
                            }
                        }
                        .fixedSize()
                        .offset(x: childOffsetX, y: childOffsetY)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.98, anchor: childAnchor)
                        .animation(.easeInOut(duration: animationDuration), value: isVisible)
                }
            }
            .background {
                Color.clear
                    .preference(
                        key: DropDownContainerFramePreferenceKey.self,
                        value: geometry.frame(in: .global)
                    )
            }
            .onAppear {
                syncPresentation(isPresented)
            }
            .onChange(of: isPresented) { newValue in
                syncPresentation(newValue)
            }
            .onPreferenceChange(DropDownContainerFramePreferenceKey.self) { newFrame in
                containerFrame = newFrame
            }
            .onPreferenceChange(DropDownTriggerFramePreferenceKey.self) { newFrame in
                triggerFrame = newFrame
            }
            .onPreferenceChange(DropDownChildSizePreferenceKey.self) { newSize in
                childSize = newSize
            }
        }
    }

    private var resolvedDirection: CustomDropDownDirection {
        let triggerInContainer = normalizedTriggerFrame
        let childHeight = childSize.height
        let requiredHeight = childHeight + triggerGap

        let availableTop = triggerInContainer.minY
        let availableBottom = containerFrame.height - triggerInContainer.maxY

        switch preferredDirection {
        case .up:
            if availableTop >= requiredHeight || availableTop >= availableBottom {
                return .up
            }
            return .down
        case .down:
            if availableBottom >= requiredHeight || availableBottom >= availableTop {
                return .down
            }
            return .up
        case .automatic:
            if availableBottom >= requiredHeight || availableBottom >= availableTop {
                return .down
            }
            return .up
        }
    }

    private var normalizedTriggerFrame: CGRect {
        CGRect(
            x: triggerFrame.minX - containerFrame.minX,
            y: triggerFrame.minY - containerFrame.minY,
            width: triggerFrame.width,
            height: triggerFrame.height
        )
    }

    private var childOffsetX: CGFloat {
        let triggerInContainer = normalizedTriggerFrame
        let preferredX = triggerInContainer.minX
        let maxX = max(containerFrame.width - childSize.width, 0)
        return min(max(preferredX, 0), maxX)
    }

    private var childOffsetY: CGFloat {
        let triggerInContainer = normalizedTriggerFrame

        switch resolvedDirection {
        case .down, .automatic:
            return triggerInContainer.maxY + triggerGap
        case .up:
            return max(0, triggerInContainer.minY - childSize.height - triggerGap)
        }
    }

    private var childAnchor: UnitPoint {
        switch resolvedDirection {
        case .down, .automatic:
            return .top
        case .up:
            return .bottom
        }
    }

    private func syncPresentation(_ show: Bool) {
        if show {
            if !isMounted {
                isMounted = true
            }

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    isVisible = true
                }
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isVisible = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                if !isPresented {
                    isMounted = false
                }
            }
        }
    }
}

public struct ShowDropDownModifier<DropDownContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    let preferredDirection: CustomDropDownDirection
    let triggerGap: CGFloat
    let dismissOnTapOutside: Bool
    let child: () -> DropDownContent

    @State private var isMounted: Bool = false
    @State private var isVisible: Bool = false

    @State private var triggerFrame: CGRect = .zero
    @State private var triggerSize: CGSize = .zero
    @State private var childSize: CGSize = .zero

    private let animationDuration: Double = 0.24

    public func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: DropDownTriggerFramePreferenceKey.self,
                            value: proxy.frame(in: .global)
                        )
                        .preference(
                            key: DropDownTriggerSizePreferenceKey.self,
                            value: proxy.size
                        )
                }
            }
            .overlay(alignment: .topLeading) {
                if isMounted {
                    child()
                        .background {
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(
                                        key: DropDownChildSizePreferenceKey.self,
                                        value: proxy.size
                                    )
                            }
                        }
                        .fixedSize()
                        .offset(x: childOffsetX, y: childOffsetY)
                        .opacity(isVisible ? 1 : 0)
                        .scaleEffect(isVisible ? 1 : 0.98, anchor: childAnchor)
                        .animation(.easeInOut(duration: animationDuration), value: isVisible)
                        .zIndex(1_001)
                }
            }
            .onAppear {
                syncPresentation(isPresented)
            }
            .onChange(of: isPresented) { newValue in
                syncPresentation(newValue)
            }
            .onPreferenceChange(DropDownTriggerFramePreferenceKey.self) { newFrame in
                triggerFrame = newFrame
            }
            .onPreferenceChange(DropDownTriggerSizePreferenceKey.self) { newSize in
                triggerSize = newSize
            }
            .onPreferenceChange(DropDownChildSizePreferenceKey.self) { newSize in
                childSize = newSize
            }
            .zIndex(isMounted ? 1_000 : 0)
    }

    private var resolvedDirection: CustomDropDownDirection {
        let requiredHeight = childSize.height + triggerGap
        let screenHeight = screenBoundsHeight
        let availableTop = triggerFrame.minY
        let availableBottom = screenHeight - triggerFrame.maxY

        switch preferredDirection {
        case .up:
            if availableTop >= requiredHeight || availableTop >= availableBottom {
                return .up
            }
            return .down
        case .down:
            if availableBottom >= requiredHeight || availableBottom >= availableTop {
                return .down
            }
            return .up
        case .automatic:
            if availableBottom >= requiredHeight || availableBottom >= availableTop {
                return .down
            }
            return .up
        }
    }

    private var childOffsetX: CGFloat {
        let horizontalInset: CGFloat = 12
        let screenWidth = screenBoundsWidth
        let maxX = max(horizontalInset, screenWidth - childSize.width - horizontalInset)
        let clampedGlobalX = min(max(triggerFrame.minX, horizontalInset), maxX)
        return clampedGlobalX - triggerFrame.minX
    }

    private var screenBoundsWidth: CGFloat {
#if canImport(UIKit)
        return UIScreen.main.bounds.width
#elseif canImport(WatchKit)
        return WKInterfaceDevice.current().screenBounds.width
#else
        return max(triggerFrame.maxX + childSize.width, 1)
#endif
    }

    private var screenBoundsHeight: CGFloat {
#if canImport(UIKit)
        return UIScreen.main.bounds.height
#elseif canImport(WatchKit)
        return WKInterfaceDevice.current().screenBounds.height
#else
        return max(triggerFrame.maxY + childSize.height, 1)
#endif
    }

    private var childOffsetY: CGFloat {
        switch resolvedDirection {
        case .down, .automatic:
            return triggerHeightForOffset + triggerGap
        case .up:
            return -(childSize.height + triggerGap)
        }
    }

    private var triggerHeightForOffset: CGFloat {
        let measured = max(triggerSize.height, triggerFrame.height)
        return measured > 0 ? measured : 24
    }

    private var childAnchor: UnitPoint {
        switch resolvedDirection {
        case .down, .automatic:
            return .top
        case .up:
            return .bottom
        }
    }

    private func syncPresentation(_ show: Bool) {
        if show {
            if !isMounted {
                isMounted = true
            }

            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    isVisible = true
                }
            }
        } else {
            withAnimation(.easeInOut(duration: animationDuration)) {
                isVisible = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                if !isPresented {
                    isMounted = false
                }
            }
        }
    }
}

public extension View {
    func showDropDown<DropDownContent: View>(
        isPresented: Binding<Bool>,
        preferredDirection: CustomDropDownDirection = .automatic,
        triggerGap: CGFloat = 8,
        dismissOnTapOutside: Bool = true,
        @ViewBuilder child: @escaping () -> DropDownContent
    ) -> some View {
        modifier(
            ShowDropDownModifier(
                isPresented: isPresented,
                preferredDirection: preferredDirection,
                triggerGap: triggerGap,
                dismissOnTapOutside: dismissOnTapOutside,
                child: child
            )
        )
    }
}

private struct DropDownContainerFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

private struct DropDownTriggerFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

private struct DropDownTriggerSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct DropDownChildSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
