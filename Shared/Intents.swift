import AppIntents
import Foundation

/// 잠금화면 카드의 체크 버튼. 앱 프로세스에서 실행된다.
struct ToggleTodoIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "할 일 체크"

    @Parameter(title: "id")
    var todoID: String

    init() {}
    init(todoID: String) { self.todoID = todoID }

    @MainActor
    func perform() async throws -> some IntentResult {
        if let id = UUID(uuidString: todoID) {
            TodoStore.shared.toggle(id: id)
        }
        return .result()
    }
}

/// 단축어 / 액션 버튼에서 호출하는 "할 일 추가"
struct AddTodoIntent: AppIntent {
    static var title: LocalizedStringResource = "할 일 추가"
    static var description = IntentDescription("앱을 열지 않고 할 일을 추가합니다.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "내용", requestValueDialog: "무슨 일을 할까요?")
    var text: String

    @MainActor
    func perform() async throws -> some IntentResult {
        TodoStore.shared.add(text)
        return .result()
    }
}
