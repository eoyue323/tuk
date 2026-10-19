import AppIntents

struct TukShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTodoIntent(),
            phrases: [
                "\(.applicationName)에 할 일 추가",
                "\(.applicationName) 적기"
            ],
            shortTitle: "할 일 추가",
            systemImageName: "plus.circle"
        )
    }
}
