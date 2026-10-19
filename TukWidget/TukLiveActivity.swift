import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct TukLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodoAttributes.self) { context in
            LockScreenCard(state: context.state)
                .activityBackgroundTint(Color.black.opacity(0.55))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    LockScreenCard(state: context.state)
                }
            } compactLeading: {
                Image(systemName: "checklist")
            } compactTrailing: {
                Text("\(context.state.pendingCount)")
            } minimal: {
                Text("\(context.state.pendingCount)")
            }
        }
    }
}

struct LockScreenCard: View {
    let state: TodoAttributes.ContentState

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("오늘 할 일").font(.caption.bold())
                Spacer()
                Text(state.pendingCount == 0 ? "다 했어요 🎉" : "\(state.pendingCount)개 남음")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if state.items.isEmpty {
                Text("앱이나 단축어로 할 일을 툭 적어보세요")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(state.items) { item in
                Button(intent: ToggleTodoIntent(todoID: item.id.uuidString)) {
                    HStack(spacing: 8) {
                        Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                            .font(.body)
                        Text(item.title)
                            .font(.subheadline)
                            .strikethrough(item.done)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .opacity(item.done ? 0.5 : 1)
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(.white)
        .padding(14)
    }
}
