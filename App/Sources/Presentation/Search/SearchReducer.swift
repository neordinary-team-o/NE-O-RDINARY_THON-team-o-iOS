//
//  SearchReducer.swift
//  App
//
//  Created by OpenCode on 5/17/26.
//

import Foundation

struct SearchReducer: Reducer {
    struct State: Equatable {
        var searchText: String
        var result: HomeSearchResultItem?
        var songSearchResponse: SongSearchResponseDTO?
        var isSearching: Bool
        var isCreatingDig: Bool
        var isChallengeStartPopupPresented: Bool
        var shouldNavigateBackToHome: Bool

        init(
            searchText: String = "",
            result: HomeSearchResultItem? = nil,
            songSearchResponse: SongSearchResponseDTO? = nil,
            isSearching: Bool = false,
            isCreatingDig: Bool = false,
            isChallengeStartPopupPresented: Bool = false,
            shouldNavigateBackToHome: Bool = false
        ) {
            self.searchText = searchText
            self.result = result
            self.songSearchResponse = songSearchResponse
            self.isSearching = isSearching
            self.isCreatingDig = isCreatingDig
            self.isChallengeStartPopupPresented = isChallengeStartPopupPresented
            self.shouldNavigateBackToHome = shouldNavigateBackToHome
        }
    }

    enum Action: Hashable {
        case searchTextChanged(String)
        case searchSubmitted
        case searchSucceeded(query: String, SongSearchResponseDTO?)
        case searchFailed(query: String)
        case discoverTapped
        case createDigSubmitted
        case createDigSucceeded
        case createDigFailed
        case challengeStartPopupDismissed
        case navigationBackToHomeHandled
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchTextChanged(text):
                state.searchText = text
                state.result = nil
                state.songSearchResponse = nil
                state.isSearching = false
                return .cancel(id: CancelID.searchSong)

            case .searchSubmitted:
                let query = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !query.isEmpty else {
                    state.result = nil
                    state.songSearchResponse = nil
                    state.isSearching = false
                    return .cancel(id: CancelID.searchSong)
                }

                state.isSearching = true

                return .run { send in
                    do {
                        let response = try await NetworkManager.shared.requestNetwork(
                            dto: SongSearchAPIResponseDTO.self,
                            router: AppNetworkRouter.searchSong(SongSearchRequestDTO(keyword: query))
                        )

                        guard response.success != false else {
                            await send(.searchFailed(query: query))
                            return
                        }

                        await send(.searchSucceeded(query: query, response.data))
                    } catch {
                        await send(.searchFailed(query: query))
                    }
                }
                .cancellable(id: CancelID.searchSong)

            case let .searchSucceeded(query, response):
                guard state.searchText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return .none }
                state.isSearching = false
                state.songSearchResponse = response
                state.result = Self.searchResult(from: response)
                return .none

            case let .searchFailed(query):
                guard state.searchText.trimmingCharacters(in: .whitespacesAndNewlines) == query else { return .none }
                state.isSearching = false
                state.songSearchResponse = nil
                state.result = nil
                return .none

            case .discoverTapped:
                state.isChallengeStartPopupPresented = true
                return .none

            case .createDigSubmitted:
                guard !state.isCreatingDig,
                      let request = Self.digCreateRequest(from: state.songSearchResponse)
                else { return .none }

                state.isCreatingDig = true

                return .run { send in
                    do {
                        let response = try await NetworkManager.shared.requestNetwork(
                            dto: DigCreateAPIResponseDTO.self,
                            router: AppNetworkRouter.createDig(request)
                        )

                        guard response.success != false else {
                            await send(.createDigFailed)
                            return
                        }

                        await send(.createDigSucceeded)
                    } catch {
                        await send(.createDigFailed)
                    }
                }
                .cancellable(id: CancelID.createDig)

            case .createDigSucceeded:
                state.isCreatingDig = false
                state.isChallengeStartPopupPresented = false
                state.shouldNavigateBackToHome = true
                return .none

            case .createDigFailed:
                state.isCreatingDig = false
                return .none

            case .challengeStartPopupDismissed:
                guard !state.isCreatingDig else { return .none }
                state.isChallengeStartPopupPresented = false
                return .none

            case .navigationBackToHomeHandled:
                state.shouldNavigateBackToHome = false
                return .none
            }
        }
    }

    private static func digCreateRequest(from response: SongSearchResponseDTO?) -> DigCreateRequestDTO? {
        guard let response,
              let title = response.title,
              let artist = response.artist,
              let viewCount = response.viewCount
        else { return nil }

        return DigCreateRequestDTO(
            userId: DeviceIDManager.userID,
            videoId: response.videoId,
            title: title,
            artist: artist,
            viewCount: viewCount,
            uploadDate: response.uploadDate,
            thumbnailUrl: response.thumbnailUrl
        )
    }

    private static func searchResult(from response: SongSearchResponseDTO?) -> HomeSearchResultItem? {
        guard let response else { return nil }

        let id = response.videoId ?? response.title ?? UUID().uuidString

        return HomeSearchResultItem(
            id: id,
            title: response.title ?? "",
            artist: response.artist ?? "",
            releasedAtText: releasedAtText(from: response.uploadDate),
            viewCountText: viewCountText(from: response.viewCount),
            artworkURL: URL(string: response.thumbnailUrl ?? "")
        )
    }

    private static func releasedAtText(from uploadDate: String?) -> String {
        guard let uploadDate else { return "" }

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"

        guard let date = inputFormatter.date(from: uploadDate) else {
            return uploadDate
        }

        return outputFormatter.string(from: date)
    }

    private static func viewCountText(from viewCount: Int64?) -> String {
        guard let viewCount else { return "" }
        return "\(viewCount.formatted())회"
    }
}

private enum CancelID: Hashable {
    case searchSong
    case createDig
}
