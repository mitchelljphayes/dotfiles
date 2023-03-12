# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=True

# Cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Python startup file
export PYTHONSTARTUP=$HOME/.pythonrc


