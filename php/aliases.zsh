
alias art='php artisan'
alias ma='php artisan make:'
alias artm='php artisan migrate'
alias artmr='php artisan migrate:reset'
alias arts='php artisan db:seed'
alias dm='php artisan migrate:fresh --path=/database/migrations/CNMC --env=testing && php artisan migrate --env=testing --seed'
alias cm= 'php artisan migrate:fresh --env=testing && php artisan db:seed --class=TestingSeeder --env=testing'
# Tests
alias t='vendor/bin/phpunit --exclude-group External'
alias tcoverage='vendor/bin/phpunit --exclude-group External --coverage-html reports/'
alias tcoveragefull='vendor/bin/phpunit --coverage-html reports/'
alias tf='vendor/bin/phpunit --filter'
# Git
alias greset='git reset --soft HEAD^1'
alias credentials='git config credential.helper "cache --timeout=28800"'

# Alias Fer
### GIT
alias fer='git co   nfig user.name "Fernando Baeza" &&  git config user.email "fernando.baeza@zataca.com"'
alias pass='git config --global credential.helper store'
### ZSH
alias e='exit'
alias cl='clear'
### Database
alias test='composer migrate:testing'
alias dev='composer migrate:dev'
alias dep='composer migrate:deploy'
### Composer --> Necesario si se modifica el composer.json
alias autoload='composer dump-autoload'
alias load='composer dump-autoload'
alias ci='composer install'
### Hooks Tools
### Test
alias tc='art test'
### Front Vue
alias clean='yarn watch --clean'
alias prod='yarn build --prod'
alias yi='yarn install'

# Libraries
alias gh='php bin/githooks'
alias gfix='cd .git && chgrp -R zataca objects && chmod -R g+rws objects && chmod -R 777 objects && ..'
alias githooks='vendor/bin/githooks'
alias gi='vendor/bin/githooks init'
alias f='php-cs-fixer'
alias crc='php composer-require-checker.phar'
alias com="git cam 'Fix' && git push"
alias cypress="node_modules/.bin/cypress"
alias hooks='githooks tool all'
alias phinx='vendor/bin/phinx'
alias phinxm='vendor/bin/phinx migrate'
alias phinxr='vendor/bin/phinx rollback'
alias phinxrb='vendor/bin/phinx rollback -t 0'

# Dusk
alias d='php artisan dusk'
alias df='php artisan dusk --filter'
alias dprepare='php artisan dusk:chrome-driver --detect' # Detecta e instala el chrome driver