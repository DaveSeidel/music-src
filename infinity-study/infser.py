"""
https://web.archive.org/web/20071010092334/http://www.pernoergaard.dk/eng/strukturer/uendelig/ukonstruktion05.html

pn[0] = 0
pn[1] = 1

pn[2*i] = pn[2*i -2] - (pn[i] - pn[i-1])
pn[2*i +1] = pn[2*i -1] + (pn[i] - pn[i-1])
"""

def norgard(seed1, seed2, elements=256):
    print(f"; seed1={seed1}, seed2={seed2}, elements={elements}")

    a = [None] * elements
    a[0] = seed1
    a[1] = seed2

    for i in range(1, elements//2):
        a[2*i] = a[2*i -2] - (a[i] - a[i-1])
        a[2*i + 1] = a[2*i - 1] + (a[i] - a[i-1])

    return a


def main():
    # a = norgard(0, 1.61803399 - 1)
    a1 = norgard(0, (7/4) - 1)
    # a = norgard(0, (13/8) - 1)
    a2 = norgard(0, (11/8) - 1)
    # a = norgard(0, (3/2) - 1)
    # a = norgard(0, (4/3) - 1)
    # a = norgard(0, (5/4) - 1)
    a3 = norgard(0, (9/8) - 1)
    # a = norgard(0, (17/16) - 1)
    # a = norgard(0, (81/80) - 1)

    for a in [a1, a2, a3]:
        for i, x in enumerate(a):
            print(f'i "Tone"   {"0  " if i == 0 else "^+3"} $DUR $LVL 0.5 $BASE {x:.12f}')


if __name__ == "__main__":
    main()
