//
//  NavRouter.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

@MainActor
protocol NavRouter {
    func push(_ route: AppRoute)
    func pop()
    func popLast(_ count: Int)
    func popToRoot()
    func popTo(_ route: AppRoute)
    func replace(with routes: [AppRoute])
}

@MainActor
struct AppRouter: NavRouter {
    let pushAction: @MainActor (AppRoute) -> Void
    let popAction: @MainActor () -> Void
    let popLastAction: @MainActor (Int) -> Void
    let popToRootAction: @MainActor () -> Void
    let popToAction: @MainActor (AppRoute) -> Void
    let replaceAction: @MainActor ([AppRoute]) -> Void

    static let empty = AppRouter(
        pushAction: { _ in },
        popAction: { },
        popLastAction: { _ in },
        popToRootAction: { },
        popToAction: { _ in },
        replaceAction: { _ in }
    )

    func push(_ route: AppRoute) {
        pushAction(route)
    }

    func pop() {
        popAction()
    }

    func popLast(_ count: Int) {
        popLastAction(count)
    }

    func popToRoot() {
        popToRootAction()
    }

    func popTo(_ route: AppRoute) {
        popToAction(route)
    }

    func replace(with routes: [AppRoute]) {
        replaceAction(routes)
    }
}
