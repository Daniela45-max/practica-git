# Notas PWA - Proyecto Flutter (IndexedDB + Offline)

Instrucciones rápidas:

1. Obtener dependencias:
   flutter pub get

2. Ejecutar en modo debug (Chrome):
   flutter run -d chrome

3. Construir para producción (genera build/web):
   flutter build web

4. Servir build/web en un servidor (no abrir por file://)
   python -m http.server 8080
   o
   npx serve build/web

Notas:
- Reemplaza assets/logo.png y los iconos en web/icons/ con imágenes reales.
- El service worker incluido es básico; Flutter generará su propio flutter_service_worker.js en `build/web` al hacer build.
- IndexedDB se maneja con idb_shim (lib/services/db_service.dart).
