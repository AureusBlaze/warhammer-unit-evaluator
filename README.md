# ⚔️ Warhammer 40k Tacticus: Unit Evaluator & Battle Simulator

A cross-platform battle simulation and algorithmic decision-support tool for Warhammer 40,000 tabletop units (inspired by Warhammer 40k: Tacticus mechanics). The project benchmarks two software architectures: a **distributed Client-Server system** and a zero-latency **On-Device Edge Computing application**.

---

## 📌 Architecture Overview

```
                                  ┌───────────────────────────────┐
                                  │   Flutter Client App          │
                                  │   (flutter_client)            │
                                  └──────────────┬────────────────┘
                                                 │ HTTP / JSON
                                                 ▼
┌─────────────────────────────┐   ┌───────────────────────────────┐
│   On-Device Edge App        │   │   Python Flask Backend        │
│   (flutter_edge_app)        │   │   (backend/app.py)            │
│   [Runs offline on device]  │   │   [Pandas Analytics & API]    │
└─────────────────────────────┘   └───────────────────────────────┘
```

### 1. Distributed Client-Server Model
- **Backend (`backend/`)**: Python Flask REST microservice that parses unit datasets using `pandas` and serves dynamic endpoints (`/get_units`, `/simulate_battle`).
- **Frontend (`flutter_client/`)**: Modern dark-themed Flutter mobile/desktop application with dynamic dropdowns and asynchronous battle outcome rendering over HTTP.

### 2. Standalone On-Device Model (`flutter_edge_app/`)
- Demonstrates **Edge Computing** by packaging the entire unit dataset and decision-scoring algorithm directly into client-side Dart.
- Operates completely offline with instantaneous simulation feedback and zero backend infrastructure requirements.

---

## 🧠 Efficiency Scoring Algorithm

The simulator computes unit efficiency based on raw offensive damage output normalized by resource deployment cost:

$$\text{Efficiency Score} = \frac{\text{Attacks} \times \text{Strength} \times \text{Damage}}{\text{Points}}$$

When comparing two opposing units ($A$ and $B$):
1. **Winner Determination**:
   $$\text{Winner} = \begin{cases} \text{Unit } A & \text{if } \text{Score}_A > \text{Score}_B \\ \text{Unit } B & \text{otherwise} \end{cases}$$
2. **Cost-Advantage Multiplier**:
   $$\text{Multiplier} = \frac{\max(\text{Score}_A, \text{Score}_B)}{\min(\text{Score}_A, \text{Score}_B)}$$

The engine returns the victorious unit alongside a natural-language tactical breakdown explaining why that unit yields superior resource value.

---

## 📁 Repository Structure

```
warhammer-unit-evaluator/
├── .gitignore               # Covers Python caches, Flutter build outputs & IDEs
├── README.md                # System documentation & setup guide
├── backend/                 # Python Flask REST API
│   ├── app.py               # Flask endpoints (/get_units, /simulate_battle)
│   ├── warhammer_stats.csv  # Unit statistics dataset
│   └── requirements.txt     # Python dependencies
├── flutter_client/          # Networked Flutter application
│   ├── lib/main.dart        # HTTP client & dynamic UI
│   └── pubspec.yaml
└── flutter_edge_app/        # Offline on-device Flutter application
    ├── lib/main.dart        # Standalone Edge computing implementation
    └── pubspec.yaml
```

---

## 🚀 Quick Start

### Option A: Running the Client-Server Architecture

#### 1. Start the Flask Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```
*The server will start at `http://0.0.0.0:5000`.*

#### 2. Launch the Flutter Client
```bash
cd ../flutter_client
flutter pub get
flutter run
```
*(Note: If testing on a physical mobile device or emulator, update `baseUrl` in `flutter_client/lib/main.dart` to your local IP address).*

---

### Option B: Running the On-Device App (No Server Needed)

```bash
cd flutter_edge_app
flutter pub get
flutter run
```

---

## 🛠️ Tech Stack
- **Flutter & Dart** (Cross-platform UI & local edge evaluation)
- **Python 3.x**
- **Flask** (RESTful API microservice)
- **Pandas** (Data loading & column transformation)
