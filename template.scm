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

(define template-inline-subst
  (lambda (exp locals env)
    (map (lambda (el)
           (if (list? el)
              (if (equal? (car el) (quote ->))
                (cdr (assoc (cadr el) locals))
                (template-inline-subst el locals env))
             el))
         exp)))

;; Toplevel eval deals with string emitting valid markup, etc.
(define template-toplevel-eval
  (lambda (exp locals env)
     (cond
       ((string? exp)
        (string-append "\"" exp "\""))
       ((symbol? exp)
        (symbol->string exp))
       ((list? exp)
        (if (equal? (car exp) (quote ->))
          (cdr (assoc (cadr exp) locals))
          (eval (template-inline-subst exp locals env))))
       (else
         (error "Uncaught toplevel element")))))

(define (template-eval exp locals env)
  (string-intersperse
    (map (lambda (el)
           (template-toplevel-eval el locals env))
       exp)
    " "))
