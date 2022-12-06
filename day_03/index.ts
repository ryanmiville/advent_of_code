import { chunk } from "../util.ts";

function itemValue(str: string): number {
  const ascii = str.charCodeAt(0);
  return ascii < 97 ? ascii - 38 : ascii - 96;
}
const badge = (elfs: string[]): number => {
  const [e1, e2, e3] = elfs;
  const r1 = new Set<string>([...e1]);
  const r2 = [...e2];
  const r3 = [...e3];

  const inBoth = new Set<string>(r2.filter((i) => r1.has(i)));
  return itemValue(r3.find((i) => inBoth.has(i))!);
};

const input = await Deno.readTextFile("day_03/input.txt");
const groups = chunk(input.split("\n"), 3);
const answer = groups.reduce((acc, group) => acc + badge(group), 0);

console.log(answer);
