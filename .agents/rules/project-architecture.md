---
trigger: always_on
---

# 🧠 Brain Code–Style Puzzle Game (Flutter)

## High-Level Design Document (MVP - Offline Only)

---

## 🎯 Objective

Build a minimalist, logic-based puzzle game inspired by Brain Code, where users solve unconventional problems using creativity, pattern recognition, and lateral thinking.

This version is strictly **offline-first**, with no backend, ads, or analytics.

---

## 🧩 Core Concept

* Users progress through a sequence of puzzles (levels)
* Each puzzle requires a unique way of thinking
* Inputs may be:

  * Text-based (command style)
  * Tap interactions
  * Device-based (optional future scope)

The focus is on delivering **"aha moments"** rather than complexity.

---

## 🏗️ System Architecture

### 1. Presentation Layer (UI)

Handles all user interaction and rendering.

**Responsibilities:**

* Display puzzle content
* Capture user input
* Show feedback (correct/incorrect)
* Navigate between levels

---

### 2. Application Layer (State Management)

Manages app state using GetX.

**Responsibilities:**

* Current level tracking
* Puzzle state handling
* Input processing
* Navigation logic

---

### 3. Domain Layer (Puzzle Engine)

Core logic of the game.

**Responsibilities:**

* Puzzle definitions
* Validation rules
* Hint system
* Level progression rules

---

### 4. Data Layer (Local Storage)

Handles persistence using Hive.

**Responsibilities:**

* Save user progress
* Store unlocked levels
* Track hint usage

---

## 📁 Project Structure

```
lib/
 ├── core/
 │    ├── engine/        # Puzzle engine logic
 │    ├── utils/
 │
 ├── data/
 │    ├── models/
 │    ├── local/         # Hive storage
 │
 ├── modules/
 │    ├── home/
 │    ├── puzzle/
 │    ├── result/
 │
 ├── controllers/        # GetX controllers
 ├── widgets/            # Reusable UI components
```

---

## 🧠 Puzzle Engine Design

### Puzzle Model

Each puzzle is defined as:

* ID
* Question/Prompt
* Expected solution logic
* Hint(s)

Example structure:

```
class Puzzle {
  final int id;
  final String question;
  final Function validator;
  final List<String> hints;
}
```

---

### Validation Strategy

Each puzzle has a custom validator function.

Examples:

* Exact match
* Case-insensitive match
* Pattern-based validation
* Multi-step validation

---

### Input System

Supports:

* Text input (primary)
* Button/tap input (secondary)

Future extensibility:

* Gestures
* Device sensors

---

## 💾 Local Storage (Hive)

### Stored Data:

* Current level
* Completed levels
* Hint usage per level

### Benefits:

* Offline support
* Fast read/write
* Lightweight

---

## 🎮 Core Features (MVP)

### 1. Level System

* Sequential level unlocking
* Auto-save progress

### 2. Puzzle Interaction

* Display puzzle prompt
* Accept user input
* Validate answer

### 3. Feedback System

* Correct answer → next level
* Incorrect → retry message

### 4. Hint System

* Optional hints per level
* Limited usage (basic)

### 5. Minimal UI

* Dark theme
* Clean typography
* Focus on content

---

## 🎨 UI/UX Guidelines

* Minimal distractions
* High contrast (dark mode)
* Smooth transitions
* Instant feedback

Tone:

* Slightly mysterious
* Encourages curiosity

---

## 🔁 User Flow

1. Launch app
2. Land on Home Screen
3. Start/Continue game
4. Open current puzzle
5. Enter solution
6. System validates input
7. If correct → next level
8. If incorrect → retry

---

## 🧪 Testing Strategy

* Unit tests for puzzle validation
* Manual testing for puzzle clarity
* Edge case testing for inputs

---

## 🚀 Future Scope (Post-MVP)

* Backend integration (Firebase)
* Cloud puzzle updates
* Leaderboards
* Analytics
* AdMob monetization

---

## ⚠️ Key Risks

### 1. Puzzle Quality

Poor puzzles will break engagement.

### 2. Difficulty Balance

Too hard → users quit
Too easy → boring

### 3. UX Friction

Confusing UI may be mistaken for puzzle difficulty

---

## 🧠 Success Criteria

* Users feel challenged but not frustrated
* High level completion rate
* Strong retention (even without backend tracking initially)

---

## 🏁 Conclusion

This project focuses on delivering a unique puzzle-solving experience using a lightweight, scalable Flutter architecture.

The MVP is intentionally simple, allowing rapid iteration and refinement of the most critical component: **puzzle design**.
