//
//  ExerciseReducer.swift
//  App
//
//  Created by Jae hyung Kim on 5/15/26.
//

import Foundation

struct ExerciseReducer: Reducer {
    struct State: Equatable {
        var selectedHeroIndex = 0
        var heroItems = HeroItem.mock
        var categories = CategoryItem.mock
        var stats = StatItem.mock
        var missions = MissionItem.mock
        var routines = RoutineItem.mock
        var meals = MealItem.mock
        var crews = CrewItem.mock
        var bodyMetrics = BodyMetricItem.mock
    }

    enum Action: Hashable {
        case onAppear
        case onDisappear
        case heroChanged(Int)
        case advanceHero
    }

    var reduce: ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    while !Task.isCancelled {
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        await send(.advanceHero)
                    }
                }
                .cancellable(id: CancelID.heroCarousel)

            case .onDisappear:
                return .cancel(id: CancelID.heroCarousel)

            case let .heroChanged(index):
                guard state.heroItems.indices.contains(index) else { return .none }
                state.selectedHeroIndex = index
                return .none

            case .advanceHero:
                guard !state.heroItems.isEmpty else { return .none }
                state.selectedHeroIndex = (state.selectedHeroIndex + 1) % state.heroItems.count
                return .none
            }
        }
    }
}

private enum CancelID: Hashable {
    case heroCarousel
}

struct HeroItem: Equatable, Hashable, Identifiable {
    let id: Int
    let imageURL: URL
    let badge: String
    let title: String
    let subtitle: String
}

extension HeroItem {
    static var mock: [HeroItem] {
        (0..<10).compactMap { index in
            URL(string: "https://picsum.photos/900/1200?random=\(Int.random(in: 30...999))").map {
            HeroItem(
                id: index,
                imageURL: $0,
                badge: index == 0 ? "Mission" : "Challenge",
                title: index == 0 ? "오늘의 건강 미션" : "오늘의 운동 루틴",
                subtitle: index == 0 ? "몸을 깨우는 하루 한 번의 움직임" : "내 몸에 맞춘 오늘의 움직임"
            )
            }
        }
    }
}

struct CategoryItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let icon: String
}

extension CategoryItem {
    static let mock: [CategoryItem] = [
        CategoryItem(id: 0, title: "게임", icon: "gamecontroller.fill"),
        CategoryItem(id: 1, title: "미션", icon: "flame.fill"),
        CategoryItem(id: 2, title: "챌린지", icon: "figure.walk"),
        CategoryItem(id: 3, title: "식단", icon: "fork.knife"),
        CategoryItem(id: 4, title: "크루", icon: "person.3.fill")
    ]
}

struct StatItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let value: String
    let icon: String
    let colorHex: String
    let progress: Double
}

extension StatItem {
    static let mock: [StatItem] = [
        StatItem(id: 0, title: "걸음", value: "3,560", icon: "shoeprints.fill", colorHex: "C8FF00", progress: 0.82),
        StatItem(id: 1, title: "분", value: "66", icon: "clock.fill", colorHex: "35C8FF", progress: 0.64),
        StatItem(id: 2, title: "Kcal", value: "231", icon: "flame.fill", colorHex: "FF2B8A", progress: 0.52)
    ]
}

struct MissionItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let isReward: Bool
}

extension MissionItem {
    static let mock: [MissionItem] = [
        MissionItem(id: 0, title: "출석 체크 완료하기", subtitle: "바로 500P 받아요!", icon: "calendar.badge.checkmark", isReward: true),
        MissionItem(id: 1, title: "하루 5,000보 걷기", subtitle: "바로 100P 받아요!", icon: "figure.walk", isReward: false),
        MissionItem(id: 2, title: "스포츠식스 퀴즈 풀기", subtitle: "바로 100P 받아요!", icon: "questionmark.bubble.fill", isReward: false)
    ]
}

struct RoutineItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let tag: String
    let colorHex: String
    let imageURL: URL
}

extension RoutineItem {
    static let mock: [RoutineItem] = [
        RoutineItem(id: 0, title: "데일리 상체 루틴", subtitle: "3세트 | 덤벨 숄더프레스", tag: "피트니스", colorHex: "B8FF00", imageURL: URL(string: "https://picsum.photos/160/160?random=80")!),
        RoutineItem(id: 1, title: "요가 스트레칭", subtitle: "1세트 | 전신 이완 동작 외 3종", tag: "요가", colorHex: "35C8FF", imageURL: URL(string: "https://picsum.photos/160/160?random=81")!),
        RoutineItem(id: 2, title: "체어 앤 바렐", subtitle: "1시간 | 상체/하체 집중 운동", tag: "필라테스", colorHex: "FF2B8A", imageURL: URL(string: "https://picsum.photos/160/160?random=82")!)
    ]
}

struct MealItem: Equatable, Hashable, Identifiable {
    let id: Int
    let type: String
    let kcal: String
    let menu: String
    let time: String
    let imageURL: URL
}

extension MealItem {
    static let mock: [MealItem] = [
        MealItem(id: 0, type: "식사", kcal: "350 kcal", menu: "샐러드와 곡물식빵", time: "오전 8:26", imageURL: URL(string: "https://picsum.photos/160/160?random=90")!),
        MealItem(id: 1, type: "간식", kcal: "150 kcal", menu: "두부과자", time: "오전 8:26", imageURL: URL(string: "https://picsum.photos/160/160?random=91")!)
    ]
}

struct CrewItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let imageURL: URL
}

extension CrewItem {
    static let mock: [CrewItem] = [
        CrewItem(id: 0, title: "청계천 야간 러닝 크루", subtitle: "종로구 | 200명", imageURL: URL(string: "https://picsum.photos/200/160?random=100")!)
    ]
}

struct BodyMetricItem: Equatable, Hashable, Identifiable {
    let id: Int
    let title: String
    let value: String
    let status: String
    let statusColorHex: String
}

extension BodyMetricItem {
    static let mock: [BodyMetricItem] = [
        BodyMetricItem(id: 0, title: "몸무게", value: "60.8 kg", status: "보통", statusColorHex: "00A94F"),
        BodyMetricItem(id: 1, title: "골격근량", value: "20 kg", status: "표준이하", statusColorHex: "9E1D2F"),
        BodyMetricItem(id: 2, title: "체지방율", value: "30 %", status: "표준이하", statusColorHex: "9E1D2F")
    ]
}
