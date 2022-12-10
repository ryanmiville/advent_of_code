interface Section {
  min: number;
  max: number;
}

interface Pair {
  a: Section;
  b: Section;
}

const solve = (pairs: Pair[]) =>
  pairs.reduce((acc, curr) => acc + count(curr), 0);

const count = (pair: Pair) => contain(pair) ? 1 : 0;

const contain = (pair: Pair) =>
  contains(pair.a, pair.b) || contains(pair.b, pair.a);

const contains = (a: Section, b: Section) => a.min <= b.min && a.max >= b.min;

//2-4,6-8
function parseLine(line: string): Pair {
  const [s1, s2] = line.split(",", 2);
  return { a: parseSection(s1), b: parseSection(s2) };
}

//2-4
function parseSection(str: string): Section {
  const [min, max] = str.split("-", 2);
  return { min: +min, max: +max };
}

const input = await Deno.readTextFile("input/day4.txt");
const pairs = input.split("\n").map(parseLine);
const answer = solve(pairs);

console.log(answer);
