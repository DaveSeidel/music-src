from itertools import combinations, chain


# this actually creates the catalog
def get_chord_list(elements, subset, reverse=False):
    chords = []

    for x in combinations(range(elements), subset):
        chords.append([
            n if n in x else None
            for n in range(elements) 
        ])        

    if reverse:
        return sorted(chords, key=lambda x: sorted(x, reverse=True), reverse=True)
    else:
        return chords


# low to high, small to large per Tom Johnson
def build_chord_catalogue(scale_size, start=2, end=None, reverse=False):
    if not end:
        end = scale_size + 1
    return _flatten([
        get_chord_list(scale_size, n, reverse)
        for n in range(start, end)
    ])


# given a sequence of chords, builds a list of tuples
# where each tuple has the form (note_index, num_beats)
def collect_common_tones(seq):
    s = []
    
    current = None
    count = 0
    for n in seq:
        if n != current:
            if count > 0:
                s.append((current, count))
            count = 1
            current = n
        else:
            count += 1
    s.append((current, count))

    return s


# transform nested arrays into flat list arrays
def _flatten(list_of_lists):
    return list(chain(*list_of_lists))



