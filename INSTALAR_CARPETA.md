# Instalar el Mothership Method en una carpeta

**Para qué sirve:** para que tu asistente de IA no se olvide de lo que hablaron entre una conversación y la otra. Todo queda anotado en archivos de texto en una carpeta tuya.

**Para quién es este archivo:** para cualquiera. No hace falta saber programar ni abrir una terminal.

**Si ya venís trabajando con tu asistente y tenés notas de meses anteriores, este archivo también es para vos.** No hace falta migrar nada: se crea la carpeta nueva, se deja anotado dónde está tu material viejo para que tu asistente lo consulte cuando haga falta, y los temas que vuelvan a aparecer se van incorporando de a uno, cuando los estés trabajando. **Tus archivos anteriores no se tocan en ningún momento.**

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

Esto vale especialmente para `CLAUDE.md`. Si ya hay uno en esa carpeta, esa persona ya tiene una forma de trabajar acordada con vos y vale más que lo que trae este archivo: dejá sus reglas tal cual y proponé **sumar** debajo las secciones que le falten, guardando antes una copia como `CLAUDE.md.anterior`. Y si tiene un `CLAUDE.md` general en `~/.claude/`, **no lo toques**: ese aplica a todas sus conversaciones, no solo a esta carpeta.

Esta instalación no toca nada fuera de la carpeta elegida. Si en algún momento parece necesario modificar configuración del sistema, instalar algo, o escribir fuera de esa carpeta, **no lo hagas** — no forma parte de esto.

### Paso 1 — Elegir la carpeta

Por defecto, en la raíz del usuario:

- macOS o Linux: `~/mothership-workspace`
- Windows: `C:\Users\<usuario>\mothership-workspace`

En macOS, evitá `Documentos`, `Escritorio` y `Descargas`: el sistema las protege aparte y genera diálogos de permiso innecesarios. Si la persona prefiere otra ubicación, usá esa.

### Paso 1.5 — Preguntar por el material anterior

Preguntale: **"¿tenés notas o archivos de trabajo de antes, en otra carpeta?"**

Si dice que sí, pedile la ubicación y anotala — la vas a usar en el paso siguiente. **No la abras, no la leas y no copies nada de ahí.** Lo único que se hace con esa carpeta es dejar registrado dónde está.

Si dice que no, salteá la sección correspondiente del paso 2.

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

## Claves y contraseñas
Nunca escribas acá una clave, un token ni una contraseña. Si hace falta dejar
constancia, anotá dónde está guardada — por ejemplo "en 1Password, ítem tal" —
nunca el valor.

## Importante
- Nada de esto es automático ni obligatorio: si te pido otra cosa, hacé eso.
- Antes de reemplazar o mover un archivo de notas, avisame.
```

**Solo si en el paso 1.5 dijo que tiene material anterior**, agregá esta sección más, con la ruta que te dio:

```
## Material anterior
Mis notas de antes están en <ruta que dio la persona>. Si hablamos de algo que
puede estar ahí, buscá primero en esa carpeta antes de decirme que no sabés.
No la reorganices ni la modifiques: es solo para consultar. Si un tema de ahí
se vuelve recurrente, decímelo y armamos un proyecto con él.
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

### Paso 5 — El primer proyecto, con contenido real

**Este paso decide si el sistema se usa o queda abandonado.** Una carpeta vacía no
engancha a nadie; un proyecto con algo real adentro sí.

Preguntale sobre qué está trabajando **esta semana**: un cliente, un tema, un
asunto pendiente concreto. Que no sea un ejemplo inventado. Charlá dos o tres
minutos sobre eso —qué es, en qué quedó, qué sigue— y **escribí lo que te cuente**
en los archivos. Ese es el primer contenido de su memoria.

Usá el tema como nombre de carpeta, en minúsculas y con guiones (por ejemplo
`clientes-perez` o `mudanza-oficina`). Solo si insiste en no elegir nada, usá
`ejemplo` — pero intentá primero, porque un proyecto real vale mucho más.

Creá `projects/<nombre>/` con estos cinco archivos. Escribí lo que te haya
contado; lo que no sepas, dejalo vacío en vez de inventarlo.

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

Si dijo que tiene material anterior, agregá un cuarto punto: que sus notas viejas
quedaron donde estaban, sin tocar, y que vas a buscar ahí cuando el tema lo
amerite. Si alguna vuelve a aparecer seguido, le armás un proyecto con ella.

Si algo falló, decíselo con claridad en vez de dar la instalación por buena.

---

## Y con lo que ya tenías escrito, ¿qué pasa?

Nada. Se queda donde está, intacto.

La memoria arranca vacía y se llena con lo que vayas trabajando de ahora en
adelante. Cuando vuelva un tema viejo, tu asistente lo busca en la carpeta que le
indicaste, y si ves que ese tema aparece seguido, le pedís que le arme un proyecto
propio. Uno por vez, cuando hace falta, y con vos presente.

Es a propósito: **de meses de notas, la mayoría no se vuelve a usar.** Organizarlo
todo por adelantado es trabajo sobre material muerto, y obliga a que tu asistente
adivine cómo agrupar cosas que solo vos sabés cómo se relacionan.

Si en algún momento querés hacer la mudanza completa de una vez, existe
[ADOPTAR_LO_QUE_YA_TENGO.md](ADOPTAR_LO_QUE_YA_TENGO.md). No es necesario, y no es
por donde conviene empezar.

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
