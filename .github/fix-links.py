"""Add the site's base path to links written from the site root.

The course pages link to "/docs/..." and "/assets/..." because the course site is
served at the root of rob550-docs.github.io. On GitHub Pages this site is served at
/<repository>/, so those links get the prefix here. Links that already have it, and
links to other sites ("//..."), are left alone.

Usage: python3 fix-links.py <_site folder> <base path, for example /mbot-ubuntu-server>
"""

import pathlib
import re
import sys

site, base = pathlib.Path(sys.argv[1]), sys.argv[2].rstrip("/")
if not base:
    sys.exit(0)
pattern = re.compile(r'((?:href|src)=")/(?!/|%s/)' % re.escape(base.lstrip("/")))
changed = 0
for page in site.rglob("*.html"):
    text = page.read_text(encoding="utf-8")
    new = pattern.sub(r"\1%s/" % base, text)
    if new != text:
        page.write_text(new, encoding="utf-8")
        changed += 1
print("links fixed in %d pages" % changed)
