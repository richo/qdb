;; Renders template in the current execution environment
(define-syntax render-template
  (syntax-rules ()
                ((render-template template)
                 (render-template/locals/environment template '() (interaction-environment)))
                ((render-template template locals)
                 (render-template/locals/environment template locals (interaction-environment)))))

(define render-template/locals/environment
  (lambda (template locals environment)
    (let ((tpl (load-template template)))
      (template-eval tpl locals environment))))

(define load-template
  (lambda (template-file)
    (read-file (string-append "views/" template-file))))


;; TODO Load these at boot time and check for validity

(define (template-eval exp locals env)
  (string-intersperse
    (map (lambda (el)
           (cond
             ((symbol? el)
              (symbol->string el))
             ((list? el)
              (if (equal? (car el) (quote ->))
                (cdr (assoc (cadr el) locals))
                (eval el env)))
             (else
               (error "Uncaught element"))))
       exp)
    " "))
