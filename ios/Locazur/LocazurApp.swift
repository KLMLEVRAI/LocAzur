import SwiftUI

@main
struct LocazurApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var serverManager = ServerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(serverManager)
        }
    }
}
