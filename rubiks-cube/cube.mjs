// Pure, framework-free 3x3 Rubik's cube logic model.
// No rendering here — this is the source of truth for cube state and is
// fully unit-testable in Node. The Three.js layer reads this model and
// animates between its discrete states.
//
// Coordinate system (right-handed):
//   +x = RIGHT  (red)      -x = LEFT  (orange)
//   +y = UP     (white)    -y = DOWN  (yellow)
//   +z = FRONT  (green)    -z = BACK  (blue)
//
// A cubie's position is an integer vector with each component in {-1,0,1}.
// Its orientation O is stored as the world-space images of the three local
// basis vectors (columns cx, cy, cz). At the solved state O is the identity.

export const COLORS = {
  '+x': '#b71234', // red
  '-x': '#ff5800', // orange
  '+y': '#ffffff', // white
  '-y': '#ffd500', // yellow
  '+z': '#009b48', // green
  '-z': '#0046ad', // blue
};

const AXIS_KEYS = [
  ['-x', '+x'], // axis 0 (x): index by sign -> '-x'/'+x'
  ['-y', '+y'],
  ['-z', '+z'],
];

// Color a sticker shows, given the world axis it faces in the SOLVED state.
function solvedColor(unitVec) {
  for (let a = 0; a < 3; a++) {
    if (unitVec[a] === 1) return COLORS[AXIS_KEYS[a][1]];
    if (unitVec[a] === -1) return COLORS[AXIS_KEYS[a][0]];
  }
  throw new Error('solvedColor expects a unit axis vector');
}

// Rotate an integer vector v by dir*90 degrees about the given axis
// (axis: 0=x, 1=y, 2=z; dir: +1 or -1). Right-handed.
export function rot(v, axis, dir) {
  const [x, y, z] = v;
  if (axis === 0) return dir > 0 ? [x, -z, y] : [x, z, -y];
  if (axis === 1) return dir > 0 ? [z, y, -x] : [-z, y, x];
  return dir > 0 ? [-y, x, z] : [y, -x, z];
}

export function makeCube() {
  const cubies = [];
  for (let x = -1; x <= 1; x++) {
    for (let y = -1; y <= 1; y++) {
      for (let z = -1; z <= 1; z++) {
        const p0 = [x, y, z];
        // Stickers: one per nonzero component (the outward faces).
        const stickers = [];
        for (let a = 0; a < 3; a++) {
          if (p0[a] !== 0) {
            const dir = [0, 0, 0];
            dir[a] = p0[a];
            stickers.push({ local: dir.slice(), color: solvedColor(dir) });
          }
        }
        cubies.push({
          pos: [x, y, z],
          // orientation columns (images of local basis vectors)
          cx: [1, 0, 0],
          cy: [0, 1, 0],
          cz: [0, 0, 1],
          stickers,
        });
      }
    }
  }
  return { cubies };
}

// World direction a local vector currently points (apply orientation O).
function applyO(cubie, local) {
  const [lx, ly, lz] = local;
  return [
    lx * cubie.cx[0] + ly * cubie.cy[0] + lz * cubie.cz[0],
    lx * cubie.cx[1] + ly * cubie.cy[1] + lz * cubie.cz[1],
    lx * cubie.cx[2] + ly * cubie.cy[2] + lz * cubie.cz[2],
  ];
}

// Apply a layer turn in place.
//   axis: 0/1/2, value: which layer (-1/0/1), dir: +1/-1
export function turn(cube, axis, value, dir) {
  for (const c of cube.cubies) {
    if (c.pos[axis] !== value) continue;
    c.pos = rot(c.pos, axis, dir);
    c.cx = rot(c.cx, axis, dir);
    c.cy = rot(c.cy, axis, dir);
    c.cz = rot(c.cz, axis, dir);
  }
}

const UNIT_FACES = [
  [1, 0, 0], [-1, 0, 0],
  [0, 1, 0], [0, -1, 0],
  [0, 0, 1], [0, 0, -1],
];

function vecEq(a, b) {
  return a[0] === b[0] && a[1] === b[1] && a[2] === b[2];
}

// Read the 6 face colors. Returns { faceKey: [9 colors] } keyed by face vec.
export function readFaces(cube) {
  const faces = UNIT_FACES.map(() => []);
  for (const c of cube.cubies) {
    for (const s of c.stickers) {
      const facing = applyO(c, s.local);
      const fi = UNIT_FACES.findIndex((u) => vecEq(u, facing));
      faces[fi].push(s.color);
    }
  }
  return faces;
}

export function isSolved(cube) {
  const faces = readFaces(cube);
  for (const colors of faces) {
    if (colors.length !== 9) return false;
    if (!colors.every((c) => c === colors[0])) return false;
  }
  return true;
}

// Standard move notation -> { axis, value, dir }. `prime` inverts.
// Conventions verified by tests (each move^4 = identity, move·move' = identity).
const MOVES = {
  U: { axis: 1, value: 1, dir: 1 },
  D: { axis: 1, value: -1, dir: -1 },
  R: { axis: 0, value: 1, dir: -1 },
  L: { axis: 0, value: -1, dir: 1 },
  F: { axis: 2, value: 1, dir: -1 },
  B: { axis: 2, value: -1, dir: 1 },
};

export const MOVE_NAMES = Object.keys(MOVES);

export function moveSpec(name) {
  const base = name[0].toUpperCase();
  const m = MOVES[base];
  if (!m) throw new Error('unknown move ' + name);
  const prime = name.includes("'");
  return { axis: m.axis, value: m.value, dir: prime ? -m.dir : m.dir, name };
}

export function applyMove(cube, name) {
  const m = moveSpec(name);
  turn(cube, m.axis, m.value, m.dir);
}

export function applySequence(cube, names) {
  for (const n of names) applyMove(cube, n);
}

export function invertSequence(names) {
  return names
    .slice()
    .reverse()
    .map((n) => (n.includes("'") ? n.replace("'", '') : n + "'"));
}

export function randomScramble(n = 25, rng = Math.random) {
  const moves = [];
  let lastAxis = -1;
  for (let i = 0; i < n; i++) {
    let base, axis;
    do {
      base = MOVE_NAMES[Math.floor(rng() * MOVE_NAMES.length)];
      axis = MOVES[base].axis;
    } while (axis === lastAxis); // avoid trivially redundant consecutive same-axis
    lastAxis = axis;
    const suffix = rng() < 0.5 ? '' : "'";
    moves.push(base + suffix);
  }
  return moves;
}
