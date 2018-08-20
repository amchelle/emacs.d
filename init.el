;; [[file:~/.emacs.d/init.org::*Introduction][Introduction:1]]
;;; .emacs.el

;;; Commentary:
;;; This is the .emacs file written and used by esc. The .el file is
;;; not the original form of this document; it was written in org
;;; babel. If you are not viewing the org document, you should try to
;;; locate it. It's much nicer to humans.

;;; License:
;;; esc's .emacs configuration file, for a smoother Emacs experience.
;;; Copyright (C) 2013 Eric Crosson
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation, either version 3 of the License, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:
;; Introduction:1 ends here

;; [[file:~/.emacs.d/init.org::*User%20data][User data:1]]
(setq user-full-name "Amchelle Clendenin"
      user-mail-address "amchelle@protonmail.com")
;; User data:1 ends here

;; [[file:~/.emacs.d/init.org::*Archives][Archives:1]]
(require 'package)
(setq package-enable-at-startup nil)
    (mapc (lambda (source) (add-to-list 'package-archives source) t)
          '(("gnu" . "http://elpa.gnu.org/packages/")
            ("marmalade" . "http://marmalade-repo.org/packages/")
            ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
            ("melpa" . "http://melpa.milkbox.net/packages/")
            ("org" . "http://orgmode.org/elpa/")))
;; (package-initialize)
;; Archives:1 ends here

;; [[file:~/.emacs.d/init.org::*Use-package][Use-package:1]]
;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
;; Use-package:1 ends here

;; [[file:~/.emacs.d/init.org::*Layout%20and%20load%20paths][Layout and load paths:1]]
(defcustom esc-meta-directory "~/.emacs.d/meta/"
  "Path to .emacs.d meta directory, for internal bookkeeping
records."
  :type 'path
  :options '("~/.emacs.d/meta")
  :group 'esc-init)
;; Layout and load paths:1 ends here

;; [[file:~/.emacs.d/init.org::*UI][UI:1]]
(use-package fill-column-indicator :ensure t
  :config
  (add-hook 'prog-mode-hook 'fci-mode))
;; UI:1 ends here

;; [[file:~/.emacs.d/init.org::*Fonts][Fonts:1]]
(defun font-exists-p (font)
  "True FONT is recognized by Emacs, nil otherwise."
  (member esc-font (font-family-list)))
;; Fonts:1 ends here

;; [[file:~/.emacs.d/init.org::*Fonts][Fonts:2]]
(let ((esc-font "Source Code Pro"))
  ;; install `esc-font`
  (when (not (font-exists-p esc-font))
    (call-process
     (expand-file-name "font-install-source-code-pro.sh"
                       "~/.emacs.d/bin")))
  ;; use `esc-font`
  (when (font-exists-p esc-font)
    (set-face-attribute 'default nil
                        :font esc-font
                        :height 95
                        :weight 'normal
                        :width 'normal)))
;; Fonts:2 ends here

;; [[file:~/.emacs.d/init.org::*Themes][Themes:2]]
(use-package darkokai-theme :ensure t
  :config
  (setq darkokai-mode-line-padding 1))
;; Themes:2 ends here

;; [[file:~/.emacs.d/init.org::*Themes][Themes:4]]
(use-package nord-theme :ensure t
  :config
  (load-theme 'nord t))
;; Themes:4 ends here

;; [[file:~/.emacs.d/init.org::*Macros][Macros:1]]
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))
;; Macros:1 ends here

;; [[file:~/.emacs.d/init.org::*Functions][Functions:1]]
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently opened buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
;; Functions:1 ends here

;; [[file:~/.emacs.d/init.org::*Functions][Functions:2]]
(defun insert-program-header ()
  "Insert the user's name and the current date at point."
  (interactive)
  (insert "Written by " user-full-name)
  (open-line 1)
  (comment-line 1)
  (esc-insert-short-date)
  (comment-line 1))
;; Functions:2 ends here

;; [[file:~/.emacs.d/init.org::*Aliases][Aliases:1]]
(defalias 'undefun 'fmakunbound)
;; Aliases:1 ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:1]]
(setq gc-cons-threshold 100000000)
(put 'overwrite-mode 'disabled t)       ;There shall be no 'insert'
(fset 'yes-or-no-p 'y-or-n-p)           ;change yes-no to y-n
(setq ;debug-on-error t
      inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore        ;turn off alarms completely
      disabled-command-function 'beep   ;alert me when accessing disabled funcs
      redisplay-dont-pause t            ;don't pause refreshes
      frame-title-format '("emacs@" system-name ":%f") ;include path of frame
      display-time-load-average-threshold 0.6
      dabbrev-case-replace nil
      display-buffer-reuse-frames t     ;raise buffers, not spawn
      remote-file-name-inhibit-cache t  ;don't resolve remote file attrubutes
      auto-save-default nil
      large-file-warning-threshold nil
      save-interprogram-paste-before-kill t
      set-mark-command-repeat-pop t
      starttls-use-gnutls t
      vc-follow-symlinks t
      browse-url-browser-function 'browse-web
      kill-buffer-query-functions (remq 'process-kill-buffer-query-function
                                         kill-buffer-query-functions))
;; Behavioral modifications:1 ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:2]]
(setq minibuffer-prompt-properties '(read-only t point-entered
                                               minibuffer-avoid-prompt face
                                               minibuffer-prompt))
;; Behavioral modifications:2 ends here

;; [[file:~/.emacs.d/init.org::char-and-font-encoding][char-and-font-encoding]]
;; Char and font encoding
(set-buffer-file-coding-system 'unix)
(setq-default indent-tabs-mode nil)
(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      require-final-newline 'visit-save ;compliance
      comment-style 'indent)
;; char-and-font-encoding ends here

;; [[file:~/.emacs.d/init.org::stash-backups][stash-backups]]
(push '("." . "~/.config/.emacs.d/") backup-directory-alist)
;; stash-backups ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:6]]
(global-auto-revert-mode)
;; Behavioral modifications:6 ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:7]]
(setq search-whitespace-regexp "[ \t\r\n]+")
;; Behavioral modifications:7 ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:8]]
(bind-key (kbd "C-x C-c")
          (defun esc-dont-kill-emacs ()
            (interactive)
            (message "I'm afraid I can't do that, %s."
                     (user-login-name))))
