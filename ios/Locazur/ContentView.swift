import SwiftUI

struct ContentView: View {
    @EnvironmentObject var serverManager: ServerManager
    @EnvironmentObject var locationManager: LocationManager

    @State private var serverURL = "ws://192.168.1.100:3000"
    @State private var showingManualInput = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Server Connection Header
                ServerConnectionHeader()

                // Connection Status
                ConnectionStatusView()

                Divider()

                // Current Location Display
                CurrentLocationView()

                Divider()

                // Destinations List
                DestinationsListView()

                Spacer()

                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        showingManualInput = true
                    }) {
                        Label("Coordonnées", systemImage: "mappin.and.ellipse")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Button(action: {
                        showingSettings = true
                    }) {
                        Label("Serveur", systemImage: "gear")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Locazur")
            .sheet(isPresented: $showingManualInput) {
                ManualLocationView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(serverURL: $serverURL)
            }
        }
    }
}

struct ServerConnectionHeader: View {
    @EnvironmentObject var serverManager: ServerManager

    var body: some View {
        HStack {
            Image(systemName: "globe")
                .foregroundColor(serverManager.isConnected ? .green : .red)
            Text("Serveur: \(serverManager.serverURL)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

struct ConnectionStatusView: View {
    @EnvironmentObject var serverManager: ServerManager

    var body: some View {
        HStack {
            Circle()
                .fill(serverManager.isConnected ? Color.green : Color.red)
                .frame(width: 12, height: 12)
            Text(serverManager.isConnected ? "Connecté" : "Déconnecté")
                .foregroundColor(serverManager.isConnected ? .green : .red)
            Spacer()
            if serverManager.isConnected {
                Button("Déconnecter") {
                    serverManager.disconnect()
                }
                .foregroundColor(.red)
            } else {
                Button("Se connecter") {
                    serverManager.connect()
                }
                .foregroundColor(.green)
            }
        }
        .padding(.horizontal)
    }
}

struct CurrentLocationView: View {
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Position actuelle")
                .font(.headline)

            if let location = locationManager.currentLocation {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("Lat: \(String(format: "%.6f", location.latitude))")
                        Text("Lon: \(String(format: "%.6f", location.longitude))")
                    }
                    .font(.caption)
                }
            } else {
                Text("Aucune position définie")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

struct DestinationsListView: View {
    @EnvironmentObject var serverManager: ServerManager
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        VStack(alignment: .leading) {
            Text("Destinations")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(serverManager.destinations, id: \.id) { destination in
                        DestinationRow(destination: destination) {
                            locationManager.setLocation(
                                latitude: destination.latitude,
                                longitude: destination.longitude,
                                name: destination.name
                            )
                            serverManager.sendLocationChange(
                                latitude: destination.latitude,
                                longitude: destination.longitude
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 200)
        }
    }
}

struct DestinationRow: View {
    let destination: Destination
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Image(systemName: "mappin")
                    .foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text(destination.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(destination.country)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct ManualLocationView: View {
    @EnvironmentObject var serverManager: ServerManager
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) var dismiss

    @State private var latitude = ""
    @State private var longitude = ""
    @State private var locationName = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Coordonnées GPS")) {
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Nom (optionnel)")) {
                    TextField("Nom de la position", text: $locationName)
                }

                Section {
                    Button(action: applyManualLocation) {
                        HStack {
                            Spacer()
                            Text("Appliquer cette position")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Coordonnées manuelles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func applyManualLocation() {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            return
        }

        let name = locationName.isEmpty ? "Position personnalisée" : locationName
        locationManager.setLocation(latitude: lat, longitude: lon, name: name)
        serverManager.sendLocationChange(latitude: lat, longitude: lon)
        dismiss()
    }
}

struct SettingsView: View {
    @EnvironmentObject var serverManager: ServerManager
    @Environment(\.dismiss) var dismiss

    @Binding var serverURL: String

    @State private var tempURL = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Configuration serveur")) {
                    TextField("Adresse du serveur", text: $tempURL)
                        .keyboardType(.URL)
                }

                Section {
                    Button(action: connectToServer) {
                        HStack {
                            Spacer()
                            Text("Se connecter")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }

                Section(header: Text("Informations")) {
                    HStack {
                        Text("État")
                        Spacer()
                        Text(serverManager.isConnected ? "Connecté" : "Déconnecté")
                            .foregroundColor(serverManager.isConnected ? .green : .red)
                    }
                }
            }
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                tempURL = serverURL
            }
        }
    }

    private func connectToServer() {
        serverURL = tempURL
        serverManager.serverURL = tempURL
        if serverManager.isConnected {
            serverManager.disconnect()
        }
        serverManager.connect()
        dismiss()
    }
}

#Preview {
    ContentView()
        .environmentObject(ServerManager())
        .environmentObject(LocationManager())
}
