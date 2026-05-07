# 🚀 Locazur - Démarrage Rapide

Application de changement de position GPS pour iPhone.

## 📦 Ce qui est inclus

- **Backend Node.js** - Serveur WebSocket + API REST
- **iOS App SwiftUI** - Interface de simulation de position
- **8 villes prédéfinies** - Paris, NY, Tokyo, etc.
- **Coordonnées manuelles** - Entrée libre de latitude/longitude

## ⚡ 5 minutes pour démarrer

### 1. Démarrer le serveur

```bash
cd server
npm install
npm start
```

✅ Serveur sur `http://localhost:3000`

### 2. Builder l'application (sur Mac)

```bash
# Ouvrir dans Xcode
open ios/Locazur.xcodeproj
```

- Cliquer sur **Run** (Cmd+R)
- Choisir un simulateur ou device physique

### 3. Configurer et utiliser

1. Dans l'app, cliquer **Paramètres** (gear)
2. Adresse: `ws://localhost:3000`
3. Revenir et cliquer **Se connecter** (voyant vert)
4. Choisir une destination dans la liste
5. C'est tout! 🎉

## 📁 Structure du projet

```
Locazur/
├── server/              # Backend Node.js (Express + Socket.io)
│   ├── server.js       # Serveur principal
│   ├── package.json    # Dépendances
│   └── .env           # Configuration
├── ios/
│   ├── Locazur/        # App iOS SwiftUI
│   │   ├── LocazurApp.swift
│   │   ├── ContentView.swift
│   │   ├── LocationManager.swift
│   │   ├── ServerManager.swift
│   │   ├── HostingController.swift
│   │   ├── LaunchScreen.storyboard
│   │   ├── Main.storyboard
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   └── Locazur.xcodeproj/  # Projet Xcode
├── config/             # Profils de configuration iOS
├── README.md          # Documentation complète
├── BUILD.md           # Guide de compilation Mac
├── USAGE.md           # Guide d'utilisation
├── GITHUB_SETUP.md    # Déploiement GitHub
└── test-server.js     # Tests automatisés
```

## 🔧 Commandes utiles

```bash
# Tester le serveur
node test-server.js

# API destinations
curl http://localhost:3000/api/destinations

# API santé
curl http://localhost:3000/api/health

# Ajouter une ville
curl -X POST http://localhost:3000/api/destinations \
  -H "Content-Type: application/json" \
  -d '{"name":"Lyon","latitude":45.7640,"longitude":4.8357}'
```

## 📱 Interface iPhone

```
┌─────────────────────────┐
│  Locazur        [⚙️]    │
├─────────────────────────┤
│ 🟢 Connecté             │
│                         │
│ Position: Paris         │
│ Lat: 48.8566            │
│ Lon: 2.3522             │
│                         │
│ [Paris] [NY] [Tokyo]    │
│                         │
│ [Coordonnées] [Serveur] │
└─────────────────────────┘
```

## 🌍 Coordonnées utiles

| Ville | Lat | Lon |
|-------|-----|-----|
| Paris | 48.8566 | 2.3522 |
| New York | 40.7128 | -74.0060 |
| Tokyo | 35.6762 | 139.6503 |
| Londres | 51.5074 | -0.1278 |
| Sydney | -33.8688 | 151.2093 |

## ⚠️ Limitations iOS

La simulation GPS **réelle** sur iPhone physique nécessite:
- Compte Apple Developer (99$/an)
- Certificats spéciaux
- Entitlements privés

**Alternative:** Utiliser le Simulateur iOS de Xcode (gratuit) qui supporte la simulation GPS via `Debug → Location`.

Cette app démontre l'interface et la communication. Pour simulation complète, builder avec certificat développeur.

## 📚 Documentation

- **[README.md](README.md)** - Documentation complète
- **[BUILD.md](BUILD.md)** - Compilation sur Mac
- **[USAGE.md](USAGE.md)** - Utilisation détaillée
- **[GITHUB_SETUP.md](GITHUB_SETUP.md)** - Déployer sur GitHub

## 🐛 Dépannage

**"Impossible de se connecter"**
- Vérifier que le serveur tourne (`npm start`)
- Vérifier l'adresse IP (pas localhost sur iPhone)
- iPhone et Mac sur même WiFi

**"Coordonnées invalides"**
- Format décimal uniquement
- Latitude: -90 à 90
- Longitude: -180 à 180

## 🤝 Contribuer

Fork → Modifiez → Pull Request!

## 📄 Licence

MIT - Usage éducatif et de test uniquement.

---

**Prêt?** `cd server && npm start` et lancez l'app! 🚀
