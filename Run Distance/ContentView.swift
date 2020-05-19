import SwiftUI
import Alerts
import Distance

struct ContentView: View {
    var body: some View {
        TabView {
            DistanceView()
                .tabItem {
                    Image(systemName: "square")
                    Text("Distance")
                }
            AlertView()
                .tabItem {
                    Image(systemName: "circle")
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
