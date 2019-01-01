(require 'package)
(require 'dash)

;; Add melpa to package repos.
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

;; Set pinned packages.
(setq package-pinned-packages '())

;; Initialize packages.
(package-initialize)

;; Create MELPA directory.
(unless (file-exists-p "~/.emacs.d/elpa/archives/melpa")
  (package-refresh-contents))

(defun packages-install (packages)
  (--each packages
	  (when (not (package-installed-p it))
	    (package-install it)))
  (delete-other-windows))

;; On demand installation of packages.
(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
	(package-install package)
      (progn
	(package-refresh-contents)
	(require-package package min-version t)))))

;; Install extensions if they are missing.
(defun init--install-packages ()
  (packages-install
   '(
     all-the-icons
     all-the-icons-dired
     bash-completion
     cider
     clojure-mode
     company
     company-irony
     company-quickhelp
     csharp-mode
     dash
     dashboard
     dashboard-hackernews
     doom-themes
     doom-modeline
     elpy
     erc
     erc-status-sidebar
     flycheck
     flycheck-irony
     flycheck-pos-tip
     geiser
     hackernews
     helm
     lsp-java
     magit
     md4rd
     mu4e-alert
     neotree
     nov
     omnisharp
     paredit
     pdf-tools
     rainbow-delimiters
     slime
     smartparens
     transmission)))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Provide package, packageconf.
(provide 'packageconf)
