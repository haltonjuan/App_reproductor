# Leek — Reproductor de música

Proyecto base en Flutter. Rojo como color principal, listas optimizadas
(`ListView.builder` + un solo `AudioPlayer` global) para evitar el lag.

## Estructura
```
leek/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── theme/app_theme.dart
│   ├── services/player_controller.dart
│   └── screens/
│       ├── library_screen.dart
│       └── player_screen.dart
└── android/AndroidManifest_permisos.xml
```

## 1. Preparar Termux
```bash
pkg update && pkg upgrade
pkg install git wget unzip openjdk-17 -y
```

## 2. Instalar Flutter SDK (en Termux se usa la versión para Linux)
```bash
cd ~
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor
```
> Nota: compilar un APK completo requiere Android SDK/Gradle, que en Termux
> puro es limitado. Muchos devs usan Termux solo para escribir/editar código
> y Git, y compilan el APK con **GitHub Actions** (gratis) en vez de hacerlo
> localmente en el móvil. Te dejo el workflow abajo — así evitas líos de
> memoria/almacenamiento en el teléfono y logras builds estables.

## 3. Subir el proyecto a GitHub
```bash
cd leek
git init
git add .
git commit -m "Leek: proyecto base"
git remote add origin https://github.com/TU_USUARIO/leek.git
git push -u origin main
```

## 4. Compilar el APK automáticamente con GitHub Actions
Crea `.github/workflows/build.yml` (te lo genero si quieres) que:
- instala Flutter,
- corre `flutter pub get`,
- ejecuta `flutter build apk --release`,
- sube el APK como artifact descargable.

Así compilas sin depender del hardware del móvil y evitas los bugs de
builds locales inestables.

## 5. Antes de publicar en Play Store
- Cambia el `applicationId` en `android/app/build.gradle` a algo único,
  ej: `com.tunombre.leek`
- Agrega ícono y nombre "Leek" en `android/app/src/main/AndroidManifest.xml`
  (`android:label="Leek"`)
- Pega los permisos de `AndroidManifest_permisos.xml`
- Genera un keystore de firma (`keytool -genkey ...`) — Play Store no acepta
  APKs sin firmar

## Próximos pasos sugeridos
- Pestaña "Videos" (usar `queryVideos()` de on_audio_query)
- Guardar favoritos/playlists con `sqflite` o `hive`
- Letras sincronizadas (requiere API externa o archivos .lrc)
