; extends
(
  call_expression
    function: (
        selector_expression
        operand: (identifier) @pkg
        field: (field_identifier) @fn)
    (#eq? @pkg "regexp")
    (#eq? @fn "MustCompile")
    arguments: (
        argument_list
        (raw_string_literal 
        (raw_string_literal_content) @injection.content
        (#set! injection.language "regex"))
    )
)

(
  call_expression
    function: (
        selector_expression
        operand: (identifier) @pkg
        field: (field_identifier) @fn)
    (#eq? @pkg "fmt")
    (#match? @fn "[Pp]rintf|Errorf")
    arguments: (
        argument_list
        (raw_string_literal 
        (raw_string_literal_content) @injection.content
        (#set! injection.language "printf"))
    )
)
