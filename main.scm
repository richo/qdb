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
                           (let ((db-quotes (list "This is a quote" "This is also a quote")))
                             (set-response-body (render-template "quotes.html" `((quotes . ,db-quotes)))
                                              response)))
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
                                                response))))

                          (else
                           (set-response-status 404
                           (set-response-body "Page not found"
                                              response)))
                        ))))))
