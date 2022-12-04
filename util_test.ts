import { assertEquals } from "https://deno.land/std@0.167.0/testing/asserts.ts";
import { parse } from "./util.ts";

Deno.test("parse empty line delimited groups of numbers", () => {
  const input = `1000
2000
3000

4000

5000
6000

7000
8000
9000

10000`;

  const expected = [
    [1000, 2000, 3000],
    [4000],
    [5000, 6000],
    [7000, 8000, 9000],
    [10_000],
  ];

  assertEquals(parse(input), expected);
});
