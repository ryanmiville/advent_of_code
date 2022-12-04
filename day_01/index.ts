import { parse } from "../util.ts";

type Elf = number;

function make(calories: number[]): Elf {
  return calories.reduce((acc, curr) => acc + curr, 0);
}

function solve(elfs: Elf[], n: number): number {
  const topElfs: Elf[] = elfs.reduce((top, elf) => {
    const i = top.findIndex((e) => elf >= e);
    return (i == -1) ? top : [...top.slice(0, i), elf, ...top.slice(i, n - 1)];
  }, new Array(n).fill(0));

  return topElfs.reduce((acc, curr) => acc + curr, 0);
}

const input = await Deno.readTextFile("day_01/input.txt");
const elfs = parse(input).map(make);
const answer = solve(elfs, 3);

console.log(answer);
