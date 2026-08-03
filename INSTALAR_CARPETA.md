# Instalar el Mothership Method en una carpeta

**Para qué sirve:** para que tu asistente de IA no se olvide de lo que hablaron entre una conversación y la otra. Todo queda anotado en archivos de texto en una carpeta tuya.

**Para quién es este archivo:** para cualquiera. No hace falta saber programar ni abrir una terminal.

---

## Qué hace exactamente, y qué no hace

Esta instalación **crea nueve archivos de texto dentro de una sola carpeta**. Nada más.

| Sí hace | No hace |
|---|---|
| Crea una carpeta y archivos de notas adentro | No instala ningún programa |
| Los archivos son texto plano: los abrís y los leés | No copia scripts ni nada ejecutable |
| Todo queda dentro de esa carpeta | No instala procesos que corran solos |
| Para desinstalar, borrás la carpeta | No modifica la configuración de tu asistente ni de tu computadora |
| | No se conecta a ningún servidor ni manda datos a ningún lado |

Si en algún momento querés la versión con automatizaciones —comandos y verificaciones que corren solos— existe, es opcional, y está al final de este archivo. **No es parte de esto.**

---

## Cómo se instala

Abrí tu asistente (Claude, en la pestaña **Code**), elegí una carpeta cualquiera para empezar, y mandale este mensaje:

```
Leé https://github.com/mattzz123/mothership-starter/blob/main/INSTALAR_CARPETA.md
y seguí la sección "Instrucciones para el asistente".

Antes de crear nada, mostrame la lista de archivos que vas a crear y dónde.
```

Eso es todo. Tarda menos de un minuto.

---

## Instrucciones para el asistente

Lo que sigue está dirigido al asistente de IA que hace la instalación.

### Antes de empezar

Mostrale a la persona qué vas a crear y dónde, y esperá su confirmación. Si alguno de estos archivos ya existe, **no lo sobrescribas**: avisale y preguntale qué prefiere.

Esta instalación no toca nada fuera de la carpeta elegida. Si en algún momento parece necesario modificar configuración del sistema, instalar algo, o escribir fuera de esa carpeta, **no lo hagas** — no forma parte de esto.

### Paso 1 — Elegir la carpeta

Por defecto, en la raíz del usuario:

- macOS o Linux: `~/mothership-workspace`
- Windows: `C:\Users\<usuario>\mothership-workspace`

En macOS, evitá `Documentos`, `Escritorio` y `Descargas`: el sistema las protege aparte y genera diálogos de permiso innecesarios. Si la persona prefiere otra ubicación, usá esa.

### Paso 2 — `CLAUDE.md` en la raíz de la carpeta

Este es el único archivo con contenido de comportamiento, y su alcance es esa carpeta: se carga cuando la persona la abre, y deja de aplicar cuando trabaja en otro lado.

```
# Cómo trabajamos en esta carpeta

Esta carpeta es mi memoria de trabajo. Todo acá son notas en texto plano:
se pueden abrir, leer y editar a mano.

## Al empezar una conversación
Leé PROJECT_REGISTRY.md para ver qué proyectos existen. Cuando nombre uno,
abrí projects/<proyecto>/FAST_RESUME.md para saber en qué quedamos.

## Al terminar
Si hicimos algo que valga la pena recordar, antes de cerrar actualizá,
en el proyecto que corresponda:
- LOG.md — qué se hizo, cuándo y por qué
- NEXT.md — qué queda pendiente
- FAST_RESUME.md — el estado de hoy, en 3 o 4 líneas
Y una línea en CROSS_SYNC.md de la raíz.

Escribí en castellano y en lenguaje llano: estas notas las leo yo, no un programa.

## Proyectos nuevos
Un proyecto es una carpeta dentro de projects/ con SUMMARY.md (de qué se trata),
FAST_RESUME.md (dónde quedamos), NEXT.md (pendientes), LOG.md (historial) e
INDEX.md. Copiá la estructura del proyecto que ya existe.

## Importante
- Nada de esto es automático ni obligatorio: si te pido otra cosa, hacé eso.
- Antes de reemplazar o mover un archivo de notas, avisame.
```

