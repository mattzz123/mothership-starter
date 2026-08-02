# Empezar acá — el mensaje que le pasás a tu IA

Esto es lo único que hace falta. No hay que instalar nada a mano ni tocar ninguna configuración.

---

## Antes de pegar el mensaje

1. Abrí **Claude** en tu computadora.
2. Andá a la pestaña **Code** (arriba, junto a Chat).
3. Te va a pedir que elijas una carpeta. **Por esta vez elegí cualquiera** — por ejemplo `Documentos`. Es solo para arrancar; después vas a usar siempre la misma carpeta nueva que te va a quedar creada.

> **En Windows:** la primera vez, la pestaña Code pide tener instalado **Git for Windows** ([git-scm.com/downloads/win](https://git-scm.com/downloads/win)). Si te lo pide, instalalo y **cerrá y volvé a abrir Claude**. Es un solo paso y no se repite nunca más.

---

## El mensaje

Copiá todo lo que está adentro del recuadro y pegalo en el chat:

```
Quiero que instales en mi computadora el "Mothership Method": un sistema para que
no te olvides de lo que hablamos entre una conversación y la otra.

Instalalo vos entero. Yo no sé programar, así que no me pidas que edite archivos,
que abra una terminal, ni que copie y pegue configuraciones.

Pasos:
1. Descargá el sistema:
   git clone https://github.com/mattzz123/mothership-starter.git "$HOME/mothership-starter"
2. Entrá a esa carpeta y leé el archivo BOOTSTRAP_FOR_AGENT.md COMPLETO, de principio a fin.
3. Seguí todos los pasos que indica, del 1 al 8, sin saltearte ninguno.
4. Cuando termines, decime en 3 puntos simples cómo lo uso de acá en adelante,
   y sobre todo cuál es la carpeta que tengo que elegir siempre al abrir una conversación.

Si algo falla, explicame con tus palabras qué pasó — no me muestres errores técnicos.
Si necesitás mi permiso para algo, pedímelo antes.
```

Y mandalo. La IA hace el resto sola: tarda un par de minutos.

---

## Cuando termine

Te va a decir el nombre de una carpeta nueva (normalmente **`mothership-workspace`**, dentro de tu carpeta de usuario).

**A partir de ahí, la única regla es esta: cada vez que abras una conversación en la pestaña Code, elegí siempre esa misma carpeta.**

Ahí adentro vive tu memoria. Son archivos de texto comunes: podés abrirlos y leerlos cuando quieras. Si algún día cambiás de computadora, copiás esa carpeta y te llevás todo.

---

## Cómo se usa, en una línea

Le hablás normal. "Trabajemos en el cliente Pérez", "arrancá un proyecto para el curso de historia", "¿en qué quedamos con la mudanza?".

Ella sola busca en tu memoria, retoma donde dejaron, y **al terminar deja anotado lo que hicieron** para la próxima vez. No tenés que pedírselo.
