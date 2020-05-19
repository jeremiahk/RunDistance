import XCTest
import Architecture

struct Step<Value, Action> {
    let action: Action
    let update: (inout Value) -> Void
    let file: StaticString
    let line: UInt

    init (
        _ action: Action,
        file: StaticString = #file,
        line: UInt = #line,
        _ update: @escaping (inout Value) -> Void
    ) {
        self.action = action
        self.update = update
        self.file = file
        self.line = line
    }
}

func assert<Value: Equatable, Action: Equatable>(
    initialValue: Value,
    reducer: Reducer<Value, Action>,
    steps: Step<Value, Action>...,
    file: StaticString = #file,
    line: UInt = #line
) {
    var currentState = initialValue

    steps.forEach { step in
        var expected = currentState
        reducer(&currentState, step.action)
        step.update(&expected)
        XCTAssertEqual(currentState, expected, file: step.file, line: step.line)
    }
}