### Paso 3 — `PROJECT_REGISTRY.md` en la raíz

```
# Proyectos

Un renglón por proyecto. Sirve para encontrarlos por su nombre común.

| Carpeta | De qué se trata | Cómo lo llamo |
|---|---|---|
| | | |
```

### Paso 4 — `CROSS_SYNC.md` en la raíz

```
# Bitácora general

Los cambios importantes, uno por línea, lo más nuevo arriba.
Sirve para ver de un vistazo qué pasó últimamente, sin importar el proyecto.

Formato: fecha — proyecto — qué cambió — por qué.
```

### Paso 5 — El primer proyecto

Preguntale a la persona sobre qué quiere trabajar primero: un cliente, un tema,
un asunto pendiente. Usá eso como nombre de carpeta, en minúsculas y con guiones
(por ejemplo `clientes-perez` o `mudanza-oficina`). Si prefiere no decidirlo
ahora, usá `ejemplo`.

Creá `projects/<nombre>/` con estos cinco archivos. Completá lo que la persona
te haya contado; lo que no sepas, dejalo vacío en vez de inventarlo.

`SUMMARY.md`

```
# <Nombre del proyecto>

De qué se trata, en dos o tres líneas.

## Qué quiero lograr

## Datos que no quiero volver a explicar
```

`FAST_RESUME.md`

```
# <Nombre del proyecto> — Dónde quedamos

## Estado hoy

## Último cambio

## Lo próximo
```

`NEXT.md`

```
# <Nombre del proyecto> — Pendientes

Solo lo que sigue. Lo terminado se mueve a LOG.md.

-
```

`LOG.md`

```
# <Nombre del proyecto> — Historial

Lo más nuevo arriba.

## <fecha de hoy>
- Proyecto creado.
```

`INDEX.md`

```
# <Nombre del proyecto> — Qué hay acá

- SUMMARY.md — de qué se trata
- FAST_RESUME.md — dónde quedamos
- NEXT.md — pendientes
- LOG.md — historial
```

### Paso 6 — Verificar y explicar

Listá los archivos creados para que la persona los vea. Después explicale, en su
idioma y sin términos técnicos, estas tres cosas:

1. Todo lo que trabajen queda anotado en esa carpeta, y vos la leés sola al empezar.
2. **La única regla: abrir siempre la conversación eligiendo esa misma carpeta.**
3. Son archivos de texto comunes. Los puede abrir, leer y corregir cuando quiera.
   Si cambia de computadora, copia la carpeta y se lleva todo.

Si algo falló, decíselo con claridad en vez de dar la instalación por buena.

---

## Cómo desinstalar

Borrás la carpeta. No queda nada en ningún otro lado.

---

## Respaldo

Los archivos viven solo en esa computadora. Si el disco falla, se pierden.

Dos opciones, de menor a mayor esfuerzo: poner la carpeta en un servicio de
sincronización (Drive, iCloud, Dropbox), o versionarla con `git` en un repositorio
privado — esto último además da historial y permite volver atrás.

---

## El nivel siguiente, opcional

Existe una versión con automatizaciones: comandos para crear y respaldar proyectos,
y verificaciones que se ejecutan solas al cerrar cada sesión para que la
documentación no se saltee.

Eso **sí** instala archivos ejecutables y **sí** modifica la configuración de tu
asistente, de forma permanente y para todas tus conversaciones. Es una decisión
distinta de la de acá, y conviene tomarla entendiendo qué hace cada pieza. Está en
`README.md` de este mismo repositorio.

La versión en carpeta funciona por sí sola. No hace falta pasar al nivel siguiente.
