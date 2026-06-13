// Node test runner: `node --test cube.test.mjs`
import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  makeCube,
  isSolved,
  readFaces,
  turn,
  applyMove,
  applySequence,
  invertSequence,
  randomScramble,
  moveSpec,
  MOVE_NAMES,
} from './cube.mjs';

test('new cube is solved', () => {
  assert.equal(isSolved(makeCube()), true);
});

test('cube has 6 faces of 9 stickers (54 total)', () => {
  const faces = readFaces(makeCube());
  assert.equal(faces.length, 6);
  let total = 0;
  for (const f of faces) {
    assert.equal(f.length, 9);
    total += f.length;
  }
  assert.equal(total, 54);
});

test('a single move makes it unsolved', () => {
  for (const m of MOVE_NAMES) {
    const c = makeCube();
    applyMove(c, m);
    assert.equal(isSolved(c), false, `${m} should unsolve`);
  }
});

test('every move applied 4x returns to solved', () => {
  for (const m of MOVE_NAMES) {
    const c = makeCube();
    for (let i = 0; i < 4; i++) applyMove(c, m);
    assert.equal(isSolved(c), true, `${m} x4`);
  }
});

test('move followed by its prime returns to solved', () => {
  for (const m of MOVE_NAMES) {
    const c = makeCube();
    applyMove(c, m);
    applyMove(c, m + "'");
    assert.equal(isSolved(c), true, `${m} then ${m}'`);
  }
});

test('scramble then inverse returns to solved (100 trials)', () => {
  for (let t = 0; t < 100; t++) {
    const c = makeCube();
    const scr = randomScramble(30);
    applySequence(c, scr);
    assert.equal(isSolved(c), false);
    applySequence(c, invertSequence(scr));
    assert.equal(isSolved(c), true, `failed for ${scr.join(' ')}`);
  }
});

test('sticker colors are conserved under turns (6 of each color)', () => {
  const c = makeCube();
  applySequence(c, randomScramble(40));
  const counts = {};
  for (const f of readFaces(c)) {
    for (const col of f) counts[col] = (counts[col] || 0) + 1;
  }
  for (const col of Object.keys(counts)) {
    assert.equal(counts[col], 9, `color ${col} count`);
  }
  assert.equal(Object.keys(counts).length, 6);
});

test('moveSpec inverts dir on prime', () => {
  assert.equal(moveSpec('R').dir, -moveSpec("R'").dir);
});

test('raw layer turn 4x is identity on a scrambled cube', () => {
  const c = makeCube();
  applySequence(c, randomScramble(20));
  const before = JSON.stringify(c);
  for (let i = 0; i < 4; i++) turn(c, 0, 1, 1);
  assert.equal(JSON.stringify(c), before);
});
