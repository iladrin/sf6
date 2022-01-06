SYMFONY=symfony
EXEC=$(SYMFONY) run
CONSOLE=$(SYMFONY) console
PHP=$(SYMFONY) php
PHPCSFIXER?=$(SYMFONY) php -d memory_limit=1024m vendor/bin/php-cs-fixer
COMPOSER=$(SYMFONY) composer

.PHONY: help deploy clean start stop status logs browse phpcs phpcsfix security assets assets-watch
.DEFAULT_GOAL := help

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-20s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
## Server commands
##---------------------------

start:									## Run the the PHP server in background
	@$(SYMFONY) serve -d

stop:									## Stop your running server
	@$(SYMFONY) server:stop

status:									## Get status information on your server
	@$(SYMFONY) server:status

logs:									## Access your server logs
	@$(SYMFONY) server:log

browse:									## Open the app in your web browser
	@$(SYMFONY) open:local

##
##
## Deployment commands
##---------------------------

deploy: .env.local vendor assets				## Deploy the whole project
	@echo "\n\033[35m* Project ready\033[0m"
	@echo "\033[35m\n-> Try a \033[34mmake start\033[35m, then \033[34mmake browse\033[0m.\033[0m"

clean:									## Remove the generated files
	rm -rf vendor/ var/log/ var/cache/ node_modules/ public/build/

.env.local: .env
	@echo "\n\033[35m* Creating \033[34m.env.local\033[35m file, based upon your \033[34m.env\033[35m file.\033[0m"
	@cp .env .env.local

vendor: vendor/composer/installed.php

vendor/composer/installed.php: composer.lock
	$(COMPOSER) install -n

composer.lock: composer.json
	@echo composer.lock is not up to date.

assets: public/build

assets-watch: assets					## Regenerate web assets as long as they change
	$(EXEC) yarn dev-server

node_modules: yarn.lock
	$(EXEC) yarn install

public/build: node_modules
	@echo "\n\033[35m* Deploying assets.\033[0m"
	$(EXEC) yarn dev

#vendor/autoload.php: composer.lock
#	@echo "\n\033[35m* Installing PHP dependencies\033[0m"
#	$(COMPOSER) install --prefer-dist --no-progress --quiet
#	@touch vendor/autoload.php

##
##
## Quality tools
##---------------------------

phpcs: vendor							## Lint PHP code
	$(PHPCSFIXER) fix --diff --dry-run --no-interaction -v

phpcsfix: vendor						## Lint and fix PHP code to follow the convention
	$(PHPCSFIXER) fix

security:								## Check for vulnerabilities in PHP dependencies
	$(SYMFONY) local:check:security
