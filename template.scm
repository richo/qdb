;; Renders template in the current execution environment
(define render-template
  (lambda (template #!optional (locals '()))
            (render-template/locals template locals)))

(define render-template/locals
  (lambda (template locals)
    (let ((tpl (load-template template)))
      (template-eval tpl locals))))

(define load-template
  (lambda (template-file)
    (read-file (string-append "views/" template-file))))


;; TODO Load these at boot time and check for validity

(define template-inline-subst
  (lambda (exp locals)
    (map (lambda (el)
           (if (list? el)
              (if (equal? (car el) (quote ->))
                (cdr (assoc (cadr el) locals))
                (template-inline-subst el locals))
             el))
         exp)))

;; Toplevel eval deals with string emitting valid markup, etc.
(define template-toplevel-eval
  (lambda (exp locals)
     (cond
       ((string? exp)
        (string-append "\"" exp "\""))
       ((symbol? exp)
        (symbol->string exp))
       ((list? exp)
        (if (equal? (car exp) (quote ->))
          (cdr (assoc (cadr exp) locals))
          (eval (template-inline-subst exp locals))))
       (else
         (error "Uncaught toplevel element")))))

(define (template-eval exp locals)
  (string-intersperse
    (map (lambda (el)
           (template-toplevel-eval el locals))
       exp)
    " "))
