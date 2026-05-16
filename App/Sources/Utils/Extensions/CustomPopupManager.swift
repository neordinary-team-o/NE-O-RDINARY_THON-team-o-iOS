//
//  CustomPopupManager.swift
//  ChartTest
//
//  Created by Jae hyung Kim on 3/12/26.
//

import SwiftUI

public struct CustomPopupModified: ViewModifier {
    
    @Binding var isPresented: Bool
    
    let child: CustomPopupView
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                return child
            }
            .transaction { trans in
                trans.disablesAnimations = true
            }
    }
}

public struct CustomPopupView: View {
    
    let child : AnyView
    let dismissOnTap: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    
    public var body: some View {
        return ZStack {
            Color.black.opacity(0.2)
                .onTapGesture {
                    if (dismissOnTap) {
                        dismiss()
                    }
                }
            child
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ClearBackground())
    }
}


public extension View {
    func showAlert(isPresented: Binding<Bool>, child: @escaping () -> AnyView, dismissOnTap: Bool = true) -> some View {
        return modifier(
            CustomPopupModified(
                isPresented: isPresented,
                child: CustomPopupView(
                    child: child(),
                    dismissOnTap: dismissOnTap
                )
            )
        )
    }
    
    func showAlert(isPresented: Binding<Bool>, child: @escaping () -> some View, dismissOnTap: Bool = true) -> some View {
        let view = AnyView(child())
        return modifier(
            CustomPopupModified(
                isPresented: isPresented,
                child: CustomPopupView(
                    child: view,
                    dismissOnTap: dismissOnTap
                )
            )
        )
    }
}
