import SwiftUI
import Architecture

public enum DistanceAction {
    case startingDateTapped
    case endingDateTapped
    case startingDateSelected(Date)
    case endingDateSelected(Date)
    case distanceResponse(Result<Double, DistanceError>)
    case closeAlert
}

public struct DistanceState {
    var startingDate: Date
    var endingDate: Date
    var isShowingStartingDate: Bool
    var isShowingEndingDate: Bool
    var errorAlert: ErrorAlert?
    var distance: String?

    public init(
        startingDate: Date = Date(),
        endingDate: Date = Date(),
        isShowingStartingDate: Bool = false,
        isShowingEndingDate: Bool = false,
        errorAlert: ErrorAlert? = nil,
        distance: String? = nil
    ) {
        self.startingDate = startingDate
        self.endingDate = endingDate
        self.isShowingStartingDate = isShowingStartingDate
        self.isShowingEndingDate = isShowingEndingDate
        self.errorAlert = errorAlert
        self.distance = distance
    }
}

public struct ErrorAlert: Identifiable, Equatable {
    public var id: String { self.message }
    let message: String
}

struct DistanceEnvironment {
    var getRunDistance: (Date, Date, @escaping (Result<Double, DistanceError>) -> Void) -> ()
}

extension DistanceEnvironment {
    static let live = DistanceEnvironment(getRunDistance: calculateRunDistance)
    static let mock = DistanceEnvironment(getRunDistance: { _, _, closure in closure(.success(10.25)) })
}

#if DEBUG
var Current = DistanceEnvironment.mock
#else
var Current = DistanceEnvironment.live
#endif

public func distanceReducer(state: inout DistanceState, action: DistanceAction) {
    switch action {
    case .startingDateTapped:
        state.isShowingStartingDate = !state.isShowingStartingDate
        state.isShowingEndingDate = false
    case .endingDateTapped:
        state.isShowingEndingDate = !state.isShowingEndingDate
        state.isShowingStartingDate = false
    case let .startingDateSelected(newDate):
        if state.endingDate.compare(newDate) == .orderedDescending {
            state.startingDate = newDate
        }
    case let .endingDateSelected(newDate):
        if state.startingDate.compare(newDate) == .orderedAscending {
            state.endingDate = newDate
        }
    case let .distanceResponse(response):
        switch response {
        case let .success(distance):
            state.distance = String(format: "%10.1f", distance)
        case let .failure(error):
            switch error {
            case .unknown:
                state.errorAlert = ErrorAlert(message: "Unknown error occured")
            case .empty:
                state.errorAlert = ErrorAlert(message: "No runs in the given date found")
            }
        }
    case .closeAlert:
        state.errorAlert = nil
    }
}

public struct DistanceView: View {
    @ObservedObject var store: Store<DistanceState, DistanceAction>

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    public init(store: Store<DistanceState, DistanceAction>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Starting Date: \(dateFormatter.string(from: store.value.startingDate))") {
                    withAnimation {
                        self.store.send(.startingDateTapped)
                    }
                }

                if store.value.isShowingStartingDate {
                    DatePicker(
                        "",
                        selection: self.store.send({ .startingDateSelected($0) }, bind: \.startingDate),
                        displayedComponents: .date
                    )
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .labelsHidden()
                }

                Button("Ending Date: \(dateFormatter.string(from: self.store.value.endingDate))") {
                    withAnimation {
                        self.store.send(.endingDateTapped)
                    }
                }

                if store.value.isShowingEndingDate {
                    DatePicker(
                        "",
                        selection: self.store.send({ .endingDateSelected($0) }, bind: \.endingDate),
                        displayedComponents: .date
                    )
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .labelsHidden()
                }

                Button("Get distance ran") {
                    Current.getRunDistance(self.store.value.startingDate, self.store.value.endingDate) { result in
                        withAnimation {
                            self.store.send(.distanceResponse(result))
                        }
                    }
                }

                store.value.distance.map { distance in
                    Text(distance + " Miles")
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            .navigationBarTitle("Distance Ran")
            .alert(
                item: self.store.send({ _ in .closeAlert }, bind: \.errorAlert)
            ) { alert in
                Alert(title: Text(alert.message))
            }
        }
    }
}

struct DistanceView_Preview: PreviewProvider {
    static var previews: some View {
        DistanceView(store: Store(initialValue: DistanceState(), reducer: distanceReducer))
    }
}
