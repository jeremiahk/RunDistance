import SwiftUI

public struct DistanceView: View {
    @State private var startingDate: Date = Date()
    @State private var endingDate: Date = Date()
    @State private var isShowingStartingDate = false
    @State private var isShowingEndingDate = false
    @State private var distanceText: String? = nil

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

                Button("Test") {
//                    getDistance()
                    withAnimation {
                        self.distanceText = "130 Miles"
                    }
                }

                if distanceText != nil {
                    Text(distanceText!)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            .navigationBarTitle("Distance Ran")
        }
    }
}

struct DistanceView_Preview: PreviewProvider {
    static var previews: some View {
        DistanceView()
    }
}
