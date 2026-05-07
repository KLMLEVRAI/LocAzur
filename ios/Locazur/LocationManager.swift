import Foundation
import Combine

class LocationManager: ObservableObject {
    @Published var currentLocation: Location?
    @Published var isSimulating = false

    func setLocation(latitude: Double, longitude: Double, name: String) {
        currentLocation = Location(
            name: name,
            latitude: latitude,
            longitude: longitude,
            isSimulated: true
        )
        isSimulating = true
    }

    func clearLocation() {
        currentLocation = nil
        isSimulating = false
    }
}

struct Location: Identifiable, Codable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let isSimulated: Bool
    let timestamp: Date?

    init(name: String, latitude: Double, longitude: Double, isSimulated: Bool = false, timestamp: Date? = nil) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isSimulated = isSimulated
        self.timestamp = timestamp ?? Date()
    }
}
