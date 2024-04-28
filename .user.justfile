# global user level Justfile for commands (https://just.systems/man/en/chapter_68.html)
# set shell := ["bash", "-cu"]

# TODO: update to use tips from below links
# - https://just.systems/man/en/chapter_68.html
# - https://www.stuartellis.name/articles/just-task-runner/
# - https://github.com/casey/just#fallback-to-parent-justfiles

user_justfile_name := ".user.justfile"
dotfiles_root_dir := justfile_directory()
scripts_root_dir := dotfiles_root_dir / "scripts"
chezmoi_root_dir := dotfiles_root_dir / "chezmoi"

# List available recipes
# (TODO: update to add 2nd user justfile command to run aliased HOME dir user justfile)
help:
    @echo "dotfiles root dir: {{dotfiles_root_dir}}"
    @echo "scripts root dir: {{scripts_root_dir}}"
    @just --list -f "{{dotfiles_root_dir}}/{{user_justfile_name}}"

# Display system information
system-info:
    @echo "CPU architecture: {{ arch() }}"
    @echo "Operating system type: {{ os_family() }}"
    @echo "Operating system: {{ os() }}"
    @echo "Home directory: {{ home_directory() }}"

# Install webi (https://webinstall.dev/)
webi-install:
    @curl https://webinstall.dev/ | bash
