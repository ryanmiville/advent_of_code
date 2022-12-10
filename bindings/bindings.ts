// Auto-generated with deno_bindgen
import { CachePolicy, prepare } from "https://deno.land/x/plug@0.5.2/plug.ts"

function encode(v: string | Uint8Array): Uint8Array {
  if (typeof v !== "string") return v
  return new TextEncoder().encode(v)
}

function decode(v: Uint8Array): string {
  return new TextDecoder().decode(v)
}

function readPointer(v: any): Uint8Array {
  const ptr = new Deno.UnsafePointerView(v as bigint)
  const lengthBe = new Uint8Array(4)
  const view = new DataView(lengthBe.buffer)
  ptr.copyInto(lengthBe, 0)
  const buf = new Uint8Array(view.getUint32(0))
  ptr.copyInto(buf, 4)
  return buf
}

const url = new URL("../target/debug", import.meta.url)
let uri = url.toString()
if (!uri.endsWith("/")) uri += "/"

let darwin: string | { aarch64: string; x86_64: string } = uri
  + "libparser.dylib"

if (url.protocol !== "file:") {
  // Assume that remote assets follow naming scheme
  // for each macOS artifact.
  darwin = {
    aarch64: uri + "libparser_arm64.dylib",
    x86_64: uri + "libparser.dylib",
  }
}

const opts = {
  name: "parser",
  urls: {
    darwin,
    windows: uri + "parser.dll",
    linux: uri + "libparser.so",
  },
  policy: CachePolicy.NONE,
}
const _lib = await prepare(opts, {
  part1: {
    parameters: ["pointer", "usize"],
    result: "pointer",
    nonblocking: false,
  },
})
export type Input = {
  input: string
}
export type Move = {
  count: number
  from: number
  to: number
}
export type Output = {
  stacks: Array<Array<string>>
  moves: Array<Move>
}
export function part1(a0: Input) {
  const a0_buf = encode(JSON.stringify(a0))
  const a0_ptr = Deno.UnsafePointer.of(a0_buf)
  let rawResult = _lib.symbols.part1(a0_ptr, a0_buf.byteLength)
  const result = readPointer(rawResult)
  return JSON.parse(decode(result)) as Output
}
