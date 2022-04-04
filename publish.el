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
;; Also support loading weblorg form /opt/weblorg. This is for use with the nanzhong/weblorg image.
;; See the volume mount in the Makefile for more context.
(add-to-list 'load-path "/opt/weblorg")

;; Setup package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install and configure dependencies
(use-package templatel :ensure t)
(use-package htmlize
  :ensure t
  :config
  (setq org-html-htmlize-output-type 'css))

(require 'weblorg)

(setq weblorg-default-url "https://bhankas.github.io")

(weblorg-site
 :template-vars '(("site_name" . "bhankas")
                  ("site_owner" . "bhankas")
                  ("site_description" . "bhankas")))

;; Generate blog posts


(weblorg-route
 :name "index"
 :input-pattern "index.org"
 :template "index.html"
 :output "index.html"
 :url "/")

(weblorg-route
 :name "posts"
 :input-pattern "posts/*.org"
 :template "post.html"
 :output "blog/{{ slug }}.html"
 :url "/blog/{{ slug }}.html")

(weblorg-route
 :name "blog"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "blog.html"
 :output "blog/index.html"
 :url "/blog")

(weblorg-route
 :name "feed"
 :input-pattern "posts/*.org"
 :input-aggregate #'weblorg-input-aggregate-all-desc
 :template "feed.xml"
 :output "blog/feed.xml"
 :url "/feed.xml")

;; Generate pages
(weblorg-route
 :name "pages"
 :input-pattern "pages/*.org"
 :template "page.html"
 :output "/blog/{{ slug }}/index.html"
 :url "/{{ slug }}")

(weblorg-copy-static
 :output "blog/static/{{ file }}"
 :url "/static/{{ file }}")

(weblorg-export)
;;; publish.el ends here
