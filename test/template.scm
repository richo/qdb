(test-begin "template")

(test "Should load templates without interpolated forms"
      "Rawr Test Thing\n"
      (load-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms"
      "Rawr Test Thing\n"
      (render-template "test/no_interpolated_forms.html"))

(test "Should render templates without interpolated forms iwth locals"
      "Rawr Test Thing\n"
      (render-template "test/no_interpolated_forms.html" '((foo . "rawr"))))

(test-end)
