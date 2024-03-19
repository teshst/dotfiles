(setq straight-repository-branch "develop")

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t))

;; Set initial size
(add-to-list 'default-frame-alist '(height . 60))
(add-to-list 'default-frame-alist '(width . 160))

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Use `command` as `meta` in macOS.
(setq mac-command-modifier 'meta)

;; Org mode setup
(use-package org)

(use-package comment-tags)
(use-package org-super-agenda
  :config
  (org-super-agenda-mode))

(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)


;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; Capture Templates
;; Work Log
(setq org-capture-templates
      '(    
        ("j" "Work Log Entry"
         entry (file+datetree "~/org/work-log.org")
         "* %?"
         :empty-lines 0)
	
        ("n" "Note"
         entry (file+headline "~/org/notes.org" "General Notes")
         "** %?"
         :empty-lines 0)

	("g" "General To-Do"
         entry (file+headline "~/org/todos.org" "General Tasks")
         "* TODO [#B] %?\n:Created: %T\n "
         :empty-lines 0)

	("c" "Code To-Do"
         entry (file+headline "~/org/todo.org" "Code Related Tasks")
         "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
         :empty-lines 0)

        ("t" "General Ticket"
         entry (file+datetree "~/org/tickets.org")
         "* TODO [#B] %? :general:%^g \n:Created: %T\n** User Info\n- Name:\n- Email:\n- Phone #:\n- CC:\n** Shipping\n- Address:\n- Ship Date:\n- Tracking:\n** Asset Info\n*** New Asset\n- Model:\n- Asset:\n- Serial:\n*** Return Asset(s)\n- Model:\n- Asset:\n- Serial:\n** Notes\n*** Account Creation\n*** Build\n**** Initial Setup\n**** Software Setup\n** Action Items\n*** TODO [#A]  "
         :tree-type week
         :clock-in t
         :clock-resume t
         :empty-lines 0)
	
	))

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO(t)" "HOLD(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "IN-TRANSIT(t!)" "FOLLOW-UP(f!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))

;; TODO colors
(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "GoldenRod" :weight bold))
        ("HOLD" . (:foreground "DeepPink" :weight bold))
        ("IN-PROGRESS" . (:foreground "Cyan" :weight bold))
        ("VERIFYING" . (:foreground "DarkOrange" :weight bold))
	("IN-TRANSIT" . (:foreground "LightOrange" :weight bold))
	("FOLLOW-UP" . (:foreground "Purple" :weight bold))
	("BLOCKED" . (:foreground "Red" :weight bold))
        ("DONE" . (:foreground "LimeGreen" :weight bold))
        ("OBE" . (:foreground "LimeGreen" :weight bold))
        ("WONT-DO" . (:foreground "LimeGreen" :weight bold))
        ))

;; Tags
(setq org-tag-alist '(
                      ;; Ticket types
                      (:startgroup . nil)
                      ("@build" . ?b)
                      ("@account" . ?a)
                      ("@return" . ?r)
		      ("@general" . ?g)
                      ("@domain" . ?d)
                      (:endgroup . nil)

                      ;; Ticket flags
                      ("@write_future_ticket" . ?w)
                      ("@emergency" . ?e)
                      ("@research" . ?r)

                      ;; Meeting types
                      ;;(:startgroup . nil)
                      ;;("big_sprint_review" . ?i)
                      ;;("cents_sprint_retro" . ?n)
                      ;;("dsu" . ?d)
                      ;;("grooming" . ?g)
                      ;;("sprint_retro" . ?s)
                      ;;(:endgroup . nil)

                      ;; Code TODOs tags
                      ("QA" . ?q)
                      ("backend" . ?k)
                      ("broken_code" . ?c)
                      ("frontend" . ?f)

                      ;; Special tags
                      ("CRITICAL" . ?x)
                      ("obstacle" . ?o)

                      ;; Meeting tags
                      ;;("HR" . ?h)
                      ;;("general" . ?l)
                      ;;("meeting" . ?m)
                      ;;("misc" . ?z)
                      ;;("planning" . ?p)

                      ;; Work Log Tags
                      ("accomplishment" . ?a)
                      ))

;; Tag colors
(setq org-tag-faces
      '(
        ("build"     . (:foreground "mediumPurple1" :weight bold))
        ("return"   . (:foreground "royalblue1"    :weight bold))
        ("domain"  . (:foreground "forest green"  :weight bold))
        ("QA"        . (:foreground "sienna"        :weight bold))
        ("general"   . (:foreground "yellow1"       :weight bold))
        ("CRITICAL"  . (:foreground "red1"          :weight bold))
        )
      )

(setq org-agenda-custom-commands
      '(
        ;; Main View
        ("j" "Main View"
         (
          (agenda ""
                  (
                   (org-agenda-remove-tags t)                                       
                   (org-agenda-span 7)
                   )
                  )

          (alltodo ""
                   (
                    ;; Remove tags to make the view cleaner
                    (org-agenda-remove-tags t)
                    (org-agenda-prefix-format "  %t  %s")                    
                    (org-agenda-overriding-header "CURRENT STATUS")

                    ;; Define the super agenda groups (sorts by order)
                    (org-super-agenda-groups
                     '(
                       ;; Filter where tag is CRITICAL
                       (:name "Critical Tasks"
                              :tag "CRITICAL"
                              :order 0
                              )
                       ;; Filter where TODO state is IN-PROGRESS
                       (:name "Currently Working"
                              :todo "IN-PROGRESS"
                              :order 1
                              )
                       ;; Filter where TODO state is PLANNING
                       (:name "Currently On-Hold"
                              :todo "HOLD"
                              :order 2
                              )
                       ;; Filter where TODO state is BLOCKED or where the tag is obstacle
                       (:name "Problems & Blockers"
                              :todo "BLOCKED"
                              :tag "obstacle"                              
                              :order 3
                              )
                       ;; Filter where tag is @write_future_ticket
                       (:name "Tickets to Create"
                              :tag "@write_future_ticket"
                              :order 4
                              )
                       ;; Filter where tag is @research
                       (:name "Research Required"
                              :tag "@research"
                              :order 7
                              )
                       ;; Filter where tag is meeting and priority is A (only want TODOs from meetings)
                       (:name "Meeting Action Items"
                              :and (:tag "meeting" :priority "A")
                              :order 8
                              )
                       ;; Filter where state is TODO and the priority is A and the tag is not meeting
                       (:name "Other Important Items"
                              :and (:todo "TODO" :priority "A" :not (:tag "meeting"))
                              :order 9
                              )
                       ;; Filter where state is TODO and priority is B
                       (:name "General Backlog"
                              :and (:todo "TODO" :priority "B")
                              :order 10
                              )
                       ;; Filter where the priority is C or less (supports future lower priorities)
                       (:name "Non Critical"
                              :priority<= "C"
                              :order 11
                              )
                       ;; Filter where TODO state is VERIFYING
                       (:name "Currently Being Verified"
                              :todo "VERIFYING"
                              :order 20
                              )
                       )
                     )
                    )
                   )
          ))
        ))


;; Plugins

;; which key
(use-package which-key
     :ensure t
     :config
     (which-key-mode))

;; All the icons
(use-package all-the-icons
  :if (display-graphic-p))

;; Nerd fonts
(use-package nerd-icons
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  )

;; Doom theme
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; Dep dashboard
(use-package page-break-lines)
(use-package projectile)

;; Dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
  ;; Set the title
  (setq dashboard-banner-logo-title "Welcome to Emacs Dashboard")
  ;; Content is not centered by default. To center, set
  (setq dashboard-center-content t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )