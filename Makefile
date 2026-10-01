bin  := $(HOME)/bin
tmp  := /tmp
bins := terramate tofu tofu-ls tofu-wrapper

# https://github.com/terramate-io/terramate/releases
terramate_version     := 0.17.3

# https://github.com/opentofu/opentofu/releases
opentofu_version      := 1.13.1

# https://github.com/opentofu/tofu-ls/releases
tofu_ls_version       := 0.5.3


all: $(bins)

tofu-wrapper: $(bin)/tofu.sh
$(bin)/tofu.sh:
	ln -sf "$(PWD)/bin/tofu.sh" "$@"

# https://github.com/opentofu/opentofu/releases
tofu: $(bin)/tofu
$(bin)/tofu:
	wget --quiet --show-progress --timestamping --directory-prefix $(tmp) \
	"https://github.com/opentofu/opentofu/releases/download/v$(opentofu_version)/tofu_$(opentofu_version)_linux_amd64.zip"
	unzip "$(tmp)/tofu_$(opentofu_version)_linux_amd64.zip" "tofu" -d "$(@D)"
	chmod +x "$@"

clean-tofu:
	rm $(bin)/tofu

# terramate
# https://github.com/gruntwork-io/terragrunt/releases
terramate: $(bin)/terramate
$(bin)/terramate:
	wget --quiet --show-progress --timestamping --directory-prefix $(tmp) \
		"https://github.com/terramate-io/terramate/releases/download/v$(terramate_version)/terramate_$(terramate_version)_linux_x86_64.tar.gz"
	tar xf "$(tmp)/terramate_$(terramate_version)_linux_x86_64.tar.gz" -C "$(@D)"
	chmod +x "$@"

clean-terramate:
		rm $(bin)/terramate

# tofu-ls.  Language service provider needed for some editors.
tofu-ls: $(bin)/tofu-ls
$(bin)/tofu-ls:
		wget --quiet --show-progress --timestamping --directory-prefix $(tmp) \
		"https://github.com/opentofu/tofu-ls/releases/download/v$(tofu_ls_version)/tofu-ls_Linux_x86_64.tar.gz"
		tar xf "$(tmp)/tofu-ls_Linux_x86_64.tar.gz" -C "$(@D)"
		chmod +x "$@"

clean-tofu-ls:
		rm $(bin)/tofu-ls
