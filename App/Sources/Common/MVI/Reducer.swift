//
//  Reducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

typealias ReducerOf<R: Reducer> = Reduce<R.State, R.Action>

protocol Reducer {
    associatedtype State: Equatable
    associatedtype Action: Hashable

    @MainActor var reduce: ReducerOf<Self> { get }
}

struct Reduce<State: Equatable, Action: Hashable> {
    private let reducer: @MainActor (inout State, Action) -> Effect<Action>

    init(_ reducer: @escaping @MainActor (inout State, Action) -> Effect<Action>) {
        self.reducer = reducer
    }

    init(_ reducer: @escaping @MainActor (inout State, Action) -> Void) {
        self.reducer = { state, action in
            reducer(&state, action)
            return .none
        }
    }

    @MainActor
    func callAsFunction(_ state: inout State, _ action: Action) -> Effect<Action> {
        reducer(&state, action)
    }
}
