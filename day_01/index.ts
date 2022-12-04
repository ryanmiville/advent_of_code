import { parse } from "../util.ts";

class Elf {
  calories: number[];

  constructor(calories: number[]) {
    this.calories = calories;
  }

  total(): number {
    return this.calories.reduce((acc, curr) => acc + curr);
  }
}

const elfs = await Deno.readTextFile("day_01/input.txt")
  .then(parse)
  .then((i) => i.map((c) => new Elf(c)));

const answer = Math.max(...elfs.map((e) => e.total()));

console.log(answer);
