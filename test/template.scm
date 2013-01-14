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

(test-end)
