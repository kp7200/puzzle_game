# 🧠 AI Learnings — Brain Code Puzzle Game
> Internal engineering reference for AI agents working on this project.
> Read this file before every prompt. Treat it as ground truth.

---

## 1. Project Vision

### What We Are Building
A minimalist, logic-based mobile puzzle game built in Flutter.
Users solve unconventional problems through creativity, pattern recognition, and lateral thinking.
The game progresses through sequential levels — each a self-contained puzzle with a unique solution mechanic.

### Core Philosophy
- **"Aha moments" over difficulty** — puzzles should feel clever, not punishing.
- **Logic-first, UI-second** — the puzzle engine is the product; UI is the delivery vehicle.
- **Offline-first, zero dependencies** — no backend, no ads, no analytics in MVP.
- **Minimal UI = maximum focus** — every pixel must serve the puzzle, not decorate it.

### Non-Negotiables
- No backend in MVP
- No ads or analytics in MVP
- Dark mode is the only mode
- Sequential level progression (no skipping)
- All puzzle logic lives in the engine — never in the UI

---

## 2. Architecture Rules (STRICT)

### Layer Map

```
core/engine/     → Puzzle definitions, validators, hint system
core/utils/      → Shared utilities (no business logic)
data/models/     → Pure data structures (no logic)
data/local/      → Hive storage adapters only
data/repositories/ → Storage read/write contracts
domain/entities/ → Domain models (thin, framework-agnostic)
domain/usecases/ → Single-responsibility use cases
presentation/modules/  → Screens (home, puzzle, result)
presentation/controllers/ → GetX controllers (state only)
presentation/bindings/    → Dependency injection via GetX
routes/          → Named route definitions
```

### Layer Responsibilities

| Layer | Owns | Must NOT |
|---|---|---|
| `core/engine` | Puzzle logic, validators | Touch UI, storage, state |
| `data` | Models, Hive persistence | Contain business rules |
| `domain` | Entities, use cases | Know about Flutter widgets |
| `presentation` | UI, state, navigation | Embed business or puzzle logic |
| `routes` | Route names + bindings | Contain navigation logic |

### Hard Rules
- **No god classes.** No class does more than one thing.
- **No cross-layer imports upward.** `data` never imports `presentation`.
- **Use cases are the bridge** between domain logic and controllers.
- **Repositories are interfaces.** Concrete implementations live in `data/local`.
- **The puzzle engine is pure Dart.** No Flutter imports in `core/engine`.

---

## 3. State Management Rules (GetX)

### Controller Responsibilities
- Hold observable state (`.obs`)
- Call use cases, never repositories directly
- Handle loading, error, and success states
- Drive navigation via `Get.toNamed()`

### What Must NOT Be in Controllers
- Raw Hive calls
- Puzzle validation logic
- Widget building or rendering logic
- Direct Firestore/HTTP calls (no backend in MVP anyway)

### Navigation Rules
- All routes defined as named constants in `routes/`
- Controllers navigate using `Get.toNamed()` / `Get.offNamed()`
- Screens never navigate themselves
- Bindings handle controller injection — no manual `Get.put()` in screens

### Allowed GetX Patterns
```dart
// ✅ Reactive state
RxInt currentLevel = 0.obs;

// ✅ Observe in UI
Obx(() => Text('${controller.currentLevel}'))

// ✅ GetBuilder for non-reactive
GetBuilder<PuzzleController>(builder: (c) => ...)
```

### Forbidden Patterns
```dart
// ❌ setState inside controller
// ❌ Provider, Bloc, Riverpod, MobX
// ❌ Business logic inside build()
```

---

## 4. UI/UX Rules

### Theme
- **Dark mode only.** No light mode variant exists.
- Background: `#171717` (primary canvas), `#0f0f0f` (deep surface)
- Primary text: `#fafafa`
- Brand green: `#3ecf8e` (accents, highlights)
- Interactive green: `#00c573` (links, CTAs)
- Borders: `#2e2e2e` (standard), `#363636` (hover)

### Typography
- Primary font: Circular (fallback: Helvetica, Arial)
- Monospace: Source Code Pro (for puzzle prompts/command-style input)
- No bold (700 weight) — use size for hierarchy
- Hero text: 72px, line-height 1.00
- Body: 16px, line-height 1.50

### Design Principles
- **No visual clutter.** Each screen has one purpose.
- **Minimalist components.** Cards: `#171717` bg, `1px solid #2e2e2e`, `8–16px` radius.
- **Feedback is instant.** No spinner for in-game validation.
- **Micro-animations are allowed** (subtle transitions, not flashy effects).
- **Rounded components.** Glassmorphism surfaces for modals/overlays.

### Anti-Clutter Checklist
- [ ] Is every element serving a purpose?
- [ ] Can the user read the puzzle without distraction?
- [ ] Is the feedback obvious without being loud?

---

## 5. Puzzle Engine Principles

### Puzzle = Data + Validator

```dart
class Puzzle {
  final int id;
  final String question;
  final Function validator;   // Custom per-puzzle
  final List<String> hints;
}
```

### Validator Design
- Every puzzle has its own isolated validator function.
- Validators are pure functions: `(String input) → bool`
- No side effects inside validators.
- Types of validators:
  - Exact match
  - Case-insensitive match
  - Pattern/regex match
  - Multi-step / stateful validation

### Rules for Puzzle Logic
- Puzzle definitions live in `core/engine/` — **never in screens or controllers**.
- Validators are injected, not inlined — supports future dynamic puzzle loading.
- Hints are stored with the puzzle — controllers reference them, never define them.
- Level progression is engine-driven, not UI-driven.