;; Behavioral modifications:8 ends here

;; [[file:~/.emacs.d/init.org::*Behavioral%20modifications][Behavioral modifications:9]]
(setq x-select-enable-clipboard t
      mouse-yank-at-point t)
;; Behavioral modifications:9 ends here

;; [[file:~/.emacs.d/init.org::*Org%20mode%20config][Org mode config:1]]
(setq org-src-fontify-natively t)
;; Org mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Org%20indent%20config][Org indent config:1]]
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)
;; Org indent config:1 ends here

;; [[file:~/.emacs.d/init.org::*Org%20cliplink%20config][Org cliplink config:1]]
(use-package org-cliplink :ensure t
  :init (after 'esc-mode
          (esc-key "C-c C-M-l" 'org-cliplink)))
;; Org cliplink config:1 ends here

;; [[file:~/.emacs.d/init.org::*Org%20bullets][Org bullets:1]]
(use-package org-bullets :ensure t
  :init (add-hook 'org-mode-hook 'org-bullets-mode))
;; Org bullets:1 ends here

;; [[file:~/.emacs.d/init.org::*Org%20babel%20config][Org babel config:1]]
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)))
;; Org babel config:1 ends here

;; [[file:~/.emacs.d/init.org::*Org%20gtd][Org gtd:1]]
(after 'org
  (setq org-todo-keywords
        '((sequence "TODO(t!/@)" "HOLD(h@)" "NEXT(n!)" "INPROG(i!)"
                    "WAITING(w@)" "REVIEW(r@)" "|"
                    "DONE(d@)" "CANCELLED(c@)")
          (sequence "|" "PLAN(p!)" "MEETING(m!)")
          (sequence "PROJECT(r!)" "|" "DONE(d@)" "CANCELLED(c@)")))
  (setq org-todo-keyword-faces
        '(("TODO" :foreground "red" :weight bold)
          ("REVIEW" :foreground "orange" :weight bold)
          ("NEXT" :foreground "orange" :weight bold)
          ("INPROG" :foreground "orange" :weight bold)
          ("HOLD" :foreground "orange" :weight bold)
          ("WAITING" :foreground "orange" :weight bold)
          ("DONE" org-done)
          ("CANCELLED" org-done)
          ("PROJECT" :foreground "purple" :weight bold)
          ("PLAN" :foreground "purple" :weight bold)
          ("MEETING" :foreground "blue" :weight bold))))
;; Org gtd:1 ends here

