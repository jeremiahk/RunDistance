import SwiftUI

public typealias Reducer<Value, Action> = (inout Value, Action) -> Void

final public class Store<Value, Action>: ObservableObject {
    let reducer: Reducer<Value, Action>
    @Published public var value: Value

    public init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        reducer(&value, action)
    }

    public func send<LocalValue>(
        _ event: @escaping (LocalValue) -> Action,
        bind keyPath: KeyPath<Value, LocalValue>
    ) -> Binding<LocalValue> {
        Binding<LocalValue>(
            get: { self.value[keyPath: keyPath] },
            set: { value in self.send(event(value)) }
        )
    }
}
