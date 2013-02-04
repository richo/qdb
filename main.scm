#!/usr/bin/env csi -ss

(use srfi-1)

(require "pilgrim/pilgrim")
(require "templort/templort")

(require "database")

(define qdb-port
  (lambda () (string->number (get-environment-variable "PORT"))))

(define render-template
  (make-renderer "views"))

(define quote-writer
  (make-writer "db"))

(define quote-reader
  (make-reader "db"))

(define parse-quote
  (lambda (q)
    (substring q (+ 1 (string-index q #\=)))))

(define all-quotes
  (lambda ()
    (letrec ((main (lambda (prg id)
                     (let ((next (quote-reader id)))
                       (if next
                         (main (alist-update id next prg) (+ id 1))
                         prg)))))
      (main '() 1))))

(define main
  (lambda (argv)
    (start (qdb-port) (lambda (request response)
                      (let ((request-path (get-request-path request))
                            (request-method (get-request-method request)))
                        (cond
                          ((equal? request-path "/")
                           (set-response-body (render-template "index.html")
                                              response))
                          ((equal? request-path "/quotes")
                             (set-response-body (render-template "quotes.html" `((quotes . ,(all-quotes))))
                                              response))
                          ((string-prefix? "/quotes/" request-path)
                           (let* ((quote-id (string->number
                                            (substring request-path
                                                       (+ 1 (string-index-right request-path #\/)))))
                                  (quote-content (quote-reader quote-id))
                                  )
                             (set-response-body (render-template "quote.html"
                                                               `((quote-id . ,quote-id)
                                                                 (quote-content . ,quote-content)))
                                                response)))
                          ((equal? request-path "/submit")
                           (cond ((equal? request-method "GET")
                             (set-response-body (render-template "submit.html")
                                                response))
                                 ((equal? request-method "POST")
                             (let* ((new-quote (parse-quote (get-request-body request)))
                                    (new-id (quote-writer new-quote)))
                               (set-response-body (render-template "submitted.html"
                                                                   `((new-id . ,(number->string new-id))
                                                                     (new-quote . ,new-quote)
                                                                     (quote-link . ,(string-append "\"" "/quotes/" (number->string new-id) "\""))))
                                                response)))))
                          (else
                           (set-response-status 404
                           (set-response-body "Page not found"
                                              response)))
                        ))))))
