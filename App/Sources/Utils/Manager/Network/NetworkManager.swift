//
//  NetworkManager.swift
//  App
//
//  Created by Jae hyung Kim on 3/15/26.
//

import Foundation
import Alamofire

@preconcurrency import Combine

public protocol DTO: Decodable, Sendable {}

public final class NetworkManager: Sendable, ThreadCheckable {
    
    private let networkError = PassthroughSubject<RouterError, Never>()
    
    private let cancelStoreActor = AnyValueActor(Set<AnyCancellable>())
    private let refreshRequestInterceptor: any RequestInterceptor = Alamofire.Interceptor.interceptor(
        interceptors: [
            GBRequestInterceptor(),
            RetryPolicy(retryLimit: 2)
        ]
    )
    
    public func requestNetwork<T: DTO, R: Router>(dto: T.Type, router: R) async throws(RouterError) -> T {
#if DEBUG
        checkedMainThread() // 현재 쓰레드 확인
#endif
        let request = try router.asURLRequest()
        logRequest(request)
        // MARK: 요청담당
        let response = await getRequest(dto: dto, router: router, request: request)
        
//        CodableManager.shared.toJSONSerialization(data: request.httpBody?)
        let result = try await getResponse(response: response)
        
        return result
    }
    
    public func requestNetworkWithRefresh<T:DTO, R: Router>(dto: T.Type, router: R) async throws(RouterError) -> T {
#if DEBUG
        checkedMainThread() // 현재 쓰레드 확인
#endif
        let request = try router.asURLRequest()
        logRequest(request)
        let ifRefreshMode = true
        
        // MARK: 요청담당
        let response = await getRequest(dto: dto, router: router, request: request, ifRefreshMode: ifRefreshMode)

        let result = try await getResponse(response: response)
        
        return result
    }
    
    @discardableResult
    public func requestNotDtoNetwork<R: Router>(router: R, ifRefreshNeed: Bool = false) async throws(RouterError) -> Bool {
#if DEBUG
        checkedMainThread() // 현재 쓰레드 확인
#endif
        let request = try router.asURLRequest()
        let accessCode: Set<Int> = Set(Array(200..<300))
        logRequest(request)
        
        // MARK: 요청담당
        let response: DataResponse<String, AFError>
        if ifRefreshNeed {
            response = await AF.request(request, interceptor: refreshRequestInterceptor)
                .validate(statusCode: 200..<300)
                .serializingString(emptyResponseCodes: accessCode)
                .response
        } else {
            response = await AF.request(request)
                .validate(statusCode: 200..<300)
                .serializingString(emptyResponseCodes: accessCode)
                .response
        }
        logStringResponse(response)
        
        switch response.result {
        case .success:
            return true
        case .failure:
            if accessCode.contains(response.response?.statusCode ?? 0) {
                return true
            }
            if let data = response.data {
                logResponseBody(data)
                let data = try? CodableManager.shared.jsonDecoding(model: ErrorDTO.self, from: data)
                Logger.warning(data ?? "")
                guard data?.code != nil else {
                    Logger.error(response.response?.statusCode ?? -999999)
                    throw RouterError.unknown(errorCode: String(response.response?.statusCode ?? -999999))
                }
                
                throw RouterError.unknown(errorCode: String(response.response?.statusCode ?? -999999))
            }
            guard response.response?.statusCode != nil else {
                Logger.error(response.response?.statusCode ?? -999999)
                networkError.send(RouterError.unknown(errorCode: String(response.response?.statusCode ?? -999999)))
                throw RouterError.unknown(errorCode: String(response.response?.statusCode ?? -999999))
            }
//            Logger.error(error)
            throw RouterError.unknown(errorCode: String(response.response?.statusCode ?? -999999))
        }
    }
    
    public func getNetworkError() -> AsyncStream<RouterError> {
        
        return AsyncStream<RouterError> { contin in
            Task {
                let subscribe = networkError
                    .sink { text in
                        contin.yield(text)
                    }
                
                await cancelStoreActor.withValue { value in
                    _ = value.insert(subscribe)
                }
            }
            
            contin.onTermination = { @Sendable [weak self] _ in
                guard let weakSelf = self else { return }
                Task {
                    await weakSelf.cancelStoreActor.resetValue()
                    contin.finish()
                }
            }
        }
    }
}

extension NetworkManager {
    // MARK: 요청담당
    private func getRequest<T: DTO, R: Router>(dto: T.Type, router: R, request: URLRequest, ifRefreshMode: Bool = false) async -> DataResponse<T, AFError> {
        
        if ifRefreshMode {
            let requestResponse = await AF.request(request, interceptor: refreshRequestInterceptor)
                .validate(statusCode: 200..<300)
                .cURLDescription {
                    Logger.info($0)
                }
                .serializingDecodable(T.self)
                .response
            logDecodableResponse(requestResponse)
            return requestResponse
        }
        else {
            let requestResponse = await AF.request(request)
                .validate(statusCode: 200..<300)
                .cURLDescription {
                    Logger.info($0)
                }
                .serializingDecodable(T.self)
                .response
            logDecodableResponse(requestResponse)
            return requestResponse
        }
    }
    
