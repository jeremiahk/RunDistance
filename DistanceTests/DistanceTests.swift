import XCTest
@testable import Distance

class DistanceTests: XCTestCase {
    // Test can be written in a very common format. Or we can use a helper to make the tests much nicer to read.
    func testStartDateTapped() {
        let start = Date()
        let end = Date()

        var state = DistanceState(startingDate: start, endingDate: end, isShowingStartingDate: false, isShowingEndingDate: false)
        distanceReducer(state: &state, action: .startingDateTapped)
        XCTAssertEqual(state, DistanceState(startingDate: start, endingDate: end, isShowingStartingDate: true, isShowingEndingDate: false))

        distanceReducer(state: &state, action: .endingDateTapped)
        XCTAssertEqual(state, DistanceState(startingDate: start, endingDate: end, isShowingStartingDate: false, isShowingEndingDate: true))
    }

    func testEndDateTapped() {
        assert(
            initialValue: DistanceState(isShowingStartingDate: false, isShowingEndingDate: false),
            reducer: distanceReducer,
            steps:
            Step(.startingDateTapped) { $0.isShowingStartingDate = true },
            Step(.endingDateTapped) {
                $0.isShowingStartingDate = false
                $0.isShowingEndingDate = true
            }
        )
    }

    func testEndingDateSelected_EarlyerThenStartingDate() {
        assert(
            initialValue: DistanceState(isShowingStartingDate: false, isShowingEndingDate: false),
            reducer: distanceReducer,
            steps: Step(.endingDateSelected(Date(timeIntervalSince1970: 0))) { _ in }
        )
    }

    func testStartingDateSelected_EarlyerThenEndingDate() {
        let newDate = Date(timeIntervalSince1970: 0)

        assert(
            initialValue: DistanceState(isShowingStartingDate: false, isShowingEndingDate: false),
            reducer: distanceReducer,
            steps: Step(.startingDateSelected(newDate)) { $0.startingDate = newDate }
        )
    }

    func testAlertFlow() {
        assert(
            initialValue: DistanceState(isShowingStartingDate: false, isShowingEndingDate: false),
            reducer: distanceReducer,
            steps:
            Step(.distanceResponse(.failure(.empty))) { $0.errorAlert = ErrorAlert(message: "No runs in the given date found") },
            Step(.closeAlert) { $0.errorAlert = nil }
        )
    }
}
