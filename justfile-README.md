# Justfile

- Justfile docs - https://just.systems/man/en/
- Justfile cheatsheet https://cheatography.com/linux-china/cheat-sheets/justfile/

<!-- TODO: add below commented out to current Justfile README -->

<!-- ############################################################
# Global user level Justfile for commands (https://just.systems/man/en/chapter_68.html)
############################################################
# - To NOT create all aliases for ALL user global justfile recipes, have a "forwarding alias" in .zshrc (Add to shell e.g. ZSH rc file .zshrc)
# ...
# alias .j='just --justfile ~/.user.justfile --working-directory .'
# ...
# Now, If you have a recipe called foo in ~/.user.justfile, you can just type call foo like below
# $ .j foo
##########################################
# - To create aliases for ALL user global justfile recipes (Add to shell e.g. ZSH rc file .zshrc) 
# ...
# for recipe in `just --justfile ~/.user.justfile --summary`; do
#   alias $recipe="just --justfile ~/.user.justfile --working-directory . $recipe"
# done
# ...
# Now, If you have a recipe called foo in ~/.user.justfile, you can just type foo at the command line to run it.
# $ foo 
##########################################
# User justfile customizations
#
# You can customize the above aliases with additional options.
# For example, if you’d prefer to have the recipes in your justfile run in your home directory, instead of the current directory:
#
# alias .j='just --justfile ~/.user.justfile --working-directory ~'
############################################################

############################################################
# Per-project justfiles configuration + relationship to global user justfile
# - https://www.stuartellis.name/articles/just-task-runner/#creating-a-user-justfile-for-global-tasks
# - https://www.stuartellis.name/articles/just-task-runner/#using-modules
# Justfile modules (needs "unstable" flag to be used)
############################################################
# [User home]
#
# - .user.justfile
#
###### [Project Root]
# 
# - .justfile
#
# - $TOOL.just (1 $TOOL.just for each project-specific tool)
#                                        e.g. PROJROOT/pre-commit.just (imported as 'mod precommit')
#                                        e.g. PROJROOT/python/mod.just (imported as 'mod python')
########## [Project Component subdir]
# - .mod.just (specific to a curr project component) (this is a Justfile module and needs "unstable" flag to be used)
############################################################
# Using Modules
# If you decide to use just modules in your project, consider following these guidelines:
#
# - Create the first recipe in the root justfile with the name help. Write @just –list in the body of the recipe. When just is invoked without a module or recipe name, it runs the first recipe in the justfile.
# - Create an extra mod.just file in each subdirectory that relates to a specific component or type of work. You may not need a separate module for every main subdirectory in the project.
# - Create an extra .just file in the root directory for each tool that applies to the entire project, such as pre-commit.
# - Use the root justfile to define standard tasks for the project. Each of these should call the relevant recipes in one or more modules. Avoid writing recipes in the justfile that do anything other than running recipes that are defined in modules.
# - Remember that the first recipe in each mod.just file is the default for the module. This means that the first recipe runs when a user types the module without specifying the name of the task.
# - Specify the no-cd attribute on each recipe in a module, so that the working directory of the recipe is the root directory of the project.
#
#
# Example Project ROOT justfile (justfile)
#
#
# ```
# mod precommit  # Defined by pre-commit.just file in root directory
# mod python  # Defined by mod.just file in python/ directory
# 
# # List available recipes
# help:
#     @just --unstable --list
# 
# # Install tools and dependencies, then set up environment for development
# bootstrap:
#     @just --unstable install
#     @just --unstable setup
# 
# # Build artifacts
# build:
#     @just --unstable python::build
# 
# # Install project tools and dependencies
# install:
#     @just --unstable python::install
# 
# # Run all checks
# lint:
#     @just --unstable pre-commit::check
# 
# # Set up environment for development
# setup:
#     @just --unstable python::setup
#     @just --unstable pre-commit::setup
# ```
#
############################################################
#
# Example Project Component Module justfile (mod.just)
#
#
# # Check the project with pre-commit
# check:
#     @pre-commit run --all-files

# # Run a specific pre-commit check on the project
# run hook-id:
#     @pre-commit run "{{ hook-id }}" --all-files

# # Setup pre-commit for use
# setup:
#     @pre-commit install
# 
#
#
############################################################ -->
