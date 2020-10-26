from hexany_catalog_common import build_score

build_score("Section 1",                                lilypond=True, gfx=False)
build_score("Section 2", sort="asc",                    lilypond=True, gfx=False)
build_score("Section 3", sort="desc_all",               lilypond=True, gfx=False)
build_score("Section 4", sort="desc_all", reverse=True, lilypond=True, gfx=False)
build_score("Section 5", sort="asc",      reverse=True, lilypond=True, gfx=False)
build_score("Section 6",                  reverse=True, lilypond=True, gfx=False)
