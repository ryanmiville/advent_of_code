export function parse(input: string): number[][] {
  return input.split("\n\n").map((str) => str.split("\n").map((s) => +s));
}

export const chunk = <T>(arr: T[], size: number): T[][] =>
  [...Array(Math.ceil(arr.length / size))].map((_, i) =>
    arr.slice(size * i, size + size * i)
  );