    // MARK: RE스폰스 담당
    private func getResponse<T: DTO>(response: DataResponse<T, AFError>) async throws(RouterError) -> T
    {
        switch response.result {
        case let .success(data):
            Logger.info(data)
            
            return data
        case let .failure(AFError):
            Logger.error(response.data?.base64EncodedString() ?? "")
            Logger.error(AFError)
            if AFError.isExplicitlyCancelledError {
                throw .cancel
            }

            let check = checkResponseData(response.data, AFError)
            networkError.send(check)
            throw check
        }
    }
    
    private func checkResponseData(
        _ responseData: Data?,
        _ : AFError
    ) -> RouterError {
        if responseData != nil {
            Logger.warning(responseData ?? "")
            return RouterError.decodingFail
        } else {
            return .unknown(errorCode: "999999")
        }
    }

    private func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "UNKNOWN"
        let url = request.url?.absoluteString ?? "nil"

        Logger.info("[REQUEST] [\(method)] \(url)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            Logger.debug("REQUEST HEADERS: \(headers)")
        }

        if let body = request.httpBody {
            Logger.debug("REQUEST BODY: \(body.prettyJSONString ?? body.utf8String ?? body.base64EncodedString())")
        }
    }

    private func logDecodableResponse<T>(_ response: DataResponse<T, AFError>) {
        let statusCode = response.response?.statusCode ?? -1
        let url = response.request?.url?.absoluteString ?? "nil"

        Logger.info("[RESPONSE] [\(statusCode)] \(url)")

        if let data = response.data {
            logResponseBody(data)
        }

        if let error = response.error {
            Logger.error("RESPONSE ERROR: \(error)")
        }
    }

    private func logStringResponse(_ response: DataResponse<String, AFError>) {
        let statusCode = response.response?.statusCode ?? -1
        let url = response.request?.url?.absoluteString ?? "nil"

        Logger.info("[RESPONSE] [\(statusCode)] \(url)")

        if let data = response.data {
            logResponseBody(data)
        } else if let value = response.value {
            Logger.debug("RESPONSE BODY: \(value)")
        }

        if let error = response.error {
            Logger.error("RESPONSE ERROR: \(error)")
        }
    }

    private func logResponseBody(_ data: Data) {
        Logger.debug("RESPONSE BODY: \(data.prettyJSONString ?? data.utf8String ?? data.base64EncodedString())")
    }
    
}

private extension Data {
    var utf8String: String? {
        String(data: self, encoding: .utf8)
    }

    var prettyJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
        else { return nil }

        return String(data: prettyData, encoding: .utf8)
    }
}

// MARK: 이미지 업로드
extension NetworkManager {
    
    public func uplaodMultipartRequest<D: DTO>(
        type: D.Type,
        router: Router
    ) async throws(RouterError) -> D {
        
        guard let url = try router.asURLRequest().url else {
            throw .urlFail(url: "uplaodMultipartRequest \(router)")
        }
        guard let multipartFormData = router.multipartFormData else {
            throw .urlFail(url: "NOT FOUND multipartFormData \(router)")
        }
        
        Logger.debug(multipartFormData)
        
        let request = await AF.upload(
            multipartFormData: multipartFormData,
            to: url,
            interceptor: refreshRequestInterceptor
        )
            .validate(statusCode: 200..<300)
            .cURLDescription {
                Logger.info($0)
            }
            .serializingDecodable(D.self)
            .response
        
        let response = try await getResponse(response: request)
        
        return response
    }
    
}

extension NetworkManager {
    
    public func ifNeedEscapingRequest<T: DTO, R: Router>(dto: T.Type, router: R, completion: @escaping @Sendable (Result<T, RouterError>) -> Void) {
        do {
            let urlRequest = try router.asURLRequest()
            AF.request(urlRequest)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: dto.self) { response in
                    switch response.result {
                        
                    case let .success(success):
                        completion(.success(success))
                        
                    case .failure(let error):
                        guard let status = error.responseCode else {
                            completion(.failure( RouterError.unknown(errorCode: "999")))
                            return
                        }
                        completion(.failure(.unknown(errorCode: String(status))))
                        
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
    
}

// MARK: Refresh
extension NetworkManager {
    @discardableResult
    public func tryRefresh() async throws -> Bool {
//        guard let refreshToken = AuthTokenStorage.refreshToken else { return false }
//        let result = try await requestNetwork(dto: AccessTokenDTO.self, router: AuthRouter.refresh(refreshToken: refreshToken))
//        
//        AuthTokenStorage.accessToken = result.accessToken
//        AuthTokenStorage.refreshToken = result.refreshToken
        return true
    }
}


extension NetworkManager {
    public static let shared = NetworkManager()
}


public struct ErrorDTO: DTO {
    let code: Int
    let message: String
}
