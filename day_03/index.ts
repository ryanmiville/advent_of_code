const input = await Deno.readTextFile("day_03/input.txt");

function itemValue(str: string): number {
  const ascii = str.charCodeAt(0);
  return ascii < 97 ? ascii - 38 : ascii - 96;
}

const lines = input.split("\n");
const answer = lines.reduce((acc, l) => {
  const mid = l.length / 2;
  const c1 = new Set<string>([...l.slice(0, mid)]);
  const c2 = [...l.slice(mid)];
  return acc + itemValue(c2.find((e) => c1.has(e))!);
}, 0);

console.log(answer);