;; [[file:~/.emacs.d/init.org::*Dired%20config][Dired config:1]]
(use-package dired-details :ensure t
  :config (dired-details-install)
  :init
  (use-package dash
    :ensure t
    :config
    ;; Reload dired after making changes
    (put '--each 'lisp-indent-function 1)
    (--each '(dired-do-rename
              dired-create-directory
              wdired-abort-changes)
      (eval `(defadvice ,it (after revert-buffer activate)
               (revert-buffer)))))
  :config
  ;; TODO: define these functions
  ;; (use-package wdired
  ;;   :config
  ;;   (define-key wdired-mode-map
  ;;     (vector 'remap 'beginning-of-line) 'esc/dired-back-to-start-of-files)
  ;;   (define-key wdired-mode-map
  ;;     (vector 'remap 'esc/back-to-indentation-or-beginning)
  ;;     'esc/dired-back-to-start-of-files)
  ;;   (define-key wdired-mode-map
  ;;     (vector 'remap 'beginning-of-buffer) 'esc/dired-back-to-top)
  ;;   (define-key wdired-mode-map
  ;;     (vector 'remap 'end-of-buffer) 'esc/dired-jump-to-bottom))

  (setq diredp-hide-details-initially-flag t)
  (use-package dired-x
    :config
    (setq-default dired-omit-files-p t)
    (setq dired-omit-files
          (concat dired-omit-files "\\|\\.pyc$\\|\\.elc$\\|\\.~undo-tree~\\.gz$\\|\\.projectile$")))

  (after "dired-aux"
    (setq dired-free-space-args "-Ph")
    (setq dired-guess-shell-alist-user '(("\\.mp4$" "cvlc" "mplayer")
                                         ("\\.avi$" "cvlc" "mplayer")
                                         ("\\.mkv$" "cvlc" "mplayer")
                                         ("\\.pdf$" "evince" "zathura")
                                         ("\\.tar.bz2" "dtrx -n --one=here" "tar jxvf")
                                         ("\\.tar.gz" "dtrx -n --one=here" "tar xzvf")
                                         ("\\.rar" "dtrx -n --one=here" "unrar e")
                                         ("\\.zip" "dtrx -n --one=here")
                                         ("\\.*$" "xdg-open")))
    (add-to-list 'dired-compress-file-suffixes '("\\.zip$" "unzip")))
  (setq dired-listing-switches "-Alhv")
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (after "ibuf-ext"
    (add-to-list 'ibuffer-saved-filter-groups
                 '("default" ("dired" (mode . dired-mode)))))

  ;; TODO: move this somewhere it belongs
  ;; Allow running multiple async commands simultaneously
  (defadvice shell-command (after shell-in-new-buffer
                             (command &optional output-buffer error-buffer))
    (when (get-buffer "*Async Shell Command*")
      (with-current-buffer "*Async Shell Command*" (rename-uniquely))))
  (ad-activate 'shell-command)

  (after 'evil-leader
    (evil-leader/set-key
      "d" (defun dired-here ()
            (interactive)
            (let ((cwd (file-name-directory (or (buffer-file-name) ""))))
              (cond
               ((and cwd (file-exists-p cwd))
                (dired cwd))
               (t
                (message "I'm not sure which dir to view.")))))))

  (setq dired-dwim-target t)
  (after "dired"
    (add-hook 'dired-mode-hook 'auto-revert-mode)
    (defun dired-find-parent-directory ()
      (interactive)
      (find-alternate-file ".."))
    (define-key dired-mode-map (kbd "<right>") 'dired-find-file)
    (define-key dired-mode-map (vector 'remap 'evil-forward-char) 'dired-find-file)
    (define-key dired-mode-map (kbd "<left>") 'dired-find-parent-directory)
    (define-key dired-mode-map (vector 'remap 'evil-backward-char) 'dired-find-parent-directory)

    (define-key dired-mode-map (vector 'remap 'beginning-of-buffer)
      (defun dired-back-to-top ()
        (interactive)
        (beginning-of-buffer)
        (unless (search-forward ".." nil 'noerror)
          (beginning-of-buffer))
        (dired-next-line 1)))

    (define-key dired-mode-map (vector 'remap 'end-of-buffer)
      (defun dired-jump-to-bottom ()
        (interactive)
        (end-of-buffer)
        (dired-next-line -1)))))
;; Dired config:1 ends here

;; [[file:~/.emacs.d/init.org::*Minibuffer%20config][Minibuffer config:1]]
(add-hook 'eval-expression-minibuffer-setup-hook 'eldoc-mode)
;; Minibuffer config:1 ends here

;; [[file:~/.emacs.d/init.org::*TIme%20clocking%20config...][TIme clocking config...:1]]
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
;; TIme clocking config...:1 ends here

;; [[file:~/.emacs.d/init.org::*Mouse%20avoidance%20config][Mouse avoidance config:1]]
(mouse-avoidance-mode 'exile)
;; Mouse avoidance config:1 ends here

;; [[file:~/.emacs.d/init.org::*Programming%20modes%20config][Programming modes config:1]]
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'electric-pair-local-mode)
;; Programming modes config:1 ends here

;; [[file:~/.emacs.d/init.org::*Aggressive%20indent%20config][Aggressive indent config:1]]
(use-package aggressive-indent :ensure t
  :config
  (defun turn-off-aggressive-indent-mode ()
    (interactive)
    (aggressive-indent-mode -1))
  (remove-hook 'markdown-mode-hook 'turn-off-aggressive-indent-mode))
;; Aggressive indent config:1 ends here

;; [[file:~/.emacs.d/init.org::*Rainbow-mode][Rainbow-mode:1]]
(use-package rainbow-mode :ensure t
  :config
  (defun turn-on-rainbow-mode()
    "Turn on `rainbow-mode`."
    (interactive)
    (rainbow-mode 1))
  (defun turn-off-rainbow-mode()
    "Turn off `rainbow-mode`."
    (interactive)
    (rainbow-mode -1))
  (add-hook 'prog-mode-hook 'turn-on-rainbow-mode)
  ;; otherwise the first half of `#define` gets highlighted
  (add-hook 'c-mode-common-hook 'turn-off-rainbow-mode))
;; Rainbow-mode:1 ends here

;; [[file:~/.emacs.d/init.org::*FIC-mode%20config][FIC-mode config:1]]
(use-package fic-mode :ensure t
  :diminish (fic-mode . "")
  :config
  (push "DISCUSS" fic-highlighted-words)
  (push "RESUME" fic-highlighted-words)
  (defun turn-off-fic-mode ()
     "Turn fic-mode off."
     (interactive)
     (fic-mode -1))
  (defun turn-on-fic-mode ()
     "Turn fic-mode on."
     (interactive)
     (fic-mode 1))
  (add-hook 'conf-mode-hook 'turn-on-fic-mode)
  (add-hook 'yaml-mode-hook 'turn-on-fic-mode)
  ;; TODO: prove that this works?
  (add-hook 'markdown-mode-hook 'turn-on-fic-mode)
  (add-hook 'prog-mode-hook 'turn-on-fic-mode))
;; FIC-mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Rtags%20config][Rtags config:1]]
(use-package rtags :ensure t
  :bind ("C-;" . rtags-find-symbol-at-point))
