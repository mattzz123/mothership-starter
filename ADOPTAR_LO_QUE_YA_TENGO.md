# Organizar como memoria lo que ya venís escribiendo

**Para quién es:** para el que ya viene trabajando con su asistente de IA y tiene notas, resúmenes y archivos sueltos de varios meses. No hace falta empezar de cero: eso que ya está escrito **es** la memoria, solo que desordenada.

Si arrancás sin nada, usá [INSTALAR_CARPETA.md](INSTALAR_CARPETA.md) en lugar de este archivo.

---

## Qué hace exactamente, y qué no hace

| Sí hace | No hace |
|---|---|
| Lista lo que ya tenés y te lo muestra antes de tocar nada | **No borra ni mueve ningún archivo tuyo** |
| Agrupa tus notas por tema, con tu confirmación | No reescribe lo que ya escribiste |
| **Copia** tus archivos a la estructura nueva | No manda nada a ningún servidor |
| Escribe un resumen por tema, leyendo lo que ya está | No instala programas ni nada ejecutable |
| Los originales quedan exactamente donde están | No modifica la configuración de tu asistente |

Si algo sale mal, no perdiste nada: tus archivos originales quedan intactos.

---

## Cómo se hace

Abrí tu asistente en la pestaña **Code**, elegí la carpeta donde tenés tus notas, y mandale:

```
Leé https://github.com/mattzz123/mothership-starter/blob/main/ADOPTAR_LO_QUE_YA_TENGO.md
y seguí la sección "Instrucciones para el asistente".

Empezá por el inventario y mostrámelo antes de crear o copiar nada.
```

---

## Instrucciones para el asistente

Lo que sigue está dirigido al asistente de IA.

**Regla que gobierna todo lo demás:** los archivos existentes de esta persona son trabajo real de meses. **No borres, no muevas y no reescribas ninguno.** Copiá. El original se queda donde está, sin modificar. Si en algún momento parece necesario borrar o mover algo, no lo hagas — preguntá.

Esto no toca nada fuera de la carpeta de trabajo. No instala nada.

### Paso 0 — Elegir la variante

Miralo antes de proponer nada:

- **Si las notas ya están casi todas en una misma carpeta** → no consolides nada. Esa carpeta pasa a ser el espacio de trabajo y le agregás la estructura encima. Es la variante preferida: cero movimiento de archivos y la persona no cambia de hábitos.
- **Si están dispersas** (varias carpetas, escritorio, descargas) → creá un espacio de trabajo nuevo en `~/mothership-workspace` (Windows: `C:\Users\<usuario>\mothership-workspace`) y **copiá** hacia ahí.

Decile cuál de las dos aplica y por qué, antes de seguir.

### Paso 1 — Inventario, sin leer todo

Listá los archivos de notas: nombre, fecha de última modificación, tamaño y, en una línea, de qué parece tratar cada uno. No hace falta leerlos enteros todavía — con el nombre y las primeras líneas alcanza.

Mostrale la lista y preguntale dos cosas:

1. **¿Hay algo acá que no deba entrar?** Datos de clientes, información sensible, cosas personales. Lo que diga que no, queda afuera y no se copia.
2. ¿Falta algo que esté en otro lado?

Si hay más de 50 archivos, mostrá los 20 más recientes y avisá cuántos quedan; no listes cientos de una vez.

### Paso 2 — Proponer la agrupación

Agrupá por tema y proponé un proyecto por grupo. Algo así:

> - Proyecto `clientes-perez` ← estos 4 archivos
> - Proyecto `mudanza-oficina` ← estos 2
> - Estos 3 no sé dónde ubicarlos, ¿me ayudás?

Usá nombres cortos, en minúscula y con guiones. **Esperá que confirme o corrija antes de crear nada.** Si dice que dos grupos son en realidad uno, unilos.

### Paso 3 — Crear la estructura

En la carpeta que corresponda según el Paso 0, creá `CLAUDE.md` con este contenido exacto:

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
INDEX.md. Copiá la estructura de un proyecto que ya exista.

