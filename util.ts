export function parse(input: string): number[][] {
  return input.split("\n\n").map((str) => str.split("\n").map((s) => +s));
}
