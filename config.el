;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/GTD")

;; Add all org files recursively to agenda-files
(load-library "find-lisp")
(add-hook 'org-agenda-mode-hook (lambda ()
                                  (setq org-agenda-files
                                        (find-lisp-find-files "~/GTD" "\.org$"))
))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;;
;;
;;
(setq ispell-dictionary "pt_PT")

(after! evil
    ;; Use visual line motions even outside of visual-line-mode buffers
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(after! org

;; TODO Keywords
(setq org-todo-keywords '((sequence "INBOX(i)" "TODO(t)" "NEXT(n)" "DOING(d)" "MAYBE(m)" "WAITING(w)" "|" "DONE(D)")
                          (sequence "PENDING(p)" "PLANNING(P)" "STARTED(s)" "ACTIVE(a)" "HOLD(h)" "|" "CLOSED(c)")
                          (sequence "RASCUNHO(r)" "PUBLICAR(b)" "|" "PUBLICADO(B)")
                          (sequence "|" "✘ CANCELED(C)")))

;; Org Capture Templates

;;Novo Leilão Capture
(add-to-list 'org-capture-templates
'("l" "Leilão" entry (file+olp "~/GTD/inbox.org" "Leilões")
"** TODO Leilão %^{Leilao} [%] :leiloes:%\\1:
%(setq my-date (org-read-date nil nil nil \"Data: \"))
DEADLINE: <%(format-time-string \"%Y-%m-%d\" (org-time-string-to-time my-date))>
#+PROPERTY: coockie_data checkbox recursive
DESCRIPTION: %^{Descricao}
*** TODO %\\1 Catalogação & Fotografia
*** TODO %\\1 WebSite
*** TODO %\\1 Comunicação
*** TODO %\\1 Leilão Online
SCHEDULED: <%(format-time-string \"%Y-%m-%d\" (org-time-string-to-time my-date))>
*** TODO %1 Resultados
%i" :empty-lines 1))


  (add-to-list 'org-capture-templates
          '("a" "Agenda" entry (file+olp "~/GTD/inbox.org" "Events")
           "** %^{Descrição}\n%^t%i" :empty-lines 1)
         )
  (add-to-list 'org-capture-templates
               '("i" "Inbox" entry (file "~/GTD/inbox.org")
                 "* INBOX %^{Descrição}\n" :empty-lines 1))

  ;; Org Agenda Custom Views
  (setq org-agenda-custom-commands
      '((" " "Office block agenda"
         ((agenda "" ((org-agenda-overriding-header "# HOJE #")
                      (org-agenda-span 'day)
                      (org-agenda-start-day "-0d")))
          (agenda "" ((org-agenda-start-on-weekday nil)
                      (org-agenda-block-separator nil)
                      (org-agenda-start-day "+1d")
                      (org-agenda-span 7)
                      (org-deadline-warning-days 0)
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'done))
                      (org-agenda-overriding-header "\n/  PRÓXIMOS DIAS  /\n")))
          (todo "DOING" ((org-agenda-overriding-header "\n/  IN PROGRESS  /\n")
                         (org-agenda-prefix-format "  %?-12t% s")))
          (todo "NEXT" ((org-agenda-overriding-header "/  NEXT ACTIONS  /\n")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp 'scheduled 'deadline))
                        (org-agenda-prefix-format "  %?-12t% s")))
          (todo "TODO" ((org-agenda-overriding-header "")
                        (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp 'scheduled 'deadline))
                        (org-agenda-block-separator nil)
                        (org-agenda-prefix-format "  %?-12t% s")))
          (tags-todo "+project" ((org-agenda-overriding-header "/  PROJECTOS ACTIVOS  /\n")
                                 (org-agenda-prefix-format "  %?-12t% s")))
          (todo "INBOX" ((org-agenda-overriding-header "/  CAPTURE  /\n")
                         (org-agenda-prefix-format "  %?-12t% s")))
          (todo "MAYBE" ((org-agenda-overriding-header "/  SOMEDAY_MAYBE  /")))
         )))
      )

  ;; Define org bullets
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-bullets-bullet-list '("◉" "○" "●" "○" "●" " ○" "●"))


  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;; Define Font Settings para Org Mode
  (defun ng/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.3)
                    (org-level-2 . 1.2)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "JetBrains Mono" :weight 'regular :height (cdr face)))

    ;; Adidiona uma linha de separação para os H1
    (custom-set-faces!
      '(org-level-1 :inherit outline-1 :overline t))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

   (add-to-list 'company-backends #'company-capf)

  ;; Corre a Função de Font Settings
  (ng/org-font-setup)

  (defun ng/org-mode-visual-fill ()
    (setq visual-fill-column-width 120
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1)
    (setq display-line-numbers 'nil))

  (use-package visual-fill-column
    :hook (org-mode . ng/org-mode-visual-fill)))

(defun my-setup-layout ()
  "Set up the initial layout with inbox.org on the left (65%) and custom org-agenda on the right (35%)."
  (interactive)
  (delete-other-windows) ;; Start with a single window
  (let ((left-window (selected-window))) ;; Store the left window in a variable
    (find-file (expand-file-name "inbox.org" org-directory)) ;; Open inbox.org on the left
    (split-window-right) ;; Split the window vertically
    (enlarge-window-horizontally (truncate (* 0.35 (window-width)))) ;; Adjust the right window to 35% of the total width
    (other-window 1) ;; Move to the right window
    (org-agenda nil " ") ;; Open the custom org-agenda view
    (select-window left-window))) ;; Move back to the left window
(add-hook 'emacs-startup-hook #'my-setup-layout)
(define-key global-map (kbd "C-c l") 'my-setup-layout)

(set-frame-parameter (selected-frame) 'alpha-background 85)
(add-to-list 'default-frame-alist '(alpha-background . 85))


