import { Output, part1 } from "../bindings/bindings.ts";

const input = await Deno.readTextFile("day_05/input.txt");
const parsed: Output = part1({ input });

function solvePart1(state: Output): string {
  for (const move of state.moves) {
    const count = move.count;
    const from = move.from - 1;
    const to = move.to - 1;
    const popped = state.stacks[from].splice(0, count).reverse();
    state.stacks[to].unshift(...popped);
  }

  console.log(state);
  return state.stacks.map((stack) => stack.shift()).join("");
}
console.log(solvePart1(parsed));