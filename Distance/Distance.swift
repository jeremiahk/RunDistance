import SwiftUI

public struct DistanceView: View {
    @State private var startingDate: Date = Date()
    @State private var endingDate: Date = Date()
    @State private var isShowingStartingDate = false
    @State private var isShowingEndingDate = false
    @State private var distanceText: String?
    @State private var displayError: Bool = false
    @State private var error: String?

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    public init() {}

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Starting Date: \(dateFormatter.string(from: startingDate))") {
                    withAnimation {
                        if (self.isShowingEndingDate) { self.isShowingEndingDate = false}
                        self.isShowingStartingDate.toggle()
                    }
                }

                if isShowingStartingDate {
                    DatePicker("", selection: $startingDate, displayedComponents: .date)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .labelsHidden()
                }

                Button("Ending Date: \(dateFormatter.string(from: endingDate))") {
                    withAnimation {
                        if (self.isShowingStartingDate) { self.isShowingStartingDate = false}
                        self.isShowingEndingDate.toggle()
                    }
                }

                if isShowingEndingDate {
                    DatePicker("", selection: $endingDate, displayedComponents: .date)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .labelsHidden()
                }

                Button("Get distance ran") {
                    calculateRunDistance(start: self.startingDate, end: self.endingDate) { result in
                        withAnimation {
                            switch result {
                            case let .success(distance):
                                self.distanceText = "\(distance) Miles"
                            case let .failure(error):
                                switch error {
                                case .unknown:
                                    self.error = "An unknown error occured."
                                case .empty:
                                    self.error = "Could not find runs in the given date range."
                                }

                                self.distanceText = nil
                                self.displayError = true
                            }
                        }
                    }
                }

                if distanceText != nil {
                    Text(distanceText!)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            .navigationBarTitle("Distance Ran")
            .alert(isPresented: $displayError) {
                Alert(title: Text(self.error!))
            }
        }
    }
}

struct DistanceView_Preview: PreviewProvider {
    static var previews: some View {
        DistanceView()
    }
}
