//
//  HomeReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct HomeSearchResultItem: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let artist: String
    let releasedAtText: String
    let viewCountText: String
    let artworkURL: URL?
}

extension HomeSearchResultItem {
    static let mockGangnamStyle = HomeSearchResultItem(
        id: "search-gangnam-style",
        title: "강남스타일",
        artist: "PSY",
        releasedAtText: "12.07.15",
        viewCountText: "18,891회",
        artworkURL: URL(string: "https://picsum.photos/seed/cmc-gangnam-style/544/544")
    )
}

struct HomeReducer: Reducer {
    struct State: Equatable {
        var userName = "홍대병동"
        var searchText = ""
        var musicGridItems: [MusicGridItem] = []
        var selectedPickComplete: PickCompleteEntity?
    }

    enum Action: Hashable {
        case onAppear
        case searchTextChanged(String)
        case searchSubmitted
        case musicItemTapped(MusicGridItem)
        case pickCompleteDismissed
        case myDigsLoaded([MusicGridItem])
        case myDigsLoadFailed
        case pickCompleteLoaded(PickCompleteEntity)
        case pickCompleteLoadFailed
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return Self.loadMyDigsEffect()

            case let .searchTextChanged(text):
                state.searchText = text
                return .none

            case .searchSubmitted:
                let keyword = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !keyword.isEmpty else {
                    return Self.loadMyDigsEffect()
                }

                return .run { send in
                    do {
                        let response = try await NetworkManager.shared.requestNetwork(
                            dto: SearchMyDigsAPIResponseDTO.self,
                            router: AppNetworkRouter.searchMyDigs(userId: DeviceIDManager.userID, keyword: keyword)
                        )

                        guard response.success != false else {
                            await send(.myDigsLoadFailed)
                            return
                        }

                        await send(.myDigsLoaded(Self.musicGridItems(from: response.data ?? [])))
                    } catch {
                        await send(.myDigsLoadFailed)
                    }
                }

            case let .musicItemTapped(item):
                guard item.kind != .empty else { return .none }
                guard let digId = Int64(item.id) else { return .none }

                return .run { send in
                    do {
                        let growthRateResponse = try await NetworkManager.shared.requestNetwork(
                            dto: RefreshGrowthRateAPIResponseDTO.self,
                            router: AppNetworkRouter.refreshGrowthRate(digId: digId)
                        )

                        guard growthRateResponse.success != false else {
                            await send(.pickCompleteLoadFailed)
                            return
                        }

                        let response = try await NetworkManager.shared.requestNetwork(
                            dto: DigDetailAPIResponseDTO.self,
                            router: AppNetworkRouter.getDigDetail(digId: digId)
                        )

                        guard response.success != false,
                              let digDetail = response.data
                        else {
                            await send(.pickCompleteLoadFailed)
                            return
                        }

                        await send(.pickCompleteLoaded(Self.pickCompleteEntity(from: digDetail, id: item.id)))
                    } catch {
                        await send(.pickCompleteLoadFailed)
                    }
                }

            case .pickCompleteDismissed:
                state.selectedPickComplete = nil
                return .none

            case let .myDigsLoaded(items):
                state.musicGridItems = items
                return .none

            case .myDigsLoadFailed:
                state.musicGridItems = []
                return .none

            case let .pickCompleteLoaded(entity):
                state.selectedPickComplete = entity
                return .none

