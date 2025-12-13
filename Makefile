LUAROCKS ?= luarocks
LUA      ?= lua
ROCKSPEC := rockspecs/lua-req-dev-1.rockspec

.PHONY: install run test watch watch-run clean dev_bin

install:
	$(LUAROCKS) make --local $(ROCKSPEC)

run: install
	$(LUA) -lluarocks.loader bin/main.lua

test: install
	busted spec/

watch:
	watchexec -r -w src -w types -w rockspecs -e lua,rockspec -- make install

watch-run:
	watchexec -r -w src -w types -w rockspecs -e lua,rockspec -- make run

clean:
	@echo "Optionally remove installed rock:"
	@echo "  $(LUAROCKS) remove --local lua-req"

run_dev_bin:
ifndef BIN
	@echo "Usage: make dev_bin BIN=<name>"
	@exit 1
endif
	$(LUA) ./dev_bin/$(BIN).lua

