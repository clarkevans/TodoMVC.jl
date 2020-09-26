#!/usr/bin/env julia

using TodoMVC
using NarrativeTest

subs = NarrativeTest.common_subs()

# Set the width to 72 so that MD->PDF via pandoc fits the page.
ENV["COLUMNS"] = "72"

package_path(x) = relpath(joinpath(dirname(abspath(PROGRAM_FILE)), "..", x))
default = package_path.(["doc/src", "README.md"])
runtests(; default=default, subs=subs)
