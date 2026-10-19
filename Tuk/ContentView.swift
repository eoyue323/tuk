import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TodoStore
    @State private var draft = ""
    @FocusState private var inputFocused: Bool

    private var pending: [TodoItem] { store.items.filter { !$0.done } }
    private var done: [TodoItem] { store.items.filter { $0.done } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("할 일을 툭 적어요", text: $draft)
                            .focused($inputFocused)
                            .submitLabel(.done)
                            .onSubmit(add)
                        Button(action: add) {
                            Image(systemName: "plus.circle.fill").font(.title2)
                        }
                        .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                Section("오늘") {
                    ForEach(pending) { item in row(item) }
                        .onMove(perform: store.movePending)
                        .onDelete { offsets in
                            offsets.map { pending[$0].id }.forEach(store.delete)
                        }
                }

                if !done.isEmpty {
                    Section {
                        ForEach(done) { item in row(item) }
                            .onDelete { offsets in
                                offsets.map { done[$0].id }.forEach(store.delete)
                            }
                    } header: {
                        HStack {
                            Text("완료")
                            Spacer()
                            Button("비우기", action: store.clearDone).font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("툭!")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Toggle("새 할 일을 맨 위에", isOn: $store.addToTop)
                        Button("잠금화면 카드 다시 띄우기") { store.syncLiveActivity() }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }

    private func row(_ item: TodoItem) -> some View {
        Button {
            store.toggle(id: item.id)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.done ? Color.accentColor : .secondary)
                Text(item.title)
                    .strikethrough(item.done)
                    .foregroundStyle(item.done ? .secondary : .primary)
            }
        }
        .buttonStyle(.plain)
    }

    private func add() {
        store.add(draft)
        draft = ""
        inputFocused = true
    }
}
