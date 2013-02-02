#!/usr/bin/env csi -ss

(use srfi-1)

(require "pilgrim/pilgrim")
(require "templort/templort")

(define qdb-port
  (lambda () (string->number (get-environment-variable "PORT"))))

(define render-template
  (make-renderer "views"))

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
                          ((equal? request-path "/submit")
                           (cond ((equal? request-method "GET")
                             (set-response-body (render-template "submit.html")
                                                response))))

                          (else
                           (set-response-status 404
                           (set-response-body "Page not found"
                                              response)))
                        ))))))
