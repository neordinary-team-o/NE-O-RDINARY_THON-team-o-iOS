//
//  Store.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import SwiftUI

typealias StoreOf<R: Reducer> = Store<R>

@MainActor
final class Store<R: Reducer>: ObservableObject {
    @Published private(set) var state: R.State

    private let reducer: R
    private var tasks: [AnyHashable: Task<Void, Never>] = [:]

    init(
        initialState: R.State,
        reducer: R
    ) {
        self.state = initialState
        self.reducer = reducer
    }

    @discardableResult
    func send(_ action: R.Action) -> StoreTask {
        let effect = reducer.reduce(&state, action)
        return handleEffect(effect)
    }
}

private extension Store {
    func handleEffect(_ effect: Effect<R.Action>) -> StoreTask {
        switch effect.operation {
        case .none:
            return StoreTask(rawValue: nil)

        case .cancel(let id):
            tasks[id]?.cancel()
            tasks[id] = nil
            return StoreTask(rawValue: nil)

        case .run(let priority, let operation):
            let task = Task(priority: priority) { [weak self] in
                await operation { action in
                    guard !Task.isCancelled else { return }
                    self?.send(action)
                }
            }

            if let cancellationID = effect.cancellationID {
                tasks[cancellationID]?.cancel()
                tasks[cancellationID] = task
            }

            return StoreTask(rawValue: task)
        }
    }
}
