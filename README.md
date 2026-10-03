# NOTFOME · Gestión

Aplicación web/PWA para gestión de papelería creativa y toppers.

## Archivos para publicar

- `index.html` — aplicación completa (última versión).
- `manifest.json` — configuración PWA.
- `service-worker.js` — caché/offline y actualización de la PWA.
- `icon-192.png` — ícono PWA.
- `icon-512.png` — ícono PWA.
- `supabase.sql` — estructura de nube/RLS, si se activa Supabase.
- `CONFIGURACION_GOOGLE.md` — guía de configuración de nube/Google.

## Publicar en GitHub Pages

1. Crear o abrir el repositorio.
2. Subir **todos estos archivos en la raíz** del repositorio.
3. En GitHub: **Settings → Pages**.
4. En `Build and deployment`, elegir `Deploy from a branch`.
5. Seleccionar la rama que contiene estos archivos (normalmente `main`) y carpeta `/ (root)`.
6. Guardar y esperar a que GitHub Pages publique la aplicación.

La aplicación debe abrirse desde `https://...`, no desde `file://`, especialmente para PWA, compartir archivos y autenticación.

## Supabase

El HTML ya incluye soporte para Supabase, pero las credenciales públicas deben configurarse antes de activar la nube. Ver `CONFIGURACION_GOOGLE.md` y `supabase.sql`.

**Nunca colocar una clave `service_role` en `index.html`.**
