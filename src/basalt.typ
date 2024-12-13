#let package-name = "basalt-lib"
#let package-uuid = "73d1af09-0bac-4c2c-94b0-b38f173b7a2a"
#let prefix = package-uuid + ":" + package-name + ":"

#let super-str(any) = {
  let t = type(any)
  if t == int or t == float or t == version or t == bytes or t == label or t == type or t == str {
    return str(any)
  }
  if t == datetime {
    return any.display("[year]-[month]-[day]-[hour]-[minute]-[second]")
  }
}

#let note-label-string = prefix + "note:"
#let note-label = label(note-label-string)

#let metadata-label(meta) = {
  let pairs = meta.pairs().sorted(key: pair => pair.first())
  let l = note-label-string
  for pair in pairs {
    l += super-str(pair.at(0)) + "." + super-str(pair.at(1)) + ":"
  }
  return label(l.replace(regex("[^a-zA-Z0-9_\-:.]"), "_"))
}

#let note(..sink) = {
  return sink.named()
}

#let note-meta(note) = [
  #return note()
]

#let note-anchor(note) = [
  #let meta = metadata(note())
  #meta #metadata-label(note())
  #meta #note-label
  #meta #label("note")
]

#let note-query(processor, ..sink) = context {
  let targets = sink.named()
  let metas = query(note-label).map(note => note.fields().at("value"))
  for target in targets {
    metas = metas.filter(meta => meta.pairs().contains(target))
  }
  return processor(metas)
}

#let note-label-query(processor, ..sink) = context {
  let targets = sink.named()
  let metas = query(note-label).map(note => note.fields().at("value"))
  for target in targets {
    metas = metas.filter(meta => meta.pairs().contains(target))
  }
  let labels = metas.map(meta => metadata-label(meta))
  return processor(labels)
}

#let xlink(body, ..sink) = note-query(..sink.named(), notes => {
  if notes.len() != 1 {
    panic("Matches to (" + notes.join(", ") + ") should be one but are " + str(notes.len()))
  }
  return link(metadata-label(notes.first()), body)
})
