# Usage

We define a note as a .typ file that contains at minimum the following:

```typ
#import "<BASALT>": note
```

To define some metadata for your note, you should extend note like so:

```typ
#let note = note.with(
  uuid: "rupak-katak",
  name: "My awesome note",
)
// Note that the "let" is important.
```

Basalt doesn't have an opinion on what metadata you use.
But, I would recommend setting a uuid for each note that never changes so that you can have permanent links.

Speaking of links, you can link between notes.

```typ
#import "<BASALT>": xlink

#xlink(uuid: "nunub-gotub")[Here's] a cross-note link.
```

To view your notes, we need one more file.
This file will serve to put all the notes together, since right now they can't see each other.

```typ
// eg. vault.typ
#import "<BASALT>": note-anchor, note-meta

#let paths = (
  "./note1.typ",
  "./note2.typ",
)

#for path in paths [
  #import path: note
  #let meta = note-meta(note)
  #let anchor = note-anchor(note)
  = #anchor #meta.name
  #include(path)
]
```

This is essentially all you need.
You can apply global styles, note-specific styles, templates, etc. in this file.
