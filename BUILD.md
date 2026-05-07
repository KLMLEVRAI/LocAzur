# Guide de Build - Locazur (macOS)

Ce guide explique comment compiler et installer l'application Locazur sur un Mac.

## Prérequis

- macOS 12.0 ou supérieur
- Xcode 15.0 ou supérieur (disponible sur l'App Store)
- Compte Apple ID (gratuit)
- iPhone avec iOS 15.0+ (pour déploiement sur device)

## Structure du projet

```
Locazur/
├── ios/
│   ├── Locazur/              # Dossier de l'application SwiftUI
│   │   ├── LocazurApp.swift
│   │   ├── ContentView.swift
│   │   ├── LocationManager.swift
│   │   ├── ServerManager.swift
│   │   ├── HostingController.swift
│   │   ├── LaunchScreen.storyboard
│   │   ├── Main.storyboard
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   └── Locazur.xcodeproj/    # Projet Xcode
├── server/                   # Serveur backend Node.js
│   ├── server.js
│   ├── package.json
│   └── .env
└── README.md
```

## Étape 1: Cloner le dépôt

```bash
git clone https://github.com/KLMLEVRAI/LocAzur.git
cd LocAzur
```

## Étape 2: Installer le serveur

```bash
cd server
npm install
```

Le serveur est maintenant prêt à démarrer.

## Étape 3: Builder l'application iOS

### Option A - Avec Xcode (Recommandé)

1. **Ouvrir le projet**
   - Lancez Xcode
   - File → Open
   - Naviguez vers `ios/Locazur.xcodeproj`
   - Sélectionnez le fichier et ouvrez

2. **Configurer le signing**
   - Dans le navigateur de projet, cliquez sur `Locazur` (le projet)
   - Sélectionnez la cible `Locazur`
   - Onglet **Signing & Capabilities**
   - Sélectionnez votre **Team** (votre compte Apple)
   - Le **Bundle Identifier** sera automatiquement configuré

3. **Sélectionner le device**
   - Connectez votre iPhone via USB OU
   - Sélectionnez un simulateur (iPhone 15, etc.)

4. **Builder et Run**
   - Cliquez sur le bouton **Run** (triangle) en haut à gauche
   - Ou appuyez sur `Cmd + R`
   - L'application se compile et se lance sur le device/simulateur

### Option B - En ligne de commande

```bash
cd ios
xcodebuild -project Locazur.xcodeproj \
  -scheme Locazur \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  clean build
```

Pour déployer sur un device spécifique:

```bash
xcodebuild -project Locazur.xcodeproj \
  -scheme Locazur \
  -configuration Debug \
  -destination 'platform=iOS,name=iPhone 15' \
  clean build
```

## Étape 4: Démarrer le serveur

Dans un terminal:

```bash
cd server
node server.js
```

Le serveur démarre sur `http://0.0.0.0:3000`

**Note:** Assurez-vous que votre iPhone et votre Mac sont sur le même réseau WiFi.

## Étape 5: Configurer l'application

1. Sur votre iPhone, lancez l'application Locazur
2. Cliquez sur l'icône **Paramètres** (gear)
3. Entrez l'adresse du serveur:
   - Si sur le même Mac: `ws://localhost:3000`
   - Si sur même réseau: `ws://VOTRE_IP_MAC:3000`
   - Trouvez votre IP: `ifconfig` ou dans Préférences Système → Réseau
4. Cliquez sur **Se connecter**
5. Le voyant devient vert ✓

## Étape 6: Tester

1. Revenez à l'écran principal
2. Sélectionnez une ville (ex: Paris)
3. La position est simulée
4. Pour coordonnées personnalisées: bouton **Coordonnées**

## Dépannage

### Erreur de signing
```
"No profiles for 'com.locazur.app' were found"
```
**Solution:** Dans Xcode → Signing & Capabilities → Sélectionnez votre Team. Xcode créera automatiquement un profil de développement.

### Erreur de compilation Swift
```
"Swift version mismatch"
```
**Solution:** Dans Build Settings → Swift Compiler - Language → Swift Language Version → Sélectionnez "Swift 5"

### L'app ne se lance pas
```
"App n'a pas pu être lancé car le développeur ne peut pas être vérifié"
```
**Solution:** Sur iPhone: Settings → General → VPN & Device Management → Faites confiance au développeur

### Impossible de se connecter au serveur
**Vérifiez:**
- Le serveur est démarré (`node server.js`)
- iPhone et Mac sur même réseau WiFi
- Adresse IP correcte dans l'app
- Pas de firewall bloquant le port 3000

## Build pour l'App Store (Distribution)

1. **Incrementer la version**
   - Dans Xcode, sélectionnez le projet
   - General → Version: 1.0 → 1.1 (ou nouvelle version)
   - Build: 1 → 2

2. **Archive**
   - Product → Archive
   - Attendre la fin de l'archive

3. **Distribuer**
   - Dans l'organizer, cliquez sur **Distribute App**
   - Choisissez **App Store Connect**
   - Suivez l'assistant

4. **Sur App Store Connect**
   - Créez une nouvelle application
   - Téléversez le .ipa généré
   - Soumettez pour review

## Notes importantes

⚠️ **Limitation iOS:** La simulation de position GPS réelle nécessite:
- Un certificat de développeur Apple (payant, 99$/an)
- L'application signée avec entitlements spéciaux
- Ou utilisation de Xcode Simulator pour tests

Cette application démontre l'interface et la communication serveur. Pour la simulation GPS réelle sur device physique, vous devez:
1. Avoir un compte Apple Developer (payant)
2. Ajouter l'entitlement `com.apple.developer.location-simulation` (private)
3. Signer avec un certificat de distribution

**Alternative:** Utiliser le simulateur iOS de Xcode qui permet la simulation GPS via `Debug → Location`.

## Support

Pour toute question: https://github.com/KLMLEVRAI/LocAzur/issues
