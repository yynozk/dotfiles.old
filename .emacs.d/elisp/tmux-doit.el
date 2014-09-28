(require 'emamux)
(require 'cl)

;;; translated from key-string.c
(defvar tmux-event-keyname-alist
  '(( f1 . "F1" )
    ( f2 . "F2" )
    ( f3 . "F3" )
    ( f4 . "F4" )
    ( f5 . "F5" )
    ( f6 . "F6" )
    ( f7 . "F7" )
    ( f8 . "F8" )
    ( f9 . "F9" )
    ( f10 . "F10" )
    ( f11 . "F11" )
    ( f12 . "F12" )
    ( f13 . "F13" )
    ( f14 . "F14" )
    ( f15 . "F15" )
    ( f16 . "F16" )
    ( f17 . "F17" )
    ( f18 . "F18" )
    ( f19 . "F19" )
    ( f20 . "F20" )
    ;; ( ic . "IC" )
    ;; ( dc . "DC" )
    ( home . "Home" )
    ( end . "End" )
    ( next . "NPage" )
    ( prior . "PPage" )
    ( tab . "Tab" )
    ( backtab . "BTab" )
    ( backspace . "BSpace" )
    ( return . "Enter")
    ( escape . "Escape")
    ( up . "Up" )
    ( down . "Down" )
    ( left . "Left" )
    ( right . "Right" )
    ( kp-divice  . "KP/" )
    ( kp-multiply . "KP*" )
    ( kp-subtract . "KP-" )
    ( kp-7 . "KP7" )
    ( kp-8 . "KP8" )
    ( kp-9 . "KP9" )
    ( kp-add . "KP+" )
    ( kp-4 . "KP4" )
    ( kp-5 . "KP5" )
    ( kp-6 . "KP6" )
    ( kp-1 . "KP1" )
    ( kp-2 . "KP2" )
    ( kp-3 . "KP3" )
    ( kp-enter . "KPEnter" )
    ( kp-0 . "KP0" )
    ( kp-decimal . "KP." )
    ( ?\ . "Space")
    ( ?\C-\  . "C-Space")
    ( ?\t . "Tab")))

;; (tmux-char-to-keyname (read-event))
(defun tmux-char-to-keyname (ch)
  (let (s)
    (cond ((and (numberp ch) (<= ?\M-\C-@ ch))
           (concat "M-" (tmux-char-to-keyname (- ch ?\M-\C-@))))
          ((assoc-default ch tmux-event-keyname-alist))
          ((and (symbolp ch)
                (string-match "^\\(\\(C-\\)?\\(M-\\)?\\)\\(.+\\)$" (setq s (symbol-name ch))))
           (concat (match-string 1 s)
                   (tmux-char-to-keyname (intern (match-string 4 s)))))
          (t
           (format-kbd-macro (char-to-string ch))))))
(defun tmux-key-to-command (keyname)
  (with-temp-buffer
    (emamux:tmux-run-command "list-keys" t)
    (goto-char 1)
    (if (not (let (case-fold-search)
               (re-search-forward (format "^bind-key +%s " (regexp-quote keyname)) nil t)))
        (error "Command not found in tmux: `%s'" keyname)
      (buffer-substring (point) (point-at-eol)))))
(defun tmux-doit ()
  (interactive)
  (let ((ch (read-event)))
    (case ch
      ;; C-] C-]でペーストバッファ貼り付け
      (?\C-\] (tmux-paste))
      ;; C-] C-jで端末に切り替える
      (?\C-j  (select-rxvt))
      ;; それ以外は端末に切り替えた後、同じキー操作を行う
      (t (emamux:tmux-run-command
          (tmux-key-to-command (tmux-char-to-keyname ch)))
         (select-rxvt)))))

(provide 'tmux-doit)
