;;; publish.el --- Generate a simple static HTML blog
;;; Commentary:
;;
;;    Define the routes of the static website.  Each of which
;;    containing the pattern for finding Org-Mode files, which HTML
;;    template to be used, as well as their output path and URL.
;;
;;; Code:

;; Guarantee the freshest version of the weblorg
(add-to-list 'load-path "../../")

;; Setup package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install and configure dependencies
(use-package templatel :ensure t)
(use-package htmlize)
(setq org-html-htmlize-output-type 'css)

(require 'weblorg)


;; Generate blog posts
(weblorg-route
 :name "posts"
 :input-pattern "src/posts/*.org"
 :template "post.html"
 :output "{{ slug }}.html"
 :url "/{{ slug }}.html")

;; Generate pages
(weblorg-route
 :name "pages"
 :input-pattern "src/pages/*.org"
 :template "page.html"
 :output "{{ slug }}/index.html"
 :url "/{{ slug }}")

;; Generate posts summary
(weblorg-route
 :name "index"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output "index.html"
 :url "/")

(weblorg-route
 :name "feed"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "feed.xml"
 :output "feed.xml"
 :url "/feed.xml")

(weblorg-copy-static
 :output "static/{{ file }}"
 :url "/static/{{ file }}")

(weblorg-site :theme nil)

(weblorg-export)
;;; publish.el ends here
