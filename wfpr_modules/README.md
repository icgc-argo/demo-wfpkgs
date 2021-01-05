# Workflow Package Installation Directory

This directory contains all dependent workflow packages, it's to be populated by package
management tools.

Ideally this directory does not need to be added to git repo, similar to NPM's `node_modules`
directory. Instead, all dependent modules are to be installed at build/deployment time. But
let's keep the modules checked into git repo before deployment time installation is supported.
