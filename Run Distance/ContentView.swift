import SwiftUI
import Alerts
import Distance

struct ContentView: View {
    var body: some View {
        TabView {
            DistanceView()
                .tabItem {
                    Text("Distance")
                }
            AlertView()
                .tabItem {
                    Text("Alerts")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
