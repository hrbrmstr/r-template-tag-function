# This is a justfile (https://github.com/casey/just)
# Good cheatsheet (https://cheatography.com/linux-china/cheat-sheets/justfile/)

# project dir
project := "webr-pyodide-minimal-plus-markdown"
	
# where to sync ./build
syncDest := "rud.is:~/rud.is/w/" + project + "/"

# default recipe to display help information
default:
  @just --list

# This is a justfile (https://github.com/casey/just)

# install exmd
install-exmd:
	@npm install -g hrbrmstr/exmd

# render index.html
render:
	@exmd index.md

# install/update miniserve
install-miniserve:
  cargo install miniserve

# serve project (requires miniserve)
serve:
	@miniserve \
		--header "Cache-Control: no-cache; max-age=1" \
		--header "Cross-Origin-Embedder-Policy: require-corp" \
		--header "Cross-Origin-Opener-Policy: same-origin" \
		--header "Cross-Origin-Resource-Policy: cross-origin" \
		--index index.html \
		.

browse:
	@open -a "Google Chrome Beta"  http://localhost:8080/

# serve project (requires miniserve)
serve-build:
	@miniserve \
		--header "Cache-Control: no-cache; max-age=1" \
		--header "Cross-Origin-Embedder-Policy: require-corp" \
		--header "Cross-Origin-Opener-Policy: same-origin" \
		--header "Cross-Origin-Resource-Policy: cross-origin" \
		--index index.html \
		build

# sync to server
rsync:
  rsync -avp ./build/ {{syncDest}}

# publish to GH
github:
	@git add -A
	@git commit -m "chore: lazy justfile commit" 
	@git push

# be environmentally conscious
rollup:
	@rm -rf build/
	@npx rollup --config
