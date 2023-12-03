import pyparsing as pp


def custom_scan_string(self, line):
    return sum(t[0] for t in self.scan_string(line, overlap=True))


pp.ParserElement.custom_scan_string = custom_scan_string

with open("inputs/day1.txt", "r") as f:
    lines = f.read().splitlines()


def part_1_parser():
    return pp.Char(pp.nums)


def part_2_parser():
    words = [
        "zero",
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
    ]
    numbers = [str(i) for i in range(10)]

    d = dict(zip(words, numbers))

    word_parser = pp.one_of(words).add_parse_action(lambda toks: d[toks[0]])

    digit_parser = pp.Char(pp.nums)

    return word_parser | digit_parser


def get_num(res: list[str]):
    return int(res[0] + res[-1])


def solve(parser):
    return sum(get_num(parser.custom_scan_string(l)) for l in lines)


print("Part 1:", solve(part_1_parser()))
print("Part 2:", solve(part_2_parser()))
