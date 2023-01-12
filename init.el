;;
;; パッケージ読み込み
;;

(require 'package)

;; HTTP
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/") t)

(package-initialize)

;; フォントを Ricty Diminished (変更したい場合)
;; (add-to-list 'default-frame-alist '(font . "Ricty Diminished-14"))

;; フォントの行間を指定 (変更したい場合)
;; (setq-default line-spacing 0.2)

;; 時間も表示
(display-time)

;; emacs テーマ選択
(load-theme 'manoj-dark t)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; alpha
(if window-system
    (progn
      (set-frame-parameter nil 'alpha 95)))

;; font
(add-to-list 'default-frame-alist '(font . "ricty-12"))

;; line number の表示
(require 'linum)
(global-linum-mode 1)

;; line number を分かりやすくする
(set-face-attribute 'linum nil
            :foreground "#a9a9a9"
            :background "#404040"
            :height 0.9)

;; メニューバーを非表示
(menu-bar-mode 0)

;; 現在ポイントがある関数名をモードラインに表示
(which-function-mode 1)

;; 対応する括弧をハイライト
(show-paren-mode 1)

;; リージョンのハイライト
(transient-mark-mode 1)

;; current directory 表示
(let ((ls (member 'mode-line-buffer-identification
                  mode-line-format)))
  (setcdr ls
    (cons '(:eval (concat " ("
            (abbreviate-file-name default-directory)
            ")"))
          (cdr ls))))

;; ターミナルで起動したときにメニューを表示しない
(if (eq window-system 'x)
    (menu-bar-mode 1) (menu-bar-mode 0))
(menu-bar-mode nil)

;; buffer の最後でカーソルを動かそうとしても音をならなくする
(defun next-line (arg)
  (interactive "p")
  (condition-case nil
      (line-move arg)
    (end-of-buffer)))

;; active window move
(global-set-key (kbd "<c-left>")  'windmove-left)
(global-set-key (kbd "<c-down>")  'windmove-down)
(global-set-key (kbd "<c-up>")    'windmove-up)
(global-set-key (kbd "<c-right>") 'windmove-right)

;; rgrep の header message を消去
(defun delete-grep-header ()
  (save-excursion
    (with-current-buffer grep-last-buffer
      (goto-line 5)
      (narrow-to-region (point) (point-max)))))
(defadvice grep (after delete-grep-header activate) (delete-grep-header))
(defadvice rgrep (after delete-grep-header activate) (delete-grep-header))

;; "grep バッファに切り替える"
(defun my-switch-grep-buffer()
  (interactive)
    (if (get-buffer "*grep*")
            (pop-to-buffer "*grep*")
      (message "No grep buffer")))
(global-set-key (kbd "s-e") 'my-switch-grep-buffer)

;; 履歴参照
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

;; Terminal 化
(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
(global-set-key (kbd "C-c o") 'shell-pop)

;;
;; setq
;;


;; クリップボードへのコピー
(setq x-select-enable-clipboard t)

;; C-k で行全体を削除する
(setq kill-whole-line t)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; エラー音をならなくする
(setq ring-bell-function 'ignore)

;; *.~  バックアップファイルを作らない
(setq make-backup-files nil)

;; .#*  バックアップファイルを作らない
(setq auto-save-default nil)

;; tabサイズ
(setq default-tab-width 4)

;; タイトルにフルパス表示
(setq frame-title-format "%f")

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message 1)

;; scratch の初期メッセージ消去
(setq initial-scratch-message "")

;; スクロールは 1 行ごと
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))

;; スクロールの加速をやめる
(setq mouse-wheel-progressive-speed nil)

;; 大文字・小文字を区別しない
(setq case-fold-search t)

;; rgrep 時などに新規に window を立ち上げる
(setq special-display-buffer-names '("*Help*" "*compilation*" "*interpretation*" "*grep*" ))

;;
;; define-key
;;

;; Contol H で 1 文字削除
(define-key global-map "\C-h" 'delete-backward-char)

;; 上記定義では Mini Buffer 内では削除できない可能性があるので以下を再定義
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)

;; ヘルプの表示を M-? 変更
(define-key global-map "\M-?" 'help-for-help)

;;
;; put
;;

;; リージョンの大文字小文字変換
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(tabbar-ruler tabbar)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;
;; tabbarの設定
;;
(require 'tabbar)
(tabbar-mode)

(tabbar-mwheel-mode nil)                  ;; マウスホイール無効
(setq tabbar-buffer-groups-function nil)  ;; グループ無効
(setq tabbar-use-images nil)              ;; 画像を使わない

;;----- キーに割り当てる
;;(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
;;(global-set-key (kbd "<C-S-tab>") 'tabbar-backward-tab)
(global-set-key (kbd "<f8>") 'tabbar-forward-tab)
(global-set-key (kbd "<f7>") 'tabbar-backward-tab)
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z C-n") 'tabbar-forward-tab)
(global-set-key (kbd "C-z C-p") 'tabbar-backward-tab)

;;----- 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))


;;----- タブのセパレーターの長さ
(setq tabbar-separator '(2.0))


;;----- タブの色（CUIの時。GUIの時は後でカラーテーマが適用）
(set-face-attribute
 'tabbar-default nil
 :background "brightblack"
 :foreground "white"
 )
(set-face-attribute
 'tabbar-selected nil
 :background "#ff5f00"
 :foreground "brightwhite"
 :box nil
 )
(set-face-attribute
 'tabbar-modified nil
 :background "brightred"
 :foreground "brightwhite"
 :box nil
 )

(when window-system                       ; GUI時
  ;; 外観変更
  (set-face-attribute
   'tabbar-default nil
   :family "MeiryoKe_Gothic"
   :background "#34495E"
   :foreground "#EEEEEE"
   :height 0.85
   )
  (set-face-attribute
   'tabbar-unselected nil
   :background "#34495E"
   :foreground "#EEEEEE"
   :box nil
  )
  (set-face-attribute
   'tabbar-modified nil
   :background "#E67E22"
   :foreground "#EEEEEE"
   :box nil
  )
  (set-face-attribute
   'tabbar-selected nil
   :background "#E74C3C"
   :foreground "#EEEEEE"
   :box nil)
  (set-face-attribute
   'tabbar-button nil
   :box nil)
  (set-face-attribute
   'tabbar-separator nil
   :height 2.0)
)

;;----- 表示するバッファ
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; Always include the current buffer.
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((equal "*scratch*" (buffer-name b)) b) ; *scratch*バッファは表示する
                     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

