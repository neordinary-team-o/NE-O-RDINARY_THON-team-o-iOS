//
//  Interceptor.swift
//  App
//
//  Created by Jae hyung Kim on 3/15/26.
//

import Foundation
import Alamofire

final class GBRequestInterceptor: RequestInterceptor {

    private let maxRetryCountPerRequest = 5

    private static let refreshCoordinator = RefreshCoordinator()

    private let retryDelay: TimeInterval = 1.0

    func adapt(_ urlRequest: URLRequest, for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest

        if let accessToken = AuthTokenStorage.accessToken {
            req.headers.add(.authorization(bearerToken: accessToken))
        }

        completion(.success(req))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping @Sendable (RetryResult) -> Void) {
        if UserDefaultsManager.rootLoginUser, isRefreshRequest(request) {
            // refresh 엔드포인트는 재시도 금지
            completion(.doNotRetry); return
        }

        // 요청 단위 상한
        if request.retryCount >= maxRetryCountPerRequest {
            completion(.doNotRetry); return
        }
        
        if let urlError = (error as? AFError)?.underlyingError as? URLError {
            switch urlError.code {
            case .networkConnectionLost:
                // -1005:
                completion(.retryWithDelay(retryDelay)); return
            default:
                break
            }
        }

        // HTTP 상태 확인
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry); return
        }

        // 401 --> 만료 처리
        if statusCode == 401 {
            // 리프레시 토큰 없으면 재시도 X
            guard AuthTokenStorage.refreshToken != nil else {
                completion(.doNotRetry); return
            }

            tryForRetry(completion: completion)
            
            return
        }

        // 그 외 상태코드: 재시도 안 함
        completion(.doNotRetry); return
    }

    private func isRefreshRequest(_ request: Request) -> Bool {
        guard let path = request.request?.url?.path else { return false }
        return path.contains("/auth/refresh")
    }

    private func tryForRetry(completion: @escaping @Sendable (RetryResult) -> Void) {
     
        Task {
            let refreshed = await refreshIfNeeded()

            if refreshed {
                completion(.retryWithDelay(retryDelay)); return
            } else {
                completion(.doNotRetry); return
            }
        }

    }
    
    // MARK: - Refresh
    private func refreshIfNeeded() async -> Bool {
        await Self.refreshCoordinator.refresh {
            if let result = try? await NetworkManager.shared.tryRefresh() {
                return result
            } else {
                return false
            }
        }
    }
}

private actor RefreshCoordinator {
    private var task: Task<Bool, Never>?

    func refresh(_ work: @escaping @Sendable () async -> Bool) async -> Bool {
        if let task { // 선요청 있을시 대기
            return await task.value
        }

        let task = Task { await work() }
        self.task = task
        let result = await task.value
        self.task = nil
        return result
    }
}