            case .pickCompleteLoadFailed:
                return .none

            }
        }
    }

    private static func loadMyDigsEffect() -> Effect<Action> {
        .run { send in
            do {
                let response = try await NetworkManager.shared.requestNetwork(
                    dto: MyDigsAPIResponseDTO.self,
                    router: AppNetworkRouter.getMyDigs(userId: DeviceIDManager.userID)
                )

                guard response.success != false,
                      let pageData = response.data
                else {
                    await send(.myDigsLoadFailed)
                    return
                }

                var digCards = pageData.content ?? []
                let totalPages = pageData.totalPages ?? 1

                if totalPages > 1 {
                    for page in 1..<totalPages {
                        let nextResponse = try await NetworkManager.shared.requestNetwork(
                            dto: MyDigsAPIResponseDTO.self,
                            router: AppNetworkRouter.getMyDigs(userId: DeviceIDManager.userID, page: page)
                        )

                        guard nextResponse.success != false else {
                            await send(.myDigsLoadFailed)
                            return
                        }

                        digCards.append(contentsOf: nextResponse.data?.content ?? [])
                    }
                }

                await send(.myDigsLoaded(Self.musicGridItems(from: digCards)))
            } catch {
                await send(.myDigsLoadFailed)
            }
        }
    }

    private static func musicGridItems(from digCards: [DigCardDTO]) -> [MusicGridItem] {
        digCards.enumerated().map { index, digCard in
            MusicGridItem(
                id: digCard.digId.map(String.init) ?? "dig-card-\(index)",
                title: digCard.title ?? "",
                imageURL: URL(string: digCard.thumbnailUrl ?? ""),
                discoveryPossibility: .mid,
                kind: .small
            )
        }
    }

    private static func musicGridItems(from digSearchResults: [DigSearchDTO]) -> [MusicGridItem] {
        digSearchResults.enumerated().map { index, digSearchResult in
            MusicGridItem(
                id: digSearchResult.digId.map(String.init) ?? "dig-search-result-\(index)",
                title: digSearchResult.title ?? "",
                imageURL: URL(string: digSearchResult.thumbnailUrl ?? ""),
                discoveryPossibility: .mid,
                kind: .small
            )
        }
    }

    private static func pickCompleteEntity(from detail: DigDetailDTO, id: String) -> PickCompleteEntity {
        let currentViewCountText = viewCountText(from: detail.currentViewCount)
        let elapsedTime = elapsedTimeText(from: detail.elapsedMonths)
        let narrativeMessage = detail.narrativeMessage ?? ""

        return PickCompleteEntity(
            id: id,
            artworkURL: URL(string: detail.thumbnailUrl ?? ""),
            fallbackImageName: nil,
            musicTitle: detail.title ?? "",
            artistName: detail.artistName ?? "",
            discoveredDateLabel: "발굴일",
            discoveredDate: dateText(from: detail.diggedAt),
            elapsedTime: elapsedTime,
            successDescription: narrativeMessage,
            descriptionHighlights: descriptionHighlights(from: narrativeMessage),
            previousViewCountLabel: "당시 조회수",
            previousViewCountText: viewCountText(from: detail.viewCountAtDig),
            currentViewCountLabel: "현재 조회수",
            currentViewCountText: currentViewCountText,
            growthRate: growthRateText(from: detail.growthRate),
            growthLabel: "성장률",
            trendPrefix: "당신은",
            trendLabel: detail.achievementName ?? ""
        )
    }

    private static func dateText(from value: String?) -> String {
        guard let value else { return "" }
        let dateText = String(value.prefix(10))

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"

        guard let date = inputFormatter.date(from: dateText) else {
            return dateText
        }

        return outputFormatter.string(from: date)
    }

    private static func elapsedTimeText(from elapsedMonths: Int64?) -> String {
        guard let elapsedMonths else { return "" }
        return "\(elapsedMonths)개월 경과"
    }

    private static func viewCountText(from viewCount: Int64?) -> String {
        guard let viewCount else { return "" }
        return "\(viewCount.formatted())회"
    }

    private static func growthRateText(from growthRate: Double?) -> String {
        guard let growthRate else { return "" }
        let sign = growthRate > 0 ? "+" : ""
        return "\(sign)\(growthRate.formatted(.number.precision(.fractionLength(0...3))))%"
    }

    private static func descriptionHighlights(from narrativeMessage: String) -> [String] {
        let patterns = [#"[0-9,]+만명"#, #"\d+개월"#]

        return patterns.compactMap { pattern in
            guard let range = narrativeMessage.range(of: pattern, options: .regularExpression) else {
                return nil
            }

            return String(narrativeMessage[range])
        }
    }
}
