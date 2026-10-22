# ReservaYa

Proyecto final de la materia de negocios electronicos. Aplicación móvil como de **reservaciones** desarrollada en **Flutter** y respaldada por **Firebase** (Authentication, Cloud Firestore y Storage). Permite a los usuarios buscar y reservar alojamientos, a los anfitriones publicar y administrar sus propiedades, y a los huéspedes gestionar viajes, favoritos y mensajería.

## Funcionalidades

- Registro e inicio de sesión de usuarios (Firebase Auth).
- Roles de **huésped** y **anfitrión**.
- Búsqueda y exploración de publicaciones (alojamientos).
- Creación y administración de publicaciones por parte del anfitrión.
- Reservaciones y listado de viajes.
- Mensajería/chat entre usuarios.
- Módulo de **finanzas** (dashboard, registro de transacciones y estadísticas).
- Integración de pagos (`pay`).

## Estructura

- `reserva_ya/` – proyecto Flutter (`lib/`, `android/`, `ios/`, `assets/`).
- `reserva_ya/lib/model/` – modelos de datos (usuario, reservación, publicación, mensajes, etc.).
- `reserva_ya/lib/view/` – pantallas y widgets.
- `reserva_ya/lib/view_model/` – lógica de estado (paquete `get`).

## Fecha de creación

El proyecto se creó el **26 de octubre de 2024**.

> Aclaración: el proyecto fue creado originalmente en esa fecha y posteriormente migrado a este nuevo repositorio el **22 de octubre de 2026**. Por eso las fechas que muestra el sistema de archivos corresponden al momento de la migración y no a la fecha original de creación.
