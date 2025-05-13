
(
 (comment) @injection.content
 (#match? @injection.content "^///")
 (#gsub! @injection.content "^///" "")
 (#set! injection.language "xml")
 (#set! injection.combined)
)
