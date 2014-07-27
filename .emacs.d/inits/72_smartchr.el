;;;; 同じキーの連続入力で、入力候補を変更する


;;; (auto-install-from-url "https://raw.github.com/imakado/emacs-smartchr/master/smartchr.el")
(require 'smartchr)


(defun my-smartchr-braces ()
  "Insert a pair of braces."
  (lexical-let (beg end)
    (smartchr-make-struct
     :insert-fn (lambda ()
                  (setq beg (point))
                  (insert "{\n\n}")
                  (indent-region beg (point))
                  (forward-line -1)
                  (indent-according-to-mode)
                  (goto-char (point-at-eol))
                  (setq end (save-excursion
                              (re-search-forward "[[:space:][:cntrl:]]+}" nil t))))
     :cleanup-fn (lambda ()
                   (delete-region beg end)))))


(defun my-smartchr-semicolon ()
  "Insert ';' and newline-and-indent"
  (lexical-let (beg end)
    (smartchr-make-struct
     :insert-fn (lambda ()
                  (indent-according-to-mode)
                  (setq beg (point))
                  (insert ";")
                  (newline-and-indent)
                  (setq end (point)))
     :cleanup-fn (lambda ()
                   (delete-region beg end)))))


(defun smartchr-keybindings-ruby ()
  (local-set-key (kbd ",")  (smartchr '(", " ",")))
  (local-set-key (kbd "=")  (smartchr '(" = " " == " " === " "=")))
  (local-set-key (kbd "~")  (smartchr '(" =~ " "~")))
  (local-set-key (kbd "+")  (smartchr '(" + " " += " "+")))
  (local-set-key (kbd "-")  (smartchr '(" - " " -= " "-")))
  (local-set-key (kbd ">")  (smartchr '(" > " " => " " >= " ">")))
  (local-set-key (kbd "%")  (smartchr '(" % " " %= " "%")))
  (local-set-key (kbd "!")  (smartchr '(" != " " !~ " "!")))
  (local-set-key (kbd "&")  (smartchr '(" & " " && " "&")))
  (local-set-key (kbd "*")  (smartchr '(" * " "**" "*")))
  (local-set-key (kbd "<")  (smartchr '(" < " " << " " <= " "<")))
  (local-set-key (kbd "|")  (smartchr '("|`!!'|" " ||= " " || " "|")))
  (local-set-key (kbd "/")  (smartchr '("/" "/`!!'/" " / " "// ")))
  (local-set-key (kbd "#")  (smartchr '("#{`!!'}" "#")))
  (local-set-key (kbd "(")  (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[")  (smartchr '("[`!!']" "[")))
  (local-set-key (kbd "{")  (smartchr '("{`!!'}" "{|`!!'|  }" "{")))
  (local-set-key (kbd "'")  (smartchr '("'`!!''" "'")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\""))))

(defun smartchr-keybindings-c/c++ ()
  (local-set-key (kbd ";")  (smartchr '(my-smartchr-semicolon ";")))
  (local-set-key (kbd ",")  (smartchr '(", " ",")))
  (local-set-key (kbd "=")  (smartchr '(" = " " == " "=")))
  (local-set-key (kbd "+")  (smartchr '(" + " "++" " += " "+")))
  (local-set-key (kbd "-")  (smartchr '(" - " "--" " -= " "-")))
  (local-set-key (kbd ">")  (smartchr '(" > " " >> " " >= " "->" ">")))
  (local-set-key (kbd "%")  (smartchr '(" % " " %= " "%")))
  (local-set-key (kbd "!")  (smartchr '(" != " "!")))
  (local-set-key (kbd "&")  (smartchr '(" && " " & " "&")))
  (local-set-key (kbd "*")  (smartchr '("*" " * " " *= ")))
  (local-set-key (kbd "<")  (smartchr '(" < " " << " " <= " "<`!!'>" "<")))
  (local-set-key (kbd "|")  (smartchr '(" || " " |= " "|")))
  (local-set-key (kbd "/")  (smartchr '("/" " / " " /= ")))
  (local-set-key (kbd "(")  (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "[")  (smartchr '("[`!!']" "[")))
  (local-set-key (kbd "{")  (smartchr '(my-smartchr-braces "{`!!'}" "{")))
  (local-set-key (kbd "'")  (smartchr '("'`!!''" "'")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\""))))

(defun smartchr-keybindings-awk ()
  (local-set-key (kbd ",")  (smartchr '(", " ",")))
  (local-set-key (kbd "=")  (smartchr '(" = " " == " "=")))
  (local-set-key (kbd "!")  (smartchr '(" != " "!")))
  (local-set-key (kbd "~")  (smartchr '(" ~ " " !~ " "~")))
  (local-set-key (kbd ">")  (smartchr '(" > " " >= " ">")))
  (local-set-key (kbd "<")  (smartchr '(" < " " <= " "<")))
  (local-set-key (kbd "+")  (smartchr '(" + " "++" " += " "+")))
  (local-set-key (kbd "-")  (smartchr '(" - " "--" " -= " "-")))
  (local-set-key (kbd "|")  (smartchr '(" || " "|")))
  (local-set-key (kbd "&")  (smartchr '(" && " "&")))
  (local-set-key (kbd "/")  (smartchr '("/`!!'/" " / " "/")))
  (local-set-key (kbd "{")  (smartchr '("{`!!'}" my-smartchr-braces "{")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\""))))

(defun smartchr-keybindings-web ()
  (local-set-key (kbd "<") (smartchr '("<%= `!!' %>" "<% `!!' %>" "<`!!'>" "<"))))


(add-hook 'ruby-mode-hook 'smartchr-keybindings-ruby)
(add-hook 'c-mode-hook 'smartchr-keybindings-c/c++)
(add-hook 'c++-mode-hook 'smartchr-keybindings-c/c++)
(add-hook 'awk-mode-hook 'smartchr-keybindings-awk)
(add-hook 'web-mode-hook 'smartchr-keybindings-web)
