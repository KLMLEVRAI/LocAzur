import Foundation
import Combine
import Network

class ServerManager: ObservableObject {
    @Published var isConnected = false
    @Published var destinations: [Destination] = []
    @Published var serverURL: String = "ws://192.168.1.100:3000"
    @Published var connectionError: String?

    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "ServerManager")

    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "unknown-device"

    init() {
        loadSavedServerURL()
        fetchDestinations()
    }

    private func loadSavedServerURL() {
        let defaults = UserDefaults.standard
        if let savedURL = defaults.string(forKey: "serverURL"), !savedURL.isEmpty {
            serverURL = savedURL
        }
    }

    func connect() {
        guard let url = URL(string: serverURL) else {
            connectionError = "URL invalide"
            return
        }

        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()

        isConnected = true
        connectionError = nil

        // Register device
        sendMessage(type: "device:join", data: ["deviceId": deviceId])

        // Start listening
        listenForMessages()

        // Save URL
        UserDefaults.standard.set(serverURL, forKey: "serverURL")

        print("Connecté au serveur: \(serverURL)")
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Erreur WebSocket: \(error)")
                self?.isConnected = false
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleMessage(text)
                    }
                @unknown default:
                    break
                }
                // Continue listening
                self?.listenForMessages()
            }
        }
    }

    private func handleMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = json["type"] as? String else {
            return
        }

        switch type {
        case "location:current":
            if let lat = json["latitude"] as? Double,
               let lon = json["longitude"] as? Double {
                DispatchQueue.main.async {
                    // Update location if needed
                }
            }
        default:
            break
        }
    }

    func sendLocationChange(latitude: Double, longitude: Double) {
        sendMessage(type: "location:set", data: [
            "deviceId": deviceId,
            "latitude": latitude,
            "longitude": longitude
        ])
    }

    private func sendMessage(type: String, data: [String: Any]) {
        let message: [String: Any] = ["type": type, "data": data]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }

        webSocketTask?.send(.string(jsonString)) { error in
            if let error = error {
                print("Erreur envoi message: \(error)")
            }
        }
    }

    func fetchDestinations() {
        guard let url = URL(string: serverURL.replacingOccurrences(of: "ws", with: "http"))?
            .appendingPathComponent("/api/destinations") else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let success = result["success"] as? Bool,
                  success,
                  let destData = result["data"] as? [[String: Any]] else {
            return
        }

            DispatchQueue.main.async {
                self?.destinations = destData.compactMap { dict in
                    guard let id = dict["id"] as? Int,
                          let name = dict["name"] as? String,
                          let lat = dict["latitude"] as? Double,
                          let lon = dict["longitude"] as? Double else {
                        return nil
                    }
                    return Destination(
                        id: id,
                        name: name,
                        latitude: lat,
                        longitude: lon,
                        country: dict["country"] as? String
                    )
                }
            }
        }.resume()
    }
}

struct Destination: Identifiable, Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
}
