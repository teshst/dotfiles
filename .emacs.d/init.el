;; Install Elpaca Package Manager
(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; early load plugins
;; Install use-package support
(elpaca elpaca-use-package
	;; Enable use-package :ensure support for
  (elpaca-use-package-mode))

;; Block until current queue processed.
(elpaca-wait)

;; Improve keyboard shortcut discoverability
(use-package which-key
  :ensure t
  :demand t
  :config
  (which-key-mode))

;; Enable vertico
(use-package vertico
  :ensure t
  :demand t
  :bind (:map vertico-map
         ("C-j" . vertico-next)
         ("C-k" . vertico-previous)
         ("C-f" . vertico-exit)
         :map minibuffer-local-map
         ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(savehist-mode)

;; Dynamic Completions
(use-package orderless
  :after vertico
  :ensure t
  :demand t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :after vertico
  :ensure t
  :demand t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;; Doom One Theme
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Smart Mode Line
(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup))

;; All the icons
(use-package all-the-icons
  :if (display-graphic-p)
  :ensure t
  :demand t
  :config)

(use-package all-the-icons-completion
  :ensure t
  :config
  (all-the-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup))

;; Set initial size
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 160))

;; Set minimium warning level
(setq warning-minimum-level :error)

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)

;; Setup Org
(use-package org
  :ensure t)

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; Setup Org Roam
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '("t" "Full Build Incident" plain (file "~/org/roam/templates/fbincident.org")
    :target (file+head "${slug}.org" "#+title: ${title}\n")
    :unnarrowed t))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i"    . completion-at-point))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

