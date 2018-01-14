#!/usr/bin/env bash
script_dir=$(dirname "$(dirname "$0")")
export GRASS_PYTHON=$script_dir/Resources/bin/pythonw
$script_dir/Resources/bin/python $script_dir/Resources/bin/grass72 -gui $@
