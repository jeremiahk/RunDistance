import HealthKit
import FunctionalHelpers

public enum DistanceError: Error {
    case unknown, empty
}

func calculateRunDistance(
    start: Date,
    end: Date,
    _ callback: @escaping (Result<Double, DistanceError>) -> Void
) {
    let store = HKHealthStore()

    let status = store.authorizationStatus(for: HKWorkoutType.workoutType())

    switch status {
    case .notDetermined:
        store.requestAuthorization(
            toShare: [],
            read: [HKObjectType.workoutType()],
            completion: { _, _ in
                calculateRunDistance(start: start, end: end, callback)
            }
        )
    default:
        let resultsHandler = runTotalSampleHandler(start: start, end: end, callback)

        HKSampleQuery(
            sampleType: .workoutType(),
            predicate: nil,
            limit: 1000,
            sortDescriptors: nil,
            resultsHandler: resultsHandler
        )
            |> store.execute
    }
}

private func runTotalSampleHandler(
    start: Date,
    end: Date,
    _ callback: @escaping (Result<Double, DistanceError>
) -> Void) -> (HKSampleQuery, [HKSample]?, Error?) -> Void {
    return { sampleQuery, results, error in
        guard error == nil else {
            callback(.failure(.unknown))
            return
        }

        guard let results = results as? [HKWorkout],
            results.count > 0 else {
                callback(.failure(.empty))
                return
        }

        results.filter { $0.workoutActivityType == .running }
            .filter {
                $0.startDate.compare(start) == .orderedDescending &&
                $0.startDate.compare(end) == .orderedAscending
            }
            .compactMap { $0.totalDistance?.doubleValue(for: .mile()) }
            .reduce(0, +)
            |> Result.success
            |> callback
    }
}
