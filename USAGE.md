# Guide d'utilisation - Locazur

Application de simulation de position GPS pour iPhone.

## Table des matières

1. [Démarrage rapide](#démarrage-rapide)
2. [Interface](#interface)
3. [Fonctionnalités](#fonctionnalités)
4. [Coordonnées GPS](#coordonnées-gps)
5. [API REST](#api-rest)
6. [Exemples](#exemples)

## Démarrage rapide

### 1. Démarrer le serveur

```bash
cd server
npm install  # première fois seulement
npm start
```

Le serveur est accessible sur `http://localhost:3000`

### 2. Connecter l'iPhone

1. Ouvrir Locazur sur iPhone
2. Cliquer sur **Paramètres** (icône gear)
3. Entrer l'adresse serveur:
   - Sur le même Mac: `ws://localhost:3000`
   - Sur même WiFi: `ws://192.168.1.X:3000`
4. Revenir et cliquer **Se connecter**

### 3. Changer de position

- Choisir une ville dans la liste
- OU cliquer **Coordonnées** pour entrer manuellement

## Interface

### Écran principal

```
┌─────────────────────────────┐
│  Locazur          [⚙️]      │
├─────────────────────────────┤
│ 🟢 Connecté à ws://...      │
│                             │
│ Position actuelle:          │
│ 📍 Paris                    │
│   Lat: 48.856600            │
│   Lon: 2.352200             │
│                             │
│ Destinations:               │
│ ┌─────────────────────────┐ │
│ │ 📍 Paris                │ │
│ │   France                │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 📍 New York             │ │
│ │   USA                   │ │
│ └─────────────────────────┘ │
│                             │
│ [Coordonnées]  [Serveur]    │
└─────────────────────────────┘
```

### Boutons

- **Coordonnées** (bleu): Entrée manuelle de latitude/longitude
- **Serveur** (gris): Configuration de l'adresse du serveur

## Fonctionnalités

### Destinations prédéfinies

L'application inclut 8 villes par défaut:

| Ville | Pays | Latitude | Longitude |
|-------|------|----------|-----------|
| Paris | France | 48.8566 | 2.3522 |
| New York | USA | 40.7128 | -74.0060 |
| Tokyo | Japon | 35.6762 | 139.6503 |
| Londres | UK | 51.5074 | -0.1278 |
| Sydney | Australie | -33.8688 | 151.2093 |
| Dubaï | UAE | 25.2048 | 55.2708 |
| Rome | Italie | 41.9028 | 12.4964 |
| Barcelone | Espagne | 41.3851 | 2.1734 |

### Coordonnées personnalisées

Appuyer sur **Coordonnées** → Entrer:

- **Latitude**: -90 à 90 (décimal)
- **Longitude**: -180 à 180 (décimal)
- **Nom** (optionnel): Ex: "Ma position"

Exemples:
```
Tour Eiffel: 48.8584, 2.2945
Statue Liberté: 40.6892, -74.0445
Colisée: 41.8902, 12.4922
```

## Coordonnées GPS

### Format décimal

Utiliser le format décimal standard (pas DMS):

✅ Correct:
```
48.8566
-74.0060
```

❌ Incorrect:
```
48°51'24" N
74°00'22" W
```

### Hémisphères

- **Latitude positive** = Nord
- **Latitude négative** = Sud
- **Longitude positive** = Est
- **Longitude négative** = Ouest

Exemples:
- Paris (Nord, Est): 48.85, 2.35
- Sydney (Sud, Est): -33.86, 151.20
- New York (Nord, Ouest): 40.71, -74.00

## API REST

Le serveur expose une API complète:

### Destinations

```bash
# Lister toutes les destinations
GET http://localhost:3000/api/destinations

# Obtenir une destination
GET http://localhost:3000/api/destinations/1

# Ajouter une destination
POST http://localhost:3000/api/destinations
Content-Type: application/json

{
  "name": "Lyon",
  "latitude": 45.7640,
  "longitude": 4.8357,
  "country": "France"
}

# Supprimer une destination
DELETE http://localhost:3000/api/destinations/1
```

### Appareils

```bash
# Lister les appareils connectés
GET http://localhost:3000/api/devices

# Enregistrer un device
POST http://localhost:3000/api/devices/register
{
  "deviceId": "iphone-123",
  "deviceName": "iPhone 15"
}
```

### Santé

```bash
# Vérifier le serveur
GET http://localhost:3000/api/health
```

Réponse:
```json
{
  "success": true,
  "message": "Locazur Location Server is running",
  "timestamp": "2025-01-15T10:30:00.000Z",
  "stats": {
    "destinations": 8,
    "connectedDevices": 1
  }
}
```

## WebSocket

L'application communique via WebSocket pour mises à jour en temps réel.

### Événements envoyés par le client

```javascript
// Rejoindre une room device
{ type: "device:join", data: { deviceId: "xxx" } }

// Envoyer une position
{ type: "location:set", data: { deviceId: "xxx", latitude: 48.85, longitude: 2.35 } }
```

### Événements reçus par le client

```javascript
// Position actuelle
{ type: "location:current", data: { latitude, longitude, simulated, timestamp } }

// Demande de changement
{ type: "location:change", data: { latitude, longitude, destinationId, timestamp } }
```

## Exemples

### Exemple 1: Premier usage

1. Démarrer le serveur
2. Ouvrir l'app sur iPhone
3. Cliquer **Paramètres**
4. Entrer `ws://192.168.1.10:3000` (IP de votre Mac)
5. Revenir et cliquer **Se connecter**
6. Sélectionner **Paris**
7. La position est maintenant Paris

### Exemple 2: Coordonnées personnalisées

1. Cliquer **Coordonnées**
2. Latitude: `51.5074`
3. Longitude: `-0.1278`
4. Nom: `Londres`
5. **Appliquer**
6. Position = Londres

### Exemple 3: Ajouter une destination via API

```bash
curl -X POST http://localhost:3000/api/destinations \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Lyon",
    "latitude": 45.7640,
    "longitude": 4.8357,
    "country": "France"
  }'
```

L'option "Lyon" apparaît automatiquement dans l'app.

### Exemple 4: Vérifier les connexions

```bash
curl http://localhost:3000/api/devices
```

Affiche tous les devices connectés avec leur position actuelle.

## Astuces

### Trouver son IP locale (Mac)

```bash
# Via Terminal
ifconfig | grep "inet " | grep -v 127.0.0.1

# OU via Préférences Système → Réseau → Wi-Fi
```

### Tester le serveur sans iPhone

```bash
# Vérifier santé
curl http://localhost:3000/api/health

# Tester WebSocket (nécessite wscat)
npm install -g wscat
wscat -c ws://localhost:3000
```

### Logs du serveur

Le serveur affiche les connexions en temps réel:

```
🚀 Locazur Location Server running on http://0.0.0.0:3000
📡 WebSocket server ready
New client connected: abc123
Device iphone-456 joined room
Location set request for device iphone-456
```

## Sécurité

⚠️ **Important:** Ce projet est pour développement/test uniquement.

En production, ajouter:
- Authentification JWT
- WSS (WebSocket sécurisé)
- Validation des coordonnées
- Rate limiting
- Logs détaillés
- HTTPS obligatoire

## Support

Problèmes? Consultez [BUILD.md](BUILD.md#dépannage) ou ouvrez une issue sur GitHub.
