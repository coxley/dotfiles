; extends
(
  call
  function: (identifier) @fn (#eq? @fn "gql")
  arguments: (argument_list
    (string
      (string_content) @injection.content
      (#set! injection.language "graphql")
    )
  )
)
