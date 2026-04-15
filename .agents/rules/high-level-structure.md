---
trigger: always_on
---

lib/
 ├── core/                 # shared logic
 │    ├── engine/          # puzzle engine 🧠
 │    ├── utils/
 │
 ├── data/                 # persistence
 │    ├── models/
 │    ├── local/ (Hive)
 │    ├── repositories/
 │
 ├── domain/               # business logic
 │    ├── entities/
 │    ├── usecases/
 │
 ├── presentation/         # UI + GetX
 │    ├── modules/
 │    │    ├── home/
 │    │    ├── puzzle/
 │    │    ├── result/
 │    ├── controllers/
 │    ├── bindings/
 │
 ├── routes/