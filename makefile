
run:
	@./nspace
	@mv build/posts/* build/
	@rmdir build/posts
	@mv build/stars/* build/
	@rmdir build/stars
	# old_links:
	@rm -rf build/languages
	@mv build/old_links/languages build/
	@rm -rf build/rust
	@mv build/old_links/rust build/
	@rm -rf build/tmux
	@mv build/old_links/tmux build/
	@rm -rf build/unix
	@mv build/old_links/unix build/
	@rm -rf build/ocaml
	@mv build/old_links/ocaml build/
	@rm -rf build/git
	@mv build/old_links/git build/
	@rm -rf build/bash
	@mv build/old_links/bash build/
	@rmdir build/old_links
	#images
	# @mkdir -p build/images
	# @cp  images/* build/images

deploy:
	bash publish.sh
