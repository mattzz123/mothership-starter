# PROJECT_REGISTRY.md — Catálogo de proyectos

Registro de todos los proyectos activos del workspace con sus slugs canónicos y aliases naturales.

## Cómo se usa

- Cuando el usuario nombra un proyecto en lenguaje natural, resolverlo a slug vía esta tabla o `project-resolve <nombre>`.
- Cada proyecto tiene su bundle en `projects/<slug>/`.
- Aliases permiten múltiples formas de nombrar el mismo proyecto.

## Tabla de proyectos

| slug | aliases | bundle root | sensitivity |
|---|---|---|---|
| `mi-primer-proyecto` | `mi primer proyecto`, `demo`, `primer` | `projects/mi-primer-proyecto` | operations |

## Cómo agregar un proyecto nuevo

1. Ejecutar `project-init <slug>` con flags apropiados.
2. El script crea `projects/<slug>/` con templates iniciales.
3. Esta tabla se actualiza automáticamente.

## Niveles de sensitivity

- `external` — proyecto público o cliente-facing.
- `operations` — interno operativo, default.
- `sensitive` — contiene datos críticos (financieros, personales).
- `private` — máxima restricción, requiere confirmación extra.
