from itertools import chain, imap


class Score(object):
    def __init__(self):
        self._score = []
        
    def append(self, s):
        if isinstance(s, basestring):
            self._score.append(s)
        else:
            self._score.extend(s)
        
    def i(self, *args):
        args = imap(str, chain('i', list(args)))
        self.append(" ".join(args))

    def render(self):
        return "\n".join(self._score)