;; Rtags config:1 ends here

;; [[file:~/.emacs.d/init.org::*Qt%20config][Qt config:1]]
(add-to-list 'auto-mode-alist '("\\.pro\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.pri\\'" . conf-mode))
;; Qt config:1 ends here

;; [[file:~/.emacs.d/init.org::*S-refactor%20config][S-refactor config:1]]
(use-package srefactor :ensure t
  :config
  (semantic-mode 1)
  (after 'evil-leader
    (evil-leader/set-key-for-mode 'c++-mode
      "rh" 'srefactor-refactor-at-point)))
;; S-refactor config:1 ends here

;; [[file:~/.emacs.d/init.org::*Company%20mode][Company mode:1]]
(use-package company :ensure t
  :defer t
  :init (global-company-mode))
;; Company mode:1 ends here

;; [[file:~/.emacs.d/init.org::*Python%20config][Python config:1]]
(setq python-indent 4
      python-enable-yapf-format-on-save nil)
;; Python config:1 ends here

;; [[file:~/.emacs.d/init.org::*anaconda%20mode][anaconda mode:1]]
(use-package anaconda-mode :ensure t
  :defer t
  :init
  (progn
    (setq anaconda-mode-installation-directory
          (expand-file-name "anaconda-mode" esc-meta-directory))
    (add-hook 'python-mode-hook 'anaconda-mode))
  :config
  (progn
    ;; (spacemacs/set-leader-keys-for-major-mode 'python-mode
    ;;                                           "hh" 'anaconda-mode-show-doc
    ;;                                           "gg" 'anaconda-mode-find-definitions
    ;;                                           "ga" 'anaconda-mode-find-assignments
    ;;                                           "gu" 'anaconda-mode-find-references)
    ;; (evilified-state-evilify anaconda-mode-view-mode anaconda-mode-view-mode-map
    ;;                          (kbd "q") 'quit-window)
    ;; (spacemacs|hide-lighter anaconda-mode)

    (defadvice anaconda-mode-goto (before python/anaconda-mode-goto activate)
      (evil--jumps-push))))
;; anaconda mode:1 ends here

;; [[file:~/.emacs.d/init.org::*company-anaconda][company-anaconda:1]]
(use-package company-anaconda :ensure t
  :defer t
  :init
  (add-to-list 'company-backends 'company-anaconda))
;; company-anaconda:1 ends here

;; [[file:~/.emacs.d/init.org::*yapf][yapf:1]]
(use-package py-yapf :ensure t
  ;; FIXME: have something this cool
  ;; :init
  ;; (spacemacs/set-leader-keys-for-major-mode 'python-mode "=" 'py-yapf-buffer)
  :config
  (when python-enable-yapf-format-on-save
    (add-hook 'python-mode-hook 'py-yapf-enable-on-save)))
;; yapf:1 ends here

;; [[file:~/.emacs.d/init.org::*Coffeescript%20config][Coffeescript config:1]]
(use-package coffee-mode :ensure t)
;; Coffeescript config:1 ends here

;; [[file:~/.emacs.d/init.org::*C%20mode%20config][C mode config:1]]
(defun esc-customize-cc-search-directories ()
  (add-to-list 'cc-search-directories '"../inc")
  (add-to-list 'cc-search-directories '"../src"))
(add-hook 'cc-mode-hook 'esc-customize-cc-search-directories)

(setq-default ff-always-in-other-window t)
;; C mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Irony%20config][Irony config:1]]
(use-package irony :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)

  (defun my-irony-mode-hook ()
    (define-key irony-mode-map
      [remap completion-at-point] 'counsel-irony)
    (define-key irony-mode-map
      [remap complete-symbol] 'counsel-irony))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
;; Irony config:1 ends here

;; [[file:~/.emacs.d/init.org::*Shell%20config][Shell config:1]]
(setq explicit-shell-file-name
      (if (file-exists-p "/usr/bin/zsh")
          "/usr/bin/zsh"
        "/bin/bash"))
;; Shell config:1 ends here

;; [[file:~/.emacs.d/init.org::*Shell%20config][Shell config:2]]
(defadvice term-handle-exit
    (after term-kill-buffer-on-exit activate)
  (kill-buffer))
;; Shell config:2 ends here

;; [[file:~/.emacs.d/init.org::*Shell%20config][Shell config:3]]
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
;; Shell config:3 ends here

;; [[file:~/.emacs.d/init.org::*Markdown%20config][Markdown config:1]]
(use-package markdown-mode :ensure t)
;; Markdown config:1 ends here

;; [[file:~/.emacs.d/init.org::*Lua%20mode%20config][Lua mode config:1]]
(use-package lua-mode :ensure t)
;; Lua mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Magithub%20config][Magithub config:1]]
(use-package magithub :ensure t
  :after magit
  :config (magithub-feature-autoinject t))
;; Magithub config:1 ends here

;; [[file:~/.emacs.d/init.org::*Yasnippet%20config][Yasnippet config:1]]
(use-package yasnippet :ensure t
  :load-path "~/.emacs.d/plugins/yasnippet"
  :config
  (yas-reload-all)
  (yas-global-mode 1))
;; Yasnippet config:1 ends here

;; [[file:~/.emacs.d/init.org::*RestructuredText%20config][RestructuredText config:1]]
(use-package rst :ensure t
  :config (add-hook 'rst-mode-hook 'auto-fill-mode))
;; RestructuredText config:1 ends here

;; [[file:~/.emacs.d/init.org::*Yaml%20mode][Yaml mode:1]]
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml$" . yaml-mode)))
;; Yaml mode:1 ends here

;; [[file:~/.emacs.d/init.org::*Bitbake%20config][Bitbake config:1]]
(add-to-list 'auto-mode-alist '("\\.bb\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.bbappend\\'" . conf-mode))
;; Bitbake config:1 ends here

;; [[file:~/.emacs.d/init.org::*Docker%20config][Docker config:1]]
(use-package dockerfile-mode :ensure t)
(add-to-list 'auto-mode-alist '("\\.env\\'" . conf-mode))
;; Docker config:1 ends here

;; [[file:~/.emacs.d/init.org::*Qml%20mode%20config][Qml mode config:1]]
(use-package qml-mode :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.qml$" . qml-mode)))

(use-package company-qml :ensure t
  :config (add-to-list 'company-backends 'company-qml))
;; Qml mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Writegood%20mode%20config][Writegood mode config:1]]
(use-package writegood-mode :ensure t)
;; Writegood mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Ivy][Ivy:1]]
(use-package ivy :ensure t
  :diminish (ivy-mode . "")
  :init
  (use-package avy :ensure t)
  (use-package counsel :ensure t)
  :bind
  (:map ivy-minibuffer-map
        ("C-j" . ivy-next-line)
        ("C-k" . ivy-previous-line)
        ("M-i" . imenu))
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; ignore undo-tree files when switching buffers
  (add-to-list 'ivy-ignore-buffers "\\.~undo-tree~\\.gz")
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
        ;; allow input not in order
        '((t   . ivy--regex-ignore-order))))
;; Ivy:1 ends here

;; [[file:~/.emacs.d/init.org::*Which-key%20mode][Which-key mode:1]]
(use-package which-key :ensure t
  :diminish (which-key-mode . "")
  :init
  (which-key-setup-side-window-right-bottom)
  :config
  (which-key-mode 1))
;; Which-key mode:1 ends here

;; [[file:~/.emacs.d/init.org::*Git%20time%20machine%20config][Git time machine config:1]]
(use-package git-timemachine :ensure t
  :config
  ;; http://blog.binchen.org/posts/use-git-timemachine-with-evil.html
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))
;; Git time machine config:1 ends here

;; [[file:~/.emacs.d/init.org::*Git%20gutter%20config][Git gutter config:1]]
(use-package git-gutter+ :ensure t
  :config
  (global-git-gutter+-mode))
;; Git gutter config:1 ends here

;; [[file:~/.emacs.d/init.org::*Magit%20config][Magit config:1]]
(use-package magit :ensure t
  :commands magit-status)
;; Magit config:1 ends here

;; [[file:~/.emacs.d/init.org::*Git%20messenger%20config][Git messenger config:1]]
(use-package git-messenger :ensure t
      )
;; Git messenger config:1 ends here

;; [[file:~/.emacs.d/init.org::*Git%20modes][Git modes:1]]
(use-package gitignore-mode :ensure t)
(use-package gitconfig-mode :ensure t)
;; Git modes:1 ends here

;; [[file:~/.emacs.d/init.org::*WIndow%20rotation][WIndow rotation:1]]
(use-package rotate :ensure t)
;; WIndow rotation:1 ends here

;; [[file:~/.emacs.d/init.org::*Winner%20config][Winner config:1]]
(use-package winner
  :init
  (progn
    (winner-mode t)
    (setq esc/winner-boring-buffers '("*Completions*"
                                      "*Compile-Log*"
                                      "*inferior-lisp*"
                                      "*Fuzzy Completions*"
                                      "*Apropos*"
                                      "*Help*"
                                      "*cvs*"
                                      "*Buffer List*"
                                      "*Ibuffer*"
                                      "*esh command on file*"))
    (setq winner-boring-buffers
          (append winner-boring-buffers esc/winner-boring-buffers))
    (winner-mode t)))
;; Winner config:1 ends here

;; [[file:~/.emacs.d/init.org::*Projectile%20config][Projectile config:1]]
(use-package counsel-projectile :ensure t
       :config (counsel-projectile-mode)
)
;; Projectile config:1 ends here

;; [[file:~/.emacs.d/init.org::*Flycheck%20config][Flycheck config:1]]
(use-package flycheck :ensure t
  :init (global-flycheck-mode))
;; Flycheck config:1 ends here

;; [[file:~/.emacs.d/init.org::*Flyspell%20config][Flyspell config:1]]
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
;; Flyspell config:1 ends here

;; [[file:~/.emacs.d/init.org::*Windmove%20config][Windmove config:1]]
;; Windmove from shift keys
(use-package windmove
  :ensure t
  :config
  (windmove-default-keybindings)
  (after 'org
    (setq org-replace-disputed-keys t)
    (add-hook 'org-shiftup-final-hook 'windmove-up)
    (add-hook 'org-shiftleft-final-hook 'windmove-left)
    (add-hook 'org-shiftdown-final-hook 'windmove-down)
    (add-hook 'org-shiftright-final-hook 'windmove-right)))
;; Windmove config:1 ends here

;; [[file:~/.emacs.d/init.org::*Rainbow%20delimeters%20mode%20config][Rainbow delimeters mode config:1]]
(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;; Rainbow delimeters mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Beacon%20config][Beacon config:1]]
(use-package beacon
  :ensure t
  :demand t
  :diminish beacon-mode
  :config
  (beacon-mode 1))
