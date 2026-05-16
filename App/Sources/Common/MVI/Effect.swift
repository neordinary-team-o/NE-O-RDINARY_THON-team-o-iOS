//
//  Effect.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct Effect<Action: Hashable> {
    let operation: Operation
    let cancellationID: AnyHashable?

    private init(
        operation: Operation,
        cancellationID: AnyHashable? = nil
    ) {
        self.operation = operation
        self.cancellationID = cancellationID
    }

    enum Operation {
        case none
        case run(TaskPriority?, (@escaping (Action) async -> Void) async -> Void)
        case cancel(AnyHashable)
    }

    static var none: Self {
        Self(operation: .none)
    }

    static func run(
        priority: TaskPriority? = nil,
        operation: @escaping (@escaping (Action) async -> Void) async -> Void
    ) -> Self {
        Self(operation: .run(priority, operation))
    }

    static func cancel(id: some Hashable) -> Self {
        Self(operation: .cancel(AnyHashable(id)))
    }

    func cancellable(id: some Hashable) -> Self {
        switch operation {
        case .none, .cancel:
            return self
        case .run:
            return Self(operation: operation, cancellationID: AnyHashable(id))
        }
    }

    func cancelTask(id: some Hashable) -> Self {
        cancellable(id: id)
    }
}
