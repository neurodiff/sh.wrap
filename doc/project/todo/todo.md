---
title: Pool of tasks
date: 2022-05-21T04:04:13+03:00
aliases:
  - /project/todo/todo.md
  - /project/todo/todo.org
url: /project/todo/todo.html
tags: ["project", "task"]
weight: 31
---

sh.wrap (project tasks)
=======================

1.  Code: sh.wrap (project tasks)

    1.  PROGRESS Create workflow to run tests on push, PR

        **DEADLINE:** *\<2023-01-11 Wed\>* **SCHEDULED:** *\<2023-01-11 Wed\>*
        \<2023-01-11 Wed\>

        1.  NEXT Migrate to actions 0.0.1 with prebuilt docker images

            **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-12 Thu\>*
            \<2023-01-10 Tue\>

    2.  Code: Documentation generation (project tasks)

        1.  PROGRESS Chose documentation generation system

            **DEADLINE:** *\<2023-01-09 Mon\>* **SCHEDULED:** *\<2023-01-08 Sun\>*
            \<2023-01-03 Tue\>

            1.  PROGRESS Integrate documentation generation into documentation pipeline

                **DEADLINE:** *\<2023-01-11 Wed\>* **SCHEDULED:** *\<2023-01-11 Wed\>*
                \<2023-01-11 Wed\>

            2.  <span class="done DONE">DONE</span> Document existing code base

                **CLOSED:** *\[2023-01-11 Wed 13:18\]* **DEADLINE:** *\<2023-01-11 Wed\>* **SCHEDULED:** *\<2023-01-11 Wed\>*
                \<2023-01-11 Wed\>

    3.  Code: Repository maintenance (project tasks)

    4.  Code: core (project tasks)

        1.  NEXT Write unit tests for core functions

            **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-11 Wed\>*

        2.  PROGRESS Fix busybox realpath is different

            **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-11 Wed\>*
            \<2023-01-11 Wed\>

        3.  Docs: Milestone 0.0.1 (project tasks)

            1.  NEXT Update Changelog

                **DEADLINE:** *\<2023-01-13 Fri\>* **SCHEDULED:** *\<2023-01-13 Fri\>*
                \<2023-01-12 Thu\>

            2.  NEXT Update README.md

                **DEADLINE:** *\<2023-01-13 Fri\>* **SCHEDULED:** *\<2023-01-13 Fri\>*
                \<2023-01-12 Thu\>

        4.  <span class="done DONE">DONE</span> Check and fix unset for globally exported variables inside a module

            **CLOSED:** *\[2023-01-07 Sat 15:52\]* **DEADLINE:** *\<2022-12-31 Sat\>* **SCHEDULED:** *\<2022-12-22 Thu\>*
            \<2022-12-20 Tue\>

        5.  <span class="done DONE">DONE</span> Fix bash 5.0 unset \_shwrap\_fds\[\"\${fd\_scope}\"\]: bad array subscript

            **CLOSED:** *\[2023-01-12 Thu 10:26\]*
            \<2023-01-12 Thu\>

2.  Docs: sh.wrap (project tasks)

    1.  NEXT Pass conversion options and command line arguments to pandoc-convert workflow

        \<2022-11-05 Sat\>

        1.  GOAL org-to-md.sh and pandoc-convert workflow \[0/5\]

            -   \[ \] extensions sets
                -   \[ \] clean set (-raw\_attribute...)
                -   \[ \] line break set (+hard\_line\_breaks...)
            -   \[ \] command-line arguments
                -   \[ \] --wrap=auto\|none\|preserve
                -   \[ \] --shift-heading-level-by=NUMBER
            -   \[ \] default sets of options enabled by default
            -   \[ \] rest command line options (by user request)
            -   \[ \] rest pandoc extensions (by user request)

    2.  Docs: Documentation (project tasks)

        1.  NEXT Add \"Getting started\" page to documentation

            **DEADLINE:** *\<2023-01-10 Sun\>* **SCHEDULED:** *\<2023-01-10 Sun\>*
            \<2022-12-20 Tue\>

        2.  NEXT Add \"Usage\" page to documentation

            **DEADLINE:** *\<2023-01-10 Sun\>* **SCHEDULED:** *\<2023-01-10 Sun\>*
            \<2022-12-20 Tue\>

        3.  PROGRESS Create user, development and project sections

            **DEADLINE:** *\<2023-01-10 Tue\>* **SCHEDULED:** *\<2023-01-10 Tue\>*
            \<2022-12-22 Thu\>

    3.  Docs: Documentation system (project tasks)

        1.  NEXT \[\#C\] Describe documentation system

            \<2022-10-31 Mon\>

    4.  <span class="done DONE">DONE</span> Add README

        **CLOSED:** *\[2022-12-27 Tue 20:38\]* **DEADLINE:** *\<2022-12-22 Thu\>* **SCHEDULED:** *\<2022-12-22 Thu\>*
        1.  PASS Minimal README.md contains

            **CLOSED:** *\[2022-12-27 Tue 20:38\]*
            -   \[X\] project description
            -   \[X\] installation notes
            -   \[X\] example of usage
            -   \[X\] links to project documentation

3.  Infra: sh.wrap (project tasks)

    1.  NEXT Add repository\_dispatch events to trigger documentation rebuild

        \<2022-10-30 Sun\>

    2.  PROGRESS Update docker.org in actions-org with actual documentation

        \<2023-01-08 Sun\>

    3.  Infra: Documentation generation (project backlog)

        1.  <span class="done DONE">DONE</span> Add script and GH action for documentation generation system

            **CLOSED:** *\[2023-01-11 Wed 14:49\]* **DEADLINE:** *\<2023-01-11 Wed\>* **SCHEDULED:** *\<2023-01-11 Wed\>*
            \<2023-01-11 Wed\>

    4.  Infra: Prebuilt docker images in GH actions (project tasks)

        1.  <span class="done DONE">DONE</span> \[\#A\] Create GH actions to use docker images from docker hub

            **CLOSED:** *\[2023-01-10 Tue 09:53\]* **DEADLINE:** *\<2023-01-08 Sun\>* **SCHEDULED:** *\<2023-01-08 Sun\>*
            \<2022-10-31 Mon\>

            1.  <span class="done DONE">DONE</span> Fix test-workflows-hub permission denied

                **CLOSED:** *\[2023-01-10 Tue 09:48\]* **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-10 Tue\>*
                \<2023-01-10 Tue\>

    5.  Infra: sh.wrap testing environment (project tasks)

        1.  <span class="done DONE">DONE</span> Create docker containers and GH action for test harness

            **CLOSED:** *\[2023-01-10 Tue 18:30\]* **DEADLINE:** *\<2023-01-09 Mon\>* **SCHEDULED:** *\<2023-01-09 Mon\>*
            \<2023-01-04 Wed\>

4.  Plan: sh.wrap (project tasks)

    1.  Plan: Milestone 0.0.1 (project tasks)

        1.  <span class="done DONE">DONE</span> Milestone 0.0.1: Estimate tasks effort

            **CLOSED:** *\[2023-01-08 Sun 13:08\]*

        2.  <span class="done DONE">DONE</span> Milestone 0.0.1: Schedule tasks

            **CLOSED:** *\[2023-01-08 Sun 13:50\]* **DEADLINE:** *\<2023-01-08 Sun\>* **SCHEDULED:** *\<2023-01-08 Sun\>*

        3.  <span class="done DONE">DONE</span> Milestone 0.0.1: Select tasks from current active/backlog/stuck task pools

            **CLOSED:** *\[2023-01-07 Sat 15:54\]*

        4.  <span class="done DONE">DONE</span> Milestone 0.0.1: Update roadmap

            **CLOSED:** *\[2023-01-09 Mon 10:48\]* **DEADLINE:** *\<2023-01-09 Mon\>* **SCHEDULED:** *\<2023-01-08 Sun\>*
            1.  COMPLETE [Write requirements for milestone 0.0.1](#wrfm001)

                **CLOSED:** *\[2023-01-09 Mon 10:48\]*

    2.  Plan: Milestone 0.1.0 (project tasks)

        1.  NEXT Milestone 0.1.0: Estimate efforts

            **SCHEDULED:** *\<2023-01-13 Fri\>*

        2.  NEXT Milestone 0.1.0: Schedule tasks

            **SCHEDULED:** *\<2023-01-13 Fri\>*

        3.  NEXT Milestone 0.1.0: Select tasks

            **SCHEDULED:** *\<2023-01-13 Fri\>*

        4.  NEXT Milestone 0.1.0: Update roadmap

            **SCHEDULED:** *\<2023-01-13 Fri\>*

    3.  Plan: Roadmap (project tasks)

        1.  NEXT Describe sh.wrap purpose and vision

        2.  <span class="done DONE">DONE</span> Create roadmap diagram for milestone

            **CLOSED:** *\[2023-01-08 Sun 16:09\]* **DEADLINE:** *\<2023-01-09 Mon\>* **SCHEDULED:** *\<2023-01-08 Sun\>*

        3.  <span class="done DONE">DONE</span> Write requirements for milestone 0.0.1

            **CLOSED:** *\[2023-01-08 Sun 13:53\]* **DEADLINE:** *\<2023-01-08 Sun\>* **SCHEDULED:** *\<2023-01-08 Sun\>*
            <span id="wrfm001"></span>

5.  QA: sh.wrap (project tasks)

    1.  STARTED Write functional tests for core modules

        **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-11 Wed\>*

    2.  PROGRESS \[\#B\] Add issue/pr templates

    3.  QA: sh.wrap test reports (project tasks)

        1.  NEXT Automate test reports publishing

            **DEADLINE:** *\<2023-01-12 Thu\>* **SCHEDULED:** *\<2023-01-12 Thu\>*

    4.  QA: sh.wrap testing environment (project tasks)

        1.  PROGRESS Create test matrix

            \<2022-12-22 Thu\>

            1.  DEPENDENCY [Create docker containers and GH action for workflow with bash versions passed](#cdcagafwwbvp)

        2.  <span class="done DONE">DONE</span> Create test runner

            **CLOSED:** *\[2023-01-10 Tue 15:04\]* **DEADLINE:** *\<2023-01-10 Tue\>* **SCHEDULED:** *\<2023-01-09 Mon\>*
            \<2023-01-08 Sun\>

sh.wrap (project backlog)
=========================

1.  Code: sh.wrap (project backlog)

    1.  <span class="todo TODO">TODO</span> Fix find in test-workflows

        \<2023-01-10 Tue\>

    2.  <span class="todo TODO">TODO</span> Fix trap rewriten error is scripts

        \<2023-01-09 Mon\>

    3.  <span class="todo TODO">TODO</span> Implement ccache module

    4.  <span class="todo TODO">TODO</span> Implement cert module

    5.  <span class="todo TODO">TODO</span> Implement config module

    6.  <span class="todo TODO">TODO</span> Implement git module

    7.  <span class="todo TODO">TODO</span> Implement path module

    8.  <span class="todo TODO">TODO</span> Implement repo module

        1.  <span class="todo TODO">TODO</span> Implement github module

        2.  <span class="todo TODO">TODO</span> Implement gitlab module

    9.  <span class="todo TODO">TODO</span> Implement scheduler module

    10. <span class="todo TODO">TODO</span> Implement test module

        1.  <span class="todo TODO">TODO</span> Implement profile module

    11. <span class="todo TODO">TODO</span> Rename actions.yml to site

        \<2023-01-10 Tue\>

    12. Code: Documentation generation (project backlog)

    13. Code: Repository maintenance (project backlog)

        1.  <span class="todo TODO">TODO</span> Protect GH branches

    14. Code: Repository maintenance (project backlog)

    15. Code: core (project backlog)

        1.  NEXT Add function with argument passing to import

            \<2022-12-22 Thu\>

        2.  COMPLETE Add function to scope

            **CLOSED:** *\[2022-12-22 Thu 13:45\]*

        3.  COMPLETE Add script for bashrc

            **CLOSED:** *\[2022-12-22 Thu 13:45\]*

2.  Docs: sh.wrap (project backlog)

    1.  NEXT Add license

    2.  NEXT Create project logo

        \<2022-12-20 Tue\>

    3.  <span class="todo TODO">TODO</span> Add option to exclude path patterns from conversion in pandoc-convert workflow

        \<2022-11-05 Sat\>

    4.  WRITE Describe knowledge system for the project

    5.  WRITE Describe useful workflows on the project

    6.  Docs: Documentation (project backlog)

        1.  NEXT Fix code blocks not colored properly with hugo renderer

            \<2022-10-31 Mon\>

        2.  NEXT Rework gh-publish workflow

            \<2022-11-05 Sat\>

            1.  GOAL Add features to gh-publish script \[0/3\]

                -   \[ \] pass commit message as argument
                -   \[ \] add option to keep commits history
                -   \[ \] add tag to commit

        3.  <span class="todo TODO">TODO</span> Fix hugo bug with flickering project/docs tag

            \<2022-11-05 Sat\>

        4.  <span class="todo TODO">TODO</span> Fix images not copied to documentation with pandoc-convert GH action

            \<2023-01-08 Sun\>

    7.  Docs: Documentation system (project backlog)

        1.  NEXT Describe documentation generation

            \<2022-10-31 Mon\>

    8.  Docs: sh.wrap: Development documentation (project backlog)

        1.  NEXT Write style guide for the project

3.  Infra: sh.wrap (project backlog)

    1.  NEXT Add repository\_dispatch action to generate documentation on the fly

        \<2022-11-05 Sat\>

    2.  <span class="todo TODO">TODO</span> Add nodejs workflow

        <span id="anw"></span> \<2022-11-05 Sat\>

    3.  <span class="todo TODO">TODO</span> Add spell checker action for project documentation

        \<2022-05-22 Sun\>

    4.  <span class="todo TODO">TODO</span> Cache node\_modules in docsy site generation

        \<2022-11-05 Sat\>

        1.  DEPENDENCY [Add nodejs workflow](#anw)

    5.  <span class="todo TODO">TODO</span> Make universal docker workflow and action

        \<2022-11-05 Sat\>

        1.  GOAL Docker workflows and actions \[0/2\]

            -   \[ \] one universal workflow and action to all tasks
            -   \[ \] workflow/action parameters
                -   \[ \] all parameters are serialized in one file (like workflow tests do)
                -   \[ \] no workaround when rest arguments are passed as string to parse

    6.  <span class="todo TODO">TODO</span> Write script to sync working repositories with upstream

    7.  Infra: Use ready docker images in GH actions (project backlog)

        1.  NEXT Create GH actions to generate and push docker images

            \<2022-10-31 Mon\>

    8.  Infra: sh.wrap testing environment (project backlog)

        1.  NEXT Create docker containers and GH action for workflow with bash versions passed

            <span id="cdcagafwwbvp"></span> \<2022-12-22 Thu\>

4.  Plan: sh.wrap (project backlog)

    1.  <span class="todo TODO">TODO</span> Write project review/report templates

    2.  Plan: Milestone 0.0.1 (project backlog):

    3.  Plan: Milestone 0.1.0 (project backlog)

    4.  Plan: Roadmap (project backlog)

5.  QA: sh.wrap (project backlog)

    1.  <span class="todo TODO">TODO</span> Describe GH issue/pr workflows (life-cycle)

        \<2022-05-21 Sat\>

    2.  <span class="todo TODO">TODO</span> Describe issue/test/release verification processes

        \<2022-05-21 Sat\>

    3.  <span class="todo TODO">TODO</span> \[\#C\] Exploratory testing of site generation action

        \<2022-05-21 Sat\>

    4.  QA: sh.wrap test reports (project backlog)

        1.  NEXT Add ability to compare test reports

    5.  QA: sh.wrap testing environment (project backlog)

sh.wrap (project stuck)
=======================

1.  Code: sh.wrap (project stuck)

2.  Docs: sh.wrap (project stuck)

3.  Infra: sh.wrap (project stuck)

4.  Plan: sh.wrap (project stuck)

5.  QA: sh.wrap (project stuck)

sh.wrap (project goals)
=======================

1.  Code: sh.wrap (project goals)

    1.  GOAL Collection of useful shell scripts \[0/2\]

        -   \[ \] gpg functions
        -   \[ \] git functions

    2.  GOAL Maintainable shell scripts repository \[0/3\]

        -   \[ \] Shell scripts are at known locations
        -   \[ \] Shell scripts are reusable
        -   \[ \] Shell scripts have versions

sh.wrap (project archive)
=========================

1.  Code: sh.wrap (project archive)

2.  Docs: sh.wrap (project archive)

3.  Infra: sh.wrap (project archive)

4.  Plan: sh.wrap (project archive)

5.  QA: sh.wrap (project archive)
