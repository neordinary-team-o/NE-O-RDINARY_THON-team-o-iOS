//
//  StoreTask.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct StoreTask {
    private let rawValue: Task<Void, Never>?

    init(rawValue: Task<Void, Never>?) {
        self.rawValue = rawValue
    }

    func cancel() {
        rawValue?.cancel()
    }

    func finish() async {
        await rawValue?.cancelValue
    }
}

private extension Task where Failure == Never {
    var cancelValue: Success {
        get async {
            await withTaskCancellationHandler {
                await value
            } onCancel: {
                cancel()
            }
        }
    }
}