### Input System
- Primary: Text input (command-style, monospace font)
- Secondary: Button/tap inputs (layout dictated by puzzle data)
- Future: Gestures, device sensors (don't couple engine to these yet)

---

## 6. Code Quality Standards

### Class Design
- One class = one responsibility.
- Keep files under 200 lines. If longer, split.
- Prefer composition over inheritance.
- No static utility dump classes — group utilities by domain.

### Widget Design
- All reusable widgets go in `widgets/` (shared) or module-level `widgets/`.
- Widgets receive data via constructor — no direct controller access from leaf widgets.
- Screens are thin: they compose widgets, observe state, nothing more.

### Naming Conventions
- Controllers: `PuzzleController`, `HomeController`
- Screens: `PuzzleScreen`, `HomeScreen`, `ResultScreen`
- Use cases: `GetCurrentLevelUseCase`, `ValidatePuzzleUseCase`
- Models: `PuzzleModel`, `ProgressModel`
- Repositories: `ProgressRepository` (interface), `HiveProgressRepository` (impl)

### File Safety Rules (from project rules)
- Do NOT modify existing files without explaining the reason first.
- Do NOT rename files, classes, variables, or routes.
- Do NOT reformat entire files.
- Do NOT restructure directories.
- Do NOT add new dependencies without explicit approval.

---

## 7. Anti-Patterns to Avoid ⚠️

### Business Logic in UI
```dart
// ❌ WRONG — logic in build()
if (input.toLowerCase() == 'answer') {
  Get.toNamed(Routes.result);
}

// ✅ CORRECT — controller handles it
controller.submitAnswer(input);
```

### Puzzle Logic in Screens
```dart
// ❌ WRONG — hardcoded validator in screen
final isCorrect = input == 'brain';

// ✅ CORRECT — delegate to engine
final isCorrect = puzzleEngine.validate(puzzleId, input);
```

### God Controllers
```dart
// ❌ WRONG — controller doing everything
class GameController {
  void loadFromHive() { ... }
  bool validatePuzzle() { ... }
  void renderHint() { ... }
  void navigateToResult() { ... }
}

// ✅ Split: use cases handle logic, controller only delegates
```

### Hardcoded Puzzle Data in Screens
```dart
// ❌ WRONG
Text('What has keys but no locks?')

// ✅ CORRECT — driven by engine
Text(controller.currentPuzzle.question)
```

### Mixed Layer Imports
```dart
// ❌ WRONG — domain importing Flutter
import 'package:flutter/widgets.dart'; // in domain/entities/

// ✅ Pure Dart in domain and core
```

### Skipping Layers
```dart
// ❌ WRONG — controller reads Hive directly
final box = Hive.box('progress');

// ✅ CORRECT — goes through repository
final progress = await progressRepository.getProgress();
```

---

## 8. Iteration Strategy

### Build Order (ALWAYS follow this)
1. **Foundation first** — define models, entities, folder structure
2. **Engine second** — puzzle definitions, validators, hint system
3. **Repository layer** — Hive storage, progress persistence
4. **Use cases** — `GetCurrentLevel`, `ValidatePuzzle`, `SaveProgress`
5. **Controllers** — wire use cases to observable state
6. **Screens** — consume controller state, render puzzle
7. **Polish** — animations, transitions, feedback UX

### Never
- Jump directly to UI before the engine is defined
- Write puzzle logic while building the screen
- Skip the repository interface and call Hive directly
- Add features before the current layer is stable

### Validation Gates
Before scaling to new features:
- [ ] Is the puzzle engine testable in isolation?
- [ ] Are controllers decoupled from data sources?
- [ ] Are screens purely presentational?
- [ ] Does the folder structure match the defined architecture?

---

## 9. Folder Structure Reference (Locked)

```
lib/
 ├── core/
 │    ├── engine/        ← Puzzle logic, validators, hint system
 │    ├── utils/         ← Shared helpers
 │
 ├── data/
 │    ├── models/        ← PuzzleModel, ProgressModel
 │    ├── local/         ← Hive adapters
 │    ├── repositories/  ← Interface + Hive impl
 │
 ├── domain/
 │    ├── entities/      ← Domain-level Puzzle, Progress
 │    ├── usecases/      ← GetCurrentLevel, ValidatePuzzle, etc.
 │
 ├── presentation/
 │    ├── modules/
 │    │    ├── home/     ← HomeScreen, HomeController
 │    │    ├── puzzle/   ← PuzzleScreen, PuzzleController
 │    │    ├── result/   ← ResultScreen, ResultController
 │    ├── controllers/   ← Shared controllers (if any)
 │    ├── bindings/      ← GetX dependency injection
 │
 ├── routes/             ← Route names + app pages list
 ├── widgets/            ← Shared reusable widgets
```

> This structure must NOT change without explicit user approval.

---

## 10. Pre-Prompt Checklist (Run Before Every Task)

Before generating any code, confirm:

- [ ] Does this change respect layer boundaries?
- [ ] Is business logic staying out of the UI?
- [ ] Is puzzle logic staying in `core/engine/`?
- [ ] Am I using GetX correctly (controllers → use cases → repos)?
- [ ] Am I following the dark design system?
- [ ] Have I explained what I'm changing before changing it?
- [ ] Am I modifying the minimum number of files needed?
- [ ] Does this match the established folder structure?

---

*Last updated: 2026-04-14 | Version: 1.0.0*
*Maintained by: AI Agent — Brain Code Project*
