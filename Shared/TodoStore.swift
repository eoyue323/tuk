import Foundation
import SwiftUI

@MainActor
final class TodoStore: ObservableObject {
    static let shared = TodoStore()

    private let itemsKey = "tuk.items"
    private let addToTopKey = "tuk.addToTop"

    @Published private(set) var items: [TodoItem] = []
    @Published var addToTop: Bool {
        didSet { UserDefaults.standard.set(addToTop, forKey: addToTopKey) }
    }

    private init() {
        if UserDefaults.standard.object(forKey: addToTopKey) == nil {
            addToTop = false
        } else {
            addToTop = UserDefaults.standard.bool(forKey: addToTopKey)
        }
        if let data = UserDefaults.standard.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            items = decoded
        }
    }

    /// 화면·카드에 보여주는 순서: 미완료 먼저, 완료는 아래로
    var ordered: [TodoItem] {
        items.filter { !$0.done } + items.filter { $0.done }
    }

    func add(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let item = TodoItem(title: trimmed)
        if addToTop { items.insert(item, at: 0) } else { items.append(item) }
        commit()
    }

    func toggle(id: UUID) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].done.toggle()
        commit()
    }

    func delete(id: UUID) {
        items.removeAll { $0.id == id }
        commit()
    }

    func clearDone() {
        items.removeAll { $0.done }
        commit()
    }

    /// 미완료 목록 안에서의 순서 변경
    func movePending(from source: IndexSet, to destination: Int) {
        var pending = items.filter { !$0.done }
        let done = items.filter { $0.done }
        pending.move(fromOffsets: source, toOffset: destination)
        items = pending + done
        commit()
    }

    func syncLiveActivity() {
        let list = ordered
        Task { await LiveActivityManager.shared.sync(items: list) }
    }

    private func commit() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: itemsKey)
        }
        syncLiveActivity()
    }
}
