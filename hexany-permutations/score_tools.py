from itertools import chain
try:
    from itertools import imap
except ImportError:
    # Python 3...
    imap=map

class Score(object):
    def __init__(self):
        self._score = []
        
    def append(self, s):
        if isinstance(s, str):
            self._score.append(s)
        else:
            self._score.extend(s)
        
    def i(self, *args):
        args = imap(str, chain('i', list(args)))
        self.append(" ".join(args))

    def render(self):
        return "\n".join(self._score)

