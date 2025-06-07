#import "error-handling.typ": check-required-argument
#import "xlink.typ": format-xlinks
#import "note.typ": new-root

#let apply-formatters(formatters, body, ..args) = {
  check-required-argument(apply-formatters, formatters, "formatters", array)
  check-required-argument(apply-formatters, body, "body", content)

  if formatters.len() == 0 {
    return body
  }

  show: formatters.first().with(..args)
  apply-formatters(formatters.slice(1), body, ..args)
}

#let new-vault(
  note-paths: array,
  formatters: array,
  include-from-vault: function,
) = {
  check-required-argument(new-vault, note-paths, "note-paths", array)
  check-required-argument(new-vault, formatters, "formatters", array)
  check-required-argument(
    new-vault,
    include-from-vault,
    "include-from-vault",
    function,
    hint: "add it as `path => include path`",
  )

  let formatter = apply-formatters.with(
    (
      formatters,
      format-xlinks.with(include-from-vault, note-paths),
    ).flatten()
  )

  return (
    new-note: (body, ..meta) => new-root(
      body,
      meta: meta,
      formatter: formatter,
    ),
  )
}
