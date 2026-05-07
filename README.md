# Locazur - Changeur de Position iPhone

Application de simulation de position GPS pour iPhone avec serveur backend. Permet de se connecter à un serveur et de simuler une destination GPS personnalisée.

## Architecture

```
┌─────────────────┐    WebSocket/HTTP    ┌─────────────────┐
│   iPhone App    │ ◄────────────────► │   Node.js       │
│   (SwiftUI)     │                     │   Server        │
│                 │                     │   (Express)     │
└─────────────────┘                     └─────────────────┘
       │                                        │
       │ Sélection destination                  │ Gère destinations
       │                                        │
       └────────────────────────────────────────┘
```

## Fonctionnalités

- ✅ Connexion WebSocket au serveur
- ✅ Liste de destinations prédéfinies (Paris, New York, Tokyo, etc.)
- ✅ Entrée manuelle de coordonnées GPS personnalisées
- ✅ Affichage de la position actuelle
- ✅ API REST pour gestion des destinations
- ✅ Support multi-appareils
- ✅ Configuration serveur personnalisable

## Installation

### 1. Serveur Backend

```bash
cd server
npm install
npm start
```

Le serveur démarre sur `http://0.0.0.0:3000`

**Endpoints API:**
- `GET /api/destinations` - Liste des destinations
- `GET /api/destinations/:id` - Détail destination
- `POST /api/destinations` - Ajouter destination
- `DELETE /api/destinations/:id` - Supprimer destination
- `GET /api/health` - Santé du serveur
- `GET /api/devices` - Appareils connectés

### 2. Application iOS

1. Ouvrir `ios/Locazur/Locazur.xcodeproj` dans Xcode
2. Configurer le signing (Team, Bundle Identifier)
3. Changer la version iOS cible si nécessaire (iOS 15+)
4. Build & Run sur iPhone ou simulateur

**Configuration du serveur:**
- Dans l'app, aller dans "Paramètres" (icône gear)
- Entrer l'adresse du serveur: `ws://VOTRE_IP:3000`
- Exemple: `ws://192.168.1.100:3000`

## Utilisation

### Connexion
1. Lancer l'application
2. Taper sur "Se connecter"
3. Le voyant devient vert quand connecté

### Changer de position
**Méthode 1 - Destinations prédéfinies:**
- Parcourir la liste des villes
- Taper sur une destination
- La position est immédiatement simulée

**Méthode 2 - Coordonnées personnalisées:**
- Taper sur le bouton "Coordonnées"
- Entrer Latitude et Longitude
- Optionnel: donner un nom
- Taper "Appliquer cette position"

### Exemples de coordonnées

| Ville | Latitude | Longitude |
|-------|----------|-----------|
| Paris | 48.8566 | 2.3522 |
| New York | 40.7128 | -74.0060 |
| Tokyo | 35.6762 | 139.6503 |
| Londres | 51.5074 | -0.1278 |
| Sydney | -33.8688 | 151.2093 |

## Configuration avancée

### Ajouter une destination via API

```bash
curl -X POST http://localhost:3000/api/destinations \
  -H "Content-Type: application/json" \
  -d '{"name":"Lyon","latitude":45.7640,"longitude":4.8357,"country":"France"}'
```

### Voir les appareils connectés

```bash
curl http://localhost:3000/api/devices
```

## Notes techniques

### Limitations iOS
- iOS ne permet pas la modification directe du GPS sans certificats développeur
- Cette application démontre l'interface et la communication
- Pour la simulation réelle, utiliser:
  - Xcode Simulator (pour tests)
  - Certificats développeur Apple
  - Outils de test comme `simctl`

### Sécurité
- CORS activé pour toutes origines (à restreindre en production)
- WebSocket non authentifié (à sécuriser pour production)
- Pas de chiffrement WS (utiliser WSS en production)

## Structure du projet

```
Locazur/
├── server/              # Backend Node.js
│   ├── server.js       # Serveur principal
│   ├── package.json    # Dépendances
│   └── .env           # Configuration
├── ios/Locazur/        # Application iOS
│   ├── LocazurApp.swift
│   ├── ContentView.swift
│   ├── LocationManager.swift
│   ├── ServerManager.swift
│   ├── LaunchScreen.storyboard
│   └── Info.plist
├── config/             # Profils de configuration
│   └── Locazur.mobileconfig
└── README.md
```

## Dépannage

### "Impossible de se connecter"
- Vérifier que le serveur est démarré
- Vérifier l'adresse IP (pas localhost sur iPhone)
- Vérifier le pare-feu
- iPhone et serveur sur même réseau WiFi

### "Coordonnées invalides"
- Format décimal (pas DMS)
- Latitude: -90 à 90
- Longitude: -180 à 180

## Licence

Projet éducatif - Usage de test uniquement.
