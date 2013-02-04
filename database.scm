; A really stupid database. It doesn't care about efficiency, but it does support
; concurrency.
;
; Returns the current highest ID in the database
(define current-id
  (lambda (db-path)
    (letrec ((contents (directory db-path))
             (find-max (lambda (names _max)
                         (if (null-list? names)
                           _max
                           (let ((this (string->number (car names))))
                             (cond ((equal? this #f)
                                    (find-max (cdr names) _max))
                                   (else
                                     (find-max (cdr names) (max _max this)))))))))
      (find-max contents 0))))

(define mkdir
  (lambda (dir)
    (let ((orig (current-exception-handler)))
      (with-exception-handler
        (lambda (exn)
          (if (directory-exists? dir)
            #f
            (orig exn)))
        (lambda ()
          (create-directory dir #f #t)
          #t)))))

; Returns a writer procedure that returns the ID's of newly written objects.
(define make-writer
  (let ((writer (lambda (db-path)
    (lambda (content)
      (let* ((current (current-id db-path))
             (next-id (+ current 1))
             (next-path (string-append db-path "/" (number->string next-id))))
        (if (mkdir next-path)
               (with-output-to-file (string-append next-path "/content")
                                    (lambda () (display content) next-id))
               (writer content)))))))
    writer))

; Returns a reader procedure that returns a string, or #f if the object doesn't exist
(define make-reader
  (lambda (db-path)
    (lambda (id)
      (let ((path (string-append db-path "/" (number->string id) "/content")))
        (if (file-exists? path)
          (read-all path)
          #f)))))
