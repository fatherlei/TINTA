# NOTFOME · Fase 2 — Google + nube

## 1. Crear el proyecto de Supabase
Crear un proyecto en Supabase y ejecutar `supabase.sql` completo en SQL Editor.

## 2. Activar Google
En Supabase: Authentication → Sign In / Providers → Google.
Activar Google y completar las credenciales OAuth que solicita Supabase.

Supabase proporciona en esa pantalla la **Callback URL** del proyecto. Esa URL se registra también en la configuración OAuth de Google Cloud.

## 3. URL de la aplicación
En Supabase Authentication → URL Configuration:
- Site URL: la URL HTTPS donde esté publicada NOTFOME.
- Redirect URLs: agregar la misma URL exacta de la aplicación.

La app usa `location.origin + location.pathname` como `redirectTo`, por lo que esa dirección debe estar permitida.

## 4. Conectar NOTFOME
En `index.html`, completar:

```js
const NOTFOME_CLOUD_CONFIG = {
  url: 'https://TU-PROYECTO.supabase.co',
  anonKey: 'TU_CLAVE_PUBLICA'
};
```

Usar solamente la clave pública/publishable/anon. **Nunca** colocar una `service_role` key en el HTML.

## 5. Flujo final del usuario
1. Abre NOTFOME.
2. Puede elegir `Continuar con Google` o `Continuar sin cuenta`.
3. Google autentica al usuario.
4. Supabase crea/recupera su usuario.
5. Se crea automáticamente su perfil.
6. Los datos de NOTFOME quedan asociados a ese `user_id`.
7. Si no existe copia en la nube, se suben sus datos locales.
8. Si existe una copia más nueva, se descarga después de proteger los datos locales.
9. Los cambios posteriores se sincronizan automáticamente.

## 6. Seguridad
RLS está activado en las tablas. Cada usuario solamente puede leer/escribir las filas cuyo `user_id` coincide con `auth.uid()`.

No se usan cuentas de email/contraseña en la interfaz de NOTFOME: el único acceso es Google.

## 7. Importante
OAuth no se debe probar abriendo `index.html` como `file://`. La aplicación debe estar publicada en una URL web permitida por Supabase/Google.