;; Beacon config:1 ends here

;; [[file:~/.emacs.d/init.org::*Compilation%20buffer%20config][Compilation buffer config:1]]
(add-to-list 'same-window-buffer-names "*compilation*")
;; Compilation buffer config:1 ends here

;; [[file:~/.emacs.d/init.org::*Bury%20successful%20compilation%20buffer][Bury successful compilation buffer:1]]
(use-package bury-successful-compilation :ensure t
  :bind ("C-c C-m" . recompile)
  :config (bury-successful-compilation 1))
;; Bury successful compilation buffer:1 ends here

;; [[file:~/.emacs.d/init.org::*Define%20word][Define word:1]]
(use-package define-word :ensure t
  :bind ("C-h d"  . define-word-at-point))
;; Define word:1 ends here

;; [[file:~/.emacs.d/init.org::*Lexbind%20config][Lexbind config:1]]
(use-package lexbind-mode
  :ensure t
  :init (add-hook 'emacs-lisp-mode-hook 'lexbind-mode))
;; Lexbind config:1 ends here

;; [[file:~/.emacs.d/init.org::*Goto%20last%20change%20config][Goto last change config:1]]
(use-package goto-chg :ensure t)
;; Goto last change config:1 ends here

;; [[file:~/.emacs.d/init.org::*Misc%20cmds%20config][Misc cmds config:1]]
(use-package misc
  :commands zap-up-to-char
  :init ; seeing as I don't use these commands terribly often
  (after 'esc-mode
    (esc-key "M-z"     'zap-up-to-char) ; up-to, life saver
    (esc-key "M-Z"     'zap-to-char)))

(use-package misc-cmds
  :commands revert-buffer-no-confirm
  :init ; takes a while to need the get-out-of-jail-free button
  (after 'esc-mode
    (esc-key "C-x M-r" 'revert-buffer-no-confirm)))
;; Misc cmds config:1 ends here

;; [[file:~/.emacs.d/init.org::*Browse%20kill%20ring%20config][Browse kill ring config:1]]
(use-package browse-kill-ring
  :ensure t
  :config
  (setq kill-ring-max 80)
  (browse-kill-ring-default-keybindings))
;; Browse kill ring config:1 ends here

;; [[file:~/.emacs.d/init.org::*Keyfreq%20mode%20config][Keyfreq mode config:1]]
(use-package keyfreq
  :ensure t
  :config (keyfreq-autosave-mode 1)
  (setq keyfreq-file
        (expand-file-name "keyfreq" esc-meta-directory)))
;; Keyfreq mode config:1 ends here

;; [[file:~/.emacs.d/init.org::*Ztree][Ztree:1]]
(use-package ztree :ensure t
  :init
  (setq ztree-dir-move-focus t))
;; Ztree:1 ends here

;; [[file:~/.emacs.d/init.org::*Dumb%20jump%20config][Dumb jump config:1]]
(use-package dumb-jump :ensure t
  :bind ("C-'" . dumb-jump-go)
  :config
  (dumb-jump-mode))
;; Dumb jump config:1 ends here

;; [[file:~/.emacs.d/init.org::*Expand%20region%20config][Expand region config:1]]
(use-package expand-region :ensure t
  ;; :bind ("C-;" . er/expand-region)
  :config
  (defadvice er/expand-region (around fill-out-region activate)
    (if (or (not (region-active-p))
            (eq last-command 'er/expand-region))
        ad-do-it
      (if (< (point) (mark))
          (let ((beg (point)))
            (goto-char (mark))
            (end-of-line)
            (forward-char 1)
            (push-mark)
            (goto-char beg)
            (beginning-of-line))
        (let ((end (point)))
          (goto-char (mark))
          (beginning-of-line)
          (push-mark)
          (goto-char end)
          (end-of-line)
          (forward-char 1))))))
;; Expand region config:1 ends here

;; [[file:~/.emacs.d/init.org::*Eyebrowse%20config][Eyebrowse config:1]]
(use-package eyebrowse :ensure t
  :config (eyebrowse-mode t))
;; Eyebrowse config:1 ends here

;; [[file:~/.emacs.d/init.org::*Clipmon%20config][Clipmon config:1]]
(use-package clipmon :ensure t
  :init
  (defvar clipmon--autoinsert " clipmon--autoinserted-this"))
;; Clipmon config:1 ends here

;; [[file:~/.emacs.d/init.org::*Recentf%20config][Recentf config:1]]
(setq recentf-auto-cleanup 'never)
(use-package recentf
  :ensure t
  :config (setq recentf-max-menu-items 200
                recentf-max-saved-items 15
                recentf-save-file (expand-file-name
                                   "recentf" esc-meta-directory)
                recentf-keep '(file-remote-p file-readable-p)))
;; Recentf config:1 ends here

;; [[file:~/.emacs.d/init.org::*Tea%20time%20config][Tea time config:1]]
(use-package tea-time :ensure t
  :defer t
  :commands tea-time
  :config
  (use-package notifications
    :commands notifications-notify)
  (defun esc/notify-tea-steeped ()
    (notifications-notify :title "Tea time"
                          :body "Rip out that sac, because your tea bag is done"
                          :app-name "Tea Time"
                          :sound-name "alarm-clock-elapsed"))
  (add-hook 'tea-time-notification-hook 'esc/notify-tea-steeped))
;; Tea time config:1 ends here

;; [[file:~/.emacs.d/init.org::*Highlight-numbers%20mode][Highlight-numbers mode:1]]
(use-package highlight-numbers :ensure t
  :config (add-hook 'prog-mode-hook 'highlight-numbers-mode))
;; Highlight-numbers mode:1 ends here

;; [[file:~/.emacs.d/init.org::*Sudo%20edit][Sudo edit:1]]
(use-package sudo-edit :ensure t)
;; Sudo edit:1 ends here

;; [[file:~/.emacs.d/init.org::*Saveplace%20config][Saveplace config:1]]
(use-package saveplace
  :ensure t
  :config
  (setq-default save-place t)
  (setq save-place-file (expand-file-name "places"
                                          esc-meta-directory)))
;; Saveplace config:1 ends here

;; [[file:~/.emacs.d/init.org::*Savehist%20config][Savehist config:1]]
(use-package savehist
  :ensure t
  :config
  (setq savehist-file (concat user-emacs-directory "meta/savehist"))
  (setq savehist-save-minibuffer-history 1)
  (setq savehist-additional-variables
        '(kill-ring
          search-ring
          regexp-search-ring))
  (savehist-mode 1))
;; Savehist config:1 ends here

;; [[file:~/.emacs.d/init.org::*Save%20desktop%20config][Save desktop config:1]]
(defadvice desktop-save-in-desktop-dir (before ensure-desktop-dir-exists activate)
    "Ensure `desktop-dirname' exists before function
  `desktop-save-in-desktop-dir' attempts to save the desktop
  file."
    (mkdir desktop-dirname t))

(setq desktop-path '("~/.emacs.d/meta/desktop/") ;local desktop files
      desktop-base-filename "default"
      desktop-load-locked-desktop t     ;never freeze after crash
      backup-by-copying-when-linked t
      backup-by-copying-when-mismatch t)
(mkdir (car desktop-path) t)            ; ensure desktop-save dir exists
(desktop-save-mode 1)                   ;use desktop file
;; Save desktop config:1 ends here

;; [[file:~/.emacs.d/init.org::*undo-tree%20config][undo-tree config:1]]
(use-package undo-tree
  :ensure t
  :diminish (undo-tree-mode . "")
  :config
  (setq undo-limit (* 1024 1024))
  (undo-tree-mode 1)
  ;; (setq undo-tree-auto-save-history nil)
  (defadvice undo-tree-make-history-save-file-name
      (after undo-tree activate)
    "Make zipped `undo-tree' files obvious."
    (setq ad-return-value (concat ad-return-value ".gz")))

  ;; Thanks to [[http://whattheemacsd.com/my-misc.el-02.html][Magnar]]
  ;; for the advice.
  (defadvice undo-tree-undo (around keep-region activate)
    (if (use-region-p)
        (let ((m (set-marker (make-marker) (mark)))
              (p (set-marker (make-marker) (point))))
          ad-do-it
          (goto-char p)
          (set-mark m)
          (set-marker p nil)
          (set-marker m nil))
      ad-do-it)))
;; undo-tree config:1 ends here

;; [[file:~/.emacs.d/init.org::*Impatient%20mode][Impatient mode:1]]
(use-package impatient-mode :ensure t
  :defer t
  :config
  (defun markdown-html (buffer)
    (princ (with-current-buffer buffer
             (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
           (current-buffer))))
;; Impatient mode:1 ends here

;; [[file:~/.emacs.d/init.org::*Restart-emacs%20config][Restart-emacs config:1]]
(use-package restart-emacs :ensure t)
;; Restart-emacs config:1 ends here

;; [[file:~/.emacs.d/init.org::*Fin][Fin:1]]
(unless (server-running-p) (server-start))
;; Fin:1 ends here

;; [[file:~/.emacs.d/init.org::*Fin][Fin:2]]
(setq Don t    ;allows `eval-buffer' on *scratch*
      Panic t  ;with `initial-scratch-message'
      initial-scratch-message
       (concat (propertize "Don't\nPanic\n"
                   'font-lock-face '(:height 10.0 :inherit variable-pitch))
               "\n")) ;newline makes inserted text normal-sized
;;; .emacs.el ends here
;; Fin:2 ends here

;; [[file:~/.emacs.d/init.org::*Fin][Fin:3]]
(message "All done, %s%s" (user-login-name) ".")
;; Fin:3 ends here
