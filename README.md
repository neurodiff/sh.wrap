# sh.wrap - bash modules with scope

\`sh.wrap\` is a project to test @russianworld team coordination and improve its software engineering practices.

If you're not in @russianworld but interesting what is going on here see [sh.wrap documentation](https://ekotik.github.io/sh.wrap) for the details about the project.


## Why

Shell is available on every Unix platform out of the box where other programming environments could not be available.  Shell scripts are used widely for task automation, in build systems, on routers, etc.  And we want a module system to keep shell scripts organized.  We want scripts to be modular, reusable and probably extendable.

\`sh.wrap\` is a project to provide module system for shell scripting.


## Requirements

As the project has no test matrix it's hard to say what is supported.
Developers machines are Linux, bash 5.2.2 (4.3+ should work too, but not tested).
Shells other that bash (zsh, dash) are not supported currently.


## Installation

To install \`sh.wrap\` from the source code clone its repository to the desired location.
A default location is suggested to be '~/.sh.wrap/sh.wrap'

    git clone https://github.com/ekotik/sh.wrap ~/.sh.wrap/sh.wrap

Then add these lines to '~/.bashrc'

    export SHWRAP_INIT_DIR=~/.sh.wrap/sh.wrap/src
    source "${SHWRAP_INIT_DIR}"/init.sh || true

If your installation path is not '~/.sh.wrap/sh.wrap' change \`SHWRAP\_INIT\_DIR\` variable.  When it's done the new shell should have commands \`shwrap\_import\` and \`shwrap\_run\` to import a module and to run commands in the module scope.


## Usage

These are valid \`shwrap\_import\` commands.

    shwrap_import module.sh
    shwrap_import module.sh function_name
    shwrap_import module.sh function_name1 function_name2 ...

When a **module name** is imported from a **module** it becomes available for usage as a wrapper to \`shwrap\_run\` with the same name.  No renaming of imported names are currently supported.  **Default import** (the first example) imports only exported function names (with \`declare -fx\` or \`export -f\`).

\`sh.wrap\` cache modules on import, so code from module is executed only once (the same behavior as in Python).

Module name could be a relative or an absolute path. If a module name starts with './' or '../' it is a relative path. If it starts with '/' it is an absolute path.
If a module is not a relative or an absolute path it is searched in the special locations in order.

The order of the **module search**:

-   absolute and relative path
-   SHWRAP\_MODULE\_PATHS
-   load paths
-   SHWRAP\_MODULE\_PATH
-   current directory (as a fallback)

Firstly \`SHWRAP\_MODULE\_PATHS\` are checked.  A module could extend its own search paths by adding relative or absolute paths to this array variable.  Also user can change it globally.  Then load paths are checked.  That are the paths of modules that are in the **import chain** of the module.  Then \`SHWRAP\_MODULE\_PATH\` is checked which default is '~/.sh.wrap'.  As a fallback we search current directory if something is broken at the previous steps.

These are valid \`shwrap\_run\` commands.

    shwrap_run module.sh variable=value
    shwrap_run module.sh function_name argument1 argument2 ...
    shwrap_run module.sh '{ declare -p; declare -f; }'


## Limitations

Usual shell scripts could be imported without changes but with some considerations.  It's preferred if a module contains only function and variable definitions as code execution may affect module functionality in an unexpected manner.

Implementation limitations:

-   no arguments could be passed to a module (TBD)
-   no runnable scripts are supported (as arguments cannot be passed)
-   user can't unset globally exported variables inside a module (TBD)
-   names with \`\_shwrap\` and \`\_SHWRAP\` prefixes are considered reserved
-   some file descriptors are used and reserved for internal usage. \`SHWRAP\_FD\_RANGE\` array variable could be used to reassign them per module or globally or both.
-   \`shwrap\_import\` and \`shwrap\_run\` functions don't support asynchronous running or running in a subshell (because of lack of synchronization for \`\_shwrap\_scope\`)


## Known issues

There are performance issues in current implementation.  Running a command in a module scope is slower than its usual execution because of work that should be done.  A module import is slow too.

Currently \`sh.wrap\` has no return codes checking and do not revert changes for unsuccessful import.

When file descriptors are not enough it's broken.  It could happen when import chain is too deep.  Two file descriptors allocated per a module import in a module chain (plus some more in the special cases).

Although this implementation supports cyclic module import (to break \`source\` infinite loops) it's better to avoid such cases.  Cyclic module import algorithm uses partially imported module at the point where cyclic import occurs.  When dependent module is fully imported partial imports are fixed.


## Developer notes

Current implementation has no parser, instead it uses combination of \`source\` and \`declare\` to serialize module definitions.  Serialized module is injected into a separate shell process spawned with \`env\`.
