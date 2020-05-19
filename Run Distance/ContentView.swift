import SwiftUI
import Alerts
import Distance
import Shoes

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
            ShoesView()
                .tabItem {
                    Image(systemName: "triangle")
                    Text("Shoe Tracker")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
