#import "error-handling.typ": check-required-argument
#import "metadata-with-id.typ": get-metadata, id-metadata, metadata-with-id
#import "tag.typ": tag

#let get-notes(body) = {
  check-required-argument(get-notes, body, "body", content)

  let notes = get-metadata(
    body
  ).filter(
    metadata-with-id
  ).map(metadata => {
    metadata.value
  }).filter(meta => {
    meta.id == tag("note")
  }).map(meta => {
    meta.data
  })

  if notes.len() == 0 {
    panic(repr(get-notes) + " called on file with no note metas:\n" + repr(body))
  }

  return notes
}

#let matching-note(query, note) = {
  check-required-argument(matching-note, query, "query", arguments)
  check-required-argument(matching-note, note, "note", dictionary)

  let (qnamed, mnamed) = (query.named(), note.meta.named())
  let (qpos, mpos) = (query.pos(), note.meta.pos())
  
  return qnamed.keys().all(qkey => {
    mnamed.keys().contains(qkey) and mnamed.at(qkey) == qnamed.at(qkey)
  }) and qpos.all(qval => {
    mpos.contains(qval)
  })
}

#let new-root(
  formatter: (),
  meta: (:),
  body,
) = {
  let formatter = formatter.with(meta: meta)
  let note-label = label(repr(meta))

  let inner-meta = id-metadata(
    tag("note"),
    (
      meta: meta,
      body: none,
    )
  )
  let outer-meta = id-metadata(
    tag("note"),
    (
      meta: meta,
      body: {
        show: formatter.with(root: false)
        [
          #inner-meta
          #note-label
        ]
        body
      },
    ),
  )

  show: formatter.with(root: true)
  [
    #outer-meta
    #note-label
  ]
  body
}

#let as-branch(content) = {
  return get-notes(content).first().body
}
