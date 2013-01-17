(test-begin "template")

(test "Should load templates without interpolated forms"
      '(Rawr Test Thing)
      (load-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms"
      "Rawr Test Thing"
      (render-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms with locals"
      "Rawr Test Thing"
      (render-template "test/no_interpolated_forms.html" '((foo . "rawr"))))

(test "Should render templates with interpolated forms"
      "Rawr Test buttslol Foo"
      (render-template "test/interpolated_forms.html"))

(test "Should render templates with escaped forms"
      "Rawr Test (hello world)"
      (render-template "test/escaped_forms.html"))

(test "Should render templates with inline html"
      "<html><head><title>butts</title></head><body>lols</body></html>"
      (render-template "test/inline_html.html"))

(test "Should render templates with local variables"
      "rawr test butts"
      (render-template "test/local_variables.html" '((key . "butts"))))

(test "Should include variables from local scope"
      "rawr test butts"
      (let ((somevar "butts"))
        (render-template "test/local_variables.html" `((key . ,somevar)))))

(test "Should handle inline variables in other forms"
      "test trololol test"
      (render-template "test/inline_list_variable.html" '((key . "trololol"))))

(test "Should be able to do inline scheme with nested forms"
      "0 1 2 3 4 5 6 7 8 9 10"
      (render-template "test/count.html" '((to . 10))))

(test "Interpolated complex data structures"
      "beep This is a test boop"
      (let ((st '((baz . "This is a test") (foo . bar) )))
        (render-template "test/complex_data_structures.html" (alist-cons 'key st '()))))
        ; (cdr (assoc 'baz st))))

(test-end)
