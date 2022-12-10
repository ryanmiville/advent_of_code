enum Result {
  Draw = 3,
  Win = 6,
}

enum Choice {
  Rock = 1,
  Paper,
  Scissors,
}

enum Instruction {
  ShouldLose = "X",
  ShouldDraw = "Y",
}

interface Play {
  self: Choice;
  win: Choice;
  lose: Choice;
}

const plays = new Map<string, Play>([
  ["A", { self: Choice.Rock, win: Choice.Scissors, lose: Choice.Paper }],
  ["B", { self: Choice.Paper, win: Choice.Rock, lose: Choice.Scissors }],
  ["C", { self: Choice.Scissors, win: Choice.Paper, lose: Choice.Rock }],
]);

function solve(line: string): number {
  const [play, instruction] = line.split(" ");
  const opponent = plays.get(play)!;
  switch (instruction) {
    case Instruction.ShouldLose:
      return opponent.win;
    case Instruction.ShouldDraw:
      return opponent.self + Result.Draw;
    default:
      return opponent.lose + Result.Win;
  }
}

const input = await Deno.readTextFile("day_02/input.txt");
const lines = input.split("\n");
const answer = lines.reduce((acc, line) => acc + solve(line), 0);
console.log(answer);
