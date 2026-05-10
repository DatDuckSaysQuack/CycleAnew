# EXTINCTION CYCLE — Dream Prototype (Godot 4.x)

## 1) What this prototype is
A playable 3D vertical slice of a dreamlike civilization-guidance game where **extinction is invoked, never selected**. You build a small settlement, manage conflict between humans and alien-like allies, and accidentally risk magical triggers while the world becomes extinction-vulnerable.

If extinction is invoked, a moving flood-wall crisis begins. You can place barriers and attempt to suspend the disaster in limbo, preserving the world with a permanent scar.

## 2) How to open in Godot
1. Open **Godot 4.x**.
2. Import this folder (`CycleAnew`) as a project.
3. Open project and press **F5** (main scene is already configured).

## 3) Controls
- **WASD / Arrow keys:** Pan camera
- **Q / E:** Rotate camera
- **Mouse wheel:** Zoom
- **Middle or Right Mouse drag:** Drag-pan camera
- **Left click (during crisis):** Place magical barrier on terrain
- UI Buttons:
  - **Build House**
  - **Reconciliation Pulse**
  - **Base-Form Memory**
  - **Call Polly**
  - **Open Divergences** (locked until stage 8 or limbo success)
- **Utterance / Chant input + Enter:** Speak symbolic phrase into world

## 4) How to reach vulnerability
Complete these objectives:
- Build 3 houses.
- Keep population at 10+ alive.
- Keep conflict below 50.
- Perform one Reconciliation Pulse.

When done, you get: **"The world is extinction-vulnerable."** plus cryptic warnings.

## 5) How extinction is invoked (not selected)
Implemented magical triggers:
1. **Polly Trigger:** world vulnerable + Polly holds yellow playball + Polly stands on marble rock for 5s.
2. **Utterance Trigger:** world vulnerable + player types **"yeah yeah yeah"**.
3. **Twin Memory Trigger:** world vulnerable + base-form human and xeno near monolith during dusk.

Before vulnerability, uttering "yeah yeah yeah" does nothing special.

## 6) How to suspend flood into limbo
Once extinction is invoked:
- Flood wall appears and advances from map edge.
- Place magical barriers by left-clicking terrain.
- Survive 30 seconds without flood reaching settlement center.

Success state: **"The flood hangs in limbo. This world survives."**
The wall freezes in place as a permanent visible scar.

Failure state: settlement is washed away, and cycle may continue.

## 7) Placeholder / prototype systems
- Primitive-mesh characters, houses, shrine, flood, barriers.
- Lightweight villager wandering/fleeing behavior.
- Conflict and reconciliation are simplified numeric systems.
- Divergence paths are implemented as branch data + cycling placeholder.
- Audio drone is currently text/lore placeholder ("LOW DRONE").

## 8) Suggested next Codex tasks
- Improve villager personalities/names/routines.
- Add stronger terrain-shaping mechanics.
- Add more magical trigger conditions.
- Add proper civilization stage transitions.
- Expand alternate what-if paths.
- Improve flood physics/visuals.
- Add music and low drone audio.
- Add save/load.
- Add procedural history/memory system.
