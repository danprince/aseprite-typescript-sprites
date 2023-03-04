# TypeScript Sprites

Aseprite extension for generating TypeScript files from sprite slices.

<img width="929" alt="image" src="https://user-images.githubusercontent.com/1266011/222885234-01303626-0776-4dbb-b694-f67c29167b0f.png">

Will export a TypeScript file like this:

```ts
// Generated by 'Export TypeScript Sprites' Aseprite Extension
import url from "./sprites.png"
export const pirate = { url, y: 0, h: 16, w: 16, x: 0, };
export const slime = { url, y: 0, h: 16, w: 16, x: 16, };
export const djinn = { url, y: 0, h: 16, w: 16, x: 32, };
export const ring = { url, y: 16, h: 16, w: 16, x: 0, };
export const vampire = { url, y: 16, h: 16, w: 16, x: 16, };
export const necronomicon = { url, y: 16, h: 16, w: 16, x: 32, };
export const potion = { url, y: 32, h: 16, w: 16, x: 0, };
export const flamberge = { url, y: 32, h: 16, w: 16, x: 16, };
export const books = { url, y: 32, h: 16, w: 16, x: 32, };
```

Then you can reference these sprites with full type safety. Deleting or renaming a sprite creates a verifiable type error.

```ts
import * as sprites from "./sprites.ts";

sprites.imp
//      ^^^
// Property 'imp' does not exist ...
```

<details>
<summary>Aseprite already supports a JSON export, but it's awkward to consume.
</summary>
```json
{ "frames": {
   "sprites.aseprite": {
    "frame": { "x": 0, "y": 0, "w": 48, "h": 48 },
    "rotated": false,
    "trimmed": false,
    "spriteSourceSize": { "x": 0, "y": 0, "w": 48, "h": 48 },
    "sourceSize": { "w": 48, "h": 48 },
    "duration": 100
   }
 },
 "meta": {
  "app": "https://www.aseprite.org/",
  "version": "1.3-beta21-arm64",
  "image": "sprites.png",
  "format": "RGBA8888",
  "size": { "w": 48, "h": 48 },
  "scale": "1",
  "frameTags": [
  ],
  "layers": [
   { "name": "Layer 1", "opacity": 255, "blendMode": "normal" }
  ],
  "slices": [
   { "name": "dread_pirate", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 0, "y": 0, "w": 16, "h": 16 } }] },
   { "name": "slime", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 16, "y": 0, "w": 16, "h": 16 } }] },
   { "name": "djinn", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 32, "y": 0, "w": 16, "h": 16 } }] },
   { "name": "ring", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 0, "y": 16, "w": 16, "h": 16 } }] },
   { "name": "vampire", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 16, "y": 16, "w": 16, "h": 16 } }] },
   { "name": "necronomicon", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 32, "y": 16, "w": 16, "h": 16 } }] },
   { "name": "potion", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 0, "y": 32, "w": 16, "h": 16 } }] },
   { "name": "flamberge", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 16, "y": 32, "w": 16, "h": 16 } }] },
   { "name": "books", "color": "#0000ffff", "keys": [{ "frame": 0, "bounds": {"x": 32, "y": 32, "w": 16, "h": 16 } }] }
  ]
 }
}
```

</details>

Even with `resolveJsonModule` it's not possible to do the equivalent of `as const` with a JSON import, meaning that the sprites names are always generalised as `string` in the resolved type.

## Usage
Grab the extension from the [latest release](https://github.com/danprince/aseprite-typescript-sprites/releases) and [install it](https://www.aseprite.org/docs/extensions/).

Then you can either press <kbd>⌘ ⇧ E</kbd> or go to "File > Export TypeScript" to export the active sprite to PNG and TS files next to the Asesprite file.

For example, if you have the following file structure:

```
src/
  sprites.aseprite
```

After exporting, you will have:

```
src/
  sprites.aseprite
  sprites.ts
  sprites.png
```

### Pivot
Sprites that have defined a pivot point will export it.

```ts
export const door = { url, y: 16, h: 16, w: 16, x: 0, pivot: { x: 0, y: 16 } };
```

### 9-Slices
Sprites that have defined a 9 slice will export it.

```ts
export const panel = { url, y: 16, h: 16, w: 16, x: 0, center: { x: 1, y: 1, w: 14, h: 14 } };
```

`center` is the central rectangle of the 9 slice, and you can use it to infer the other 8 rectangles.

## Caveats
- Slice names that start with numbers, or collide with reserved words in JavaScript will be prefixed with an `_`. For example a slice called `9_headed_hydra` would become `export const _9_headed_hydra`.
- It's not possible to control the PNG part of the export with any of the options you're used to seeing with a conventional sprite export. All layers are exported and it will always export at 1x resolution with no border padding or spacing.
- It's not possible to control the export destination of the resulting PNG and TS files. They will always export next to the source `.aseprite` file.
