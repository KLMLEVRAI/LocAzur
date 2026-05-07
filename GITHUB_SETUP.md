# Guide de déploiement sur GitHub

Instructions pour pousser le projet Locazur sur GitHub.

## 1. Créer un dépôt GitHub

1. Allez sur https://github.com/new
2. Nom du dépôt: `LocAzur`
3. Description: "Application de simulation de position GPS pour iPhone avec serveur Node.js"
4. Public ou Private selon votre choix
5. **Ne pas** initialiser avec README, .gitignore ou license
6. Cliquez sur **Create repository**

## 2. Initialiser le dépôt local

Dans le dossier du projet:

```bash
# Initialiser Git
git init

# Ajouter tous les fichiers
git add .

# Commit initial
git commit -m "Initial commit - Locazur location changer app"

# Ajouter le remote GitHub (remplacez par votre username)
git remote add origin https://github.com/KLMLEVRAI/LocAzur.git

# Pousser vers GitHub
git branch -M main
git push -u origin main
```

## 3. Vérifier sur GitHub

Allez sur https://github.com/KLMLEVRAI/LocAzur

Vous devriez voir tous les fichiers:
- `/server` - Backend Node.js
- `/ios/Locazur` - Application iOS SwiftUI
- `/config` - Profil de configuration
- `README.md` - Documentation principale
- `BUILD.md` - Guide de compilation
- `USAGE.md` - Guide d'utilisation

## 4. Configuration des GitHub Pages (optionnel)

Pour héberger la documentation:

1. Settings → Pages
2. Source: Deploy from a branch
3. Branch: main, folder: /docs (ou /root pour racine)
4. Save

Votre site sera à: https://klmlevrai.github.io/LocAzur/

## 5. Ajouter des contributeurs (optionnel)

1. Settings → Collaborators
2. Ajoutez les emails des contributeurs
3. Ils pourront push directement

## 6. Créer des Releases (optionnel)

Pour distribuer l'application:

1. Releases → Create a new release
2. Tag: `v1.0.0`
3. Title: "Locazur v1.0.0"
4. Description: Changelog des changements
5. Attacher des binaires (si applicable)
6. Publish release

## 7. Configurer les GitHub Actions (CI/CD)

Créer `.github/workflows/ci.yml`:

```yaml
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test-server:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Use Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: cd server && npm install
      - run: cd server && node server.js &
      - run: sleep 2
      - run: node test-server.js
```

## 8. Badges pour le README

Ajoutez ces badges en haut du README.md:

```markdown
![GitHub repo size](https://img.shields.io/github/repo-size/KLMLEVRAI/LocAzur)
![GitHub stars](https://img.shields.io/github/stars/KLMLEVRAI/LocAzur?style=social)
![GitHub issues](https://img.shields.io/github/issues/KLMLEVRAI/LocAzur)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
```

## 9. Protection des branches (optionnel)

Settings → Branches → Add rule:
- Branch name pattern: `main`
- Require pull request reviews: ✅
- Require status checks: ✅
- Require branches to be up to date: ✅

## 10. Ajouter un LICENSE

Créer un fichier `LICENSE`:

```
MIT License

Copyright (c) 2025 Locazur

Permission is hereby granted...
```

Ou utiliser GitHub UI: Settings → License → Add a license

## Structure finale sur GitHub

```
LocAzur/
├── .github/
│   └── workflows/
│       └── ci.yml
├── ios/
│   ├── Locazur/
│   │   ├── LocazurApp.swift
│   │   ├── ContentView.swift
│   │   ├── LocationManager.swift
│   │   ├── ServerManager.swift
│   │   ├── HostingController.swift
│   │   ├── LaunchScreen.storyboard
│   │   ├── Main.storyboard
│   │   ├── Info.plist
│   │   └── Assets.xcassets/
│   └── Locazur.xcodeproj/
│       ├── project.pbxproj
│       ├── xcshareddata/
│       └── xcuserdata/
├── server/
│   ├── server.js
│   ├── package.json
│   ├── package-lock.json
│   └── .env.example
├── config/
│   └── Locazur.mobileconfig
├── README.md
├── BUILD.md
├── USAGE.md
├── GITHUB_SETUP.md
├── .gitignore
└── LICENSE
```

## Commandes Git utiles

```bash
# Voir le statut
git status

# Ajouter un fichier spécifique
git add README.md

# Commit avec message
git commit -m "Add README documentation"

# Push vers GitHub
git push origin main

# Pull (récupérer les changements)
git pull origin main

# Voir l'historique
git log --oneline

# Créer une branche
git branch feature/add-new-city
git checkout feature/add-new-city
```

## Résolution de problèmes

### Erreur: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/KLMLEVRAI/LocAzur.git
```

### Erreur: "Authentication failed"
- Utiliser un Personal Access Token (PAT) au lieu du mot de passe
- Settings → Developer settings → Personal access tokens → Generate new token

### Erreur: "File too large"
Ajouter le fichier à `.gitignore` et:
```bash
git rm --cached <fichier>
git commit -m "Remove large file"
```

## Support

Questions? Ouvrez une issue sur: https://github.com/KLMLEVRAI/LocAzur/issues
