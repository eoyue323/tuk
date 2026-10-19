import ActivityKit
import Foundation

struct TodoItem: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
    var done: Bool = false
}

struct TodoAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        /// 잠금화면 카드에 보여줄 항목 (미완료 먼저, 완료는 아래)
        var items: [TodoItem]
        var pendingCount: Int
    }
}
