# Guía paso a paso — de cero a APK instalable

No necesitas saber programar para seguir esto. Ve copiando y pegando
cada comando **uno por uno**, en orden, y espera a que termine antes
de pasar al siguiente.

---

## PARTE 1: Preparar tu cuenta de GitHub

1. Entra a https://github.com y crea una cuenta (si no tienes).
2. Una vez dentro, arriba a la derecha toca el ícono **+** → **New repository**.
3. Ponle de nombre `leek`, márcalo como **Public** (para usar GitHub Actions
   gratis), y toca **Create repository**. NO marques "Add README".
4. Deja esa página abierta, la vas a necesitar en la Parte 3.

---

## PARTE 2: Instalar Termux y preparar el entorno

1. Instala **Termux** desde F-Droid (recomendado, no la versión de Play
   Store que está desactualizada): https://f-droid.org/packages/com.termux/
2. Ábrelo y ejecuta, uno por uno:

```bash
pkg update && pkg upgrade -y
```
(Te preguntará "¿Continuar?" — escribe `y` y Enter cuando lo pida)

```bash
pkg install git wget unzip openjdk-17 -y
```

3. Verifica que Java se instaló bien:
```bash
java -version
```
Debe mostrarte algo como `openjdk version "17..."`. Si sale error,
avísame antes de seguir.

4. Instala Flutter:
```bash
cd ~
git clone https://github.com/flutter/flutter.git -b stable
```
Esto tarda varios minutos, espera a que termine.

```bash
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

5. Verifica:
```bash
flutter --version
```
Debe mostrarte un número de versión sin errores.

---

## PARTE 3: Subir el proyecto Leek a tu GitHub

1. Descarga el archivo `leek_flutter_app.zip` que te di, y muévelo a la
   carpeta de descargas accesible por Termux. Luego en Termux:

```bash
cd ~
termux-setup-storage
```
(Te va a pedir permiso — acéptalo)

```bash
cp /sdcard/Download/leek_flutter_app.zip ~/
unzip leek_flutter_app.zip
cd leek
```

2. Configura tu identidad en git (solo la primera vez, cambia por tus datos):
```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu_correo@ejemplo.com"
```

3. Sube el proyecto:
```bash
git init
git add .
git commit -m "Primera version de Leek"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/leek.git
git push -u origin main
```

- Cambia `TU_USUARIO` por tu usuario real de GitHub.
- Te va a pedir usuario y contraseña. **GitHub ya no acepta tu contraseña
  normal aquí** — necesitas crear un "Personal Access Token":
  - Ve a https://github.com/settings/tokens → **Generate new token
    (classic)** → marca la casilla `repo` → **Generate token**.
  - Copia ese token (es largo, tipo `ghp_xxxxx`) y pégalo como si fuera
    la contraseña cuando Termux te lo pida.
  - Guárdalo en un lugar seguro, no lo vuelves a ver.

---

## PARTE 4: Compilar el APK automáticamente (sin usar el móvil)

1. Ve a tu repositorio en GitHub (`github.com/TU_USUARIO/leek`) desde el navegador.
2. Toca la pestaña **Actions** (arriba).
3. Verás que ya empezó a compilar solo (por el workflow que incluí). Espera
   unos 3-5 minutos. Un círculo amarillo = compilando, verde ✅ = listo.
4. Cuando esté en verde, entra a esa ejecución y baja hasta **Artifacts**.
5. Descarga `leek-apk` — es un .zip que contiene tu `app-release.apk`.
6. Descomprímelo en tu móvil e instala el APK (activa "Instalar apps de
   orígenes desconocidos" si te lo pide Android).

---

## PARTE 5: Cada vez que quieras actualizar la app

Cuando yo te dé archivos nuevos o modifiques algo:

```bash
cd ~/leek
git add .
git commit -m "Actualización"
git push
```

Eso solo. GitHub Actions compila el nuevo APK automáticamente, y lo
descargas otra vez desde la pestaña **Actions**.

---

## Antes de publicar en Play Store (más adelante)

Esto lo vemos cuando la app esté probada y sin bugs. Requiere:
- Crear una cuenta de desarrollador de Google Play (pago único de $25 USD)
- Firmar el APK con una llave (keystore)
- Cambiar el `applicationId` a algo único

Avísame cuando llegues a ese punto y te guío paso a paso también.

---

### Si algo falla
Copia el mensaje de error exacto y pégamelo — dime en qué parte (1, 2, 3, 4)
te quedaste. No sigas al siguiente paso si uno da error.
