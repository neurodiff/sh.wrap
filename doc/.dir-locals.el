;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((org-mode
  (eval when (not (org-babel-lob--src-info "std/org/startup/sort"))
        (let ((init-file "init.org"))
          (org-babel-lob-ingest (concat (locate-dominating-file default-directory init-file) init-file))))
  (eval let ((info (org-babel-lob--src-info "std/org/startup/sort")))
        (org-babel-execute-src-block nil info '((:results . "silent"))))))
