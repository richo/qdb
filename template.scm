;; Renders template in the current execution environment
(define-syntax render-template
  (syntax-rules ()
                ((render-template template)
                 (render-template/locals/environment template '() (interaction-environment)))
                ((render-template template locals)
                 (render-template/locals/environment template locals (interaction-environment)))))

(define render-template/locals/environment
  (lambda (template locals environment)
    (load-template template)))

(define load-template
  (lambda (template-file)
    (read-all (string-append "views/" template-file))))


;; TODO Load these at boot time and check for validity
