import ActivityKit
import Foundation

@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private init() {}

    /// 카드에 담는 최대 항목 수 (Live Activity 데이터 4KB 제한 + 카드 높이 제한)
    private let maxRows = 5

    func sync(items: [TodoItem]) async {
        let state = TodoAttributes.ContentState(
            items: Array(items.prefix(maxRows)),
            pendingCount: items.filter { !$0.done }.count
        )
        let content = ActivityContent(state: state, staleDate: nil)

        if let activity = Activity<TodoAttributes>.activities.first {
            await activity.update(content)
        } else if ActivityAuthorizationInfo().areActivitiesEnabled {
            // 앱이 백그라운드면 시작이 거부될 수 있음 (iOS 제한)
            _ = try? Activity.request(attributes: TodoAttributes(), content: content, pushType: nil)
        }
    }

    func endAll() async {
        for activity in Activity<TodoAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
