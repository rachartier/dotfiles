;; extends

; offset and table chars courtesy of `megalithic`:
; https://github.com/megalithic/dotfiles/blob/39aa5fcefaa4d68cce66b6de425311e47c2d54fb/config/nvim/after/queries/markdown/highlights.scm#L45-L64

; list markers/bullet points
; (
;   ([
;     (list_marker_star)
;     (list_marker_plus)
;     (list_marker_minus)
;   ]) @markdown_list_marker
;   (#offset! @markdown_list_marker 0 0 0 -1)
;   (#set! conceal "◉")
; )

; checkboxes
((task_list_marker_unchecked) @markdown_check_undone (#set! conceal "󰄱"))
((task_list_marker_checked) @markdown_check_done (#set! conceal "󰄲"))

; box drawing characters for tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "─"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "│"))

; block quotes
((block_quote_marker) @markdown_quote_marker (#set! conceal "▍"))
((block_quote
  (paragraph (inline
    (block_continuation) @markdown_quote_marker (#set! conceal "▍")
  ))
))

; (fenced_code_block
;   (info_string) @devicon
;   (#as_devicon! @devicon))

(
  fenced_code_block (fenced_code_block_delimiter) @markdown_code_block_marker
  (#set! conceal " ")
)
