import SwiftUI

@main
struct TukApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = TodoStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: scenePhase) { _, phase in
            // 앱이 앞으로 올 때마다 카드를 다시 띄우거나 갱신 (8시간 제한 대비)
            if phase == .active { store.syncLiveActivity() }
        }
    }
}