## Claves y contraseñas
Nunca escribas acá una clave, un token ni una contraseña. Si hace falta dejar
constancia, anotá dónde está guardada — por ejemplo "en 1Password, ítem tal" —
nunca el valor.

## Importante
- Nada de esto es automático ni obligatorio: si te pido otra cosa, hacé eso.
- Antes de reemplazar o mover un archivo de notas, avisame.
```

Y `PROJECT_REGISTRY.md`:

```
# Proyectos

Un renglón por proyecto. Sirve para encontrarlos por su nombre común.

| Carpeta | De qué se trata | Cómo lo llamo |
|---|---|---|
| | | |
```

Y `CROSS_SYNC.md`:

```
# Bitácora general

Los cambios importantes, uno por línea, lo más nuevo arriba.
Sirve para ver de un vistazo qué pasó últimamente, sin importar el proyecto.

Formato: fecha — proyecto — qué cambió — por qué.
```

### Paso 4 — Un proyecto por vez

Para cada grupo confirmado, creá `projects/<nombre>/` y adentro:

**a) `fuentes/`** — copiá ahí los archivos originales de ese grupo, con el nombre que ya tienen. Es el material crudo: no lo edites ni lo resumas.

**b) Los cinco archivos del proyecto**, escritos **leyendo** ese material:

- `SUMMARY.md` — de qué se trata, en dos o tres líneas, y qué se quiere lograr.
- `FAST_RESUME.md` — **dónde quedó la cosa**, según lo último que aparezca escrito. Tres o cuatro líneas.
- `NEXT.md` — los pendientes que aparezcan mencionados. Si no hay ninguno claro, dejalo vacío.
- `LOG.md` — el historial. Si los archivos tienen fechas, respetalas y ordená de más nuevo a más viejo. Si no las tienen, una sola entrada de hoy: "Material previo incorporado desde `fuentes/`".
- `INDEX.md` — qué hay en la carpeta, incluyendo qué archivos quedaron en `fuentes/`.

**Reglas del destilado, importantes:**

- **No inventes.** Si algo no está claro en el material, preguntalo o dejalo vacío. Es preferible un `NEXT.md` en blanco a uno con pendientes imaginados.
- **No interpretes ni corrijas** el contenido original. Tu tarea es ubicar y resumir, no mejorar lo que escribió.
- Si el material se contradice (algo dado por hecho en un archivo y pendiente en otro), no elijas por tu cuenta: señalalo y preguntá.
- Andá de a un proyecto y mostrá el resultado antes de pasar al siguiente. Si son muchos, empezá por los dos más importantes y preguntá si sigue.

### Paso 5 — Registro y bitácora

Completá `PROJECT_REGISTRY.md` con una fila por proyecto, usando **los nombres con los que esa persona habla de cada cosa**, no los técnicos.

Agregá una línea a `CROSS_SYNC.md` con la fecha de hoy: qué material se incorporó y de dónde.

### Paso 6 — Verificar y explicar

Mostrale la estructura final. Después, en su idioma y sin términos técnicos:

1. Todo lo que ya tenía escrito está ahora ordenado por tema, y sus archivos originales siguen intactos donde estaban.
2. **La única regla: abrir siempre la conversación eligiendo esa misma carpeta.**
3. De acá en adelante, cuando terminen algo importante, vos dejás anotado dónde quedaron.

Si algo falló o quedó a medias, decíselo con claridad en vez de dar el trabajo por terminado.

---

## Qué pasa con los originales

Se quedan donde estaban. Nada se borra ni se mueve.

Cuando compruebe que la carpeta nueva funciona, puede archivar los originales por su cuenta si quiere — pero eso es decisión suya, en otro momento, y no forma parte de esto.

---

## Respaldo

Los archivos viven solo en esa computadora. Si el disco falla, se pierden.

Lo más simple: poner la carpeta en un servicio de sincronización. Lo más completo: versionarla con `git` en un repositorio privado, que además da historial y permite volver atrás.
