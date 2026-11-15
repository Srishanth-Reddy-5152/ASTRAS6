# ASTRAS – NASA Junior Outpost Commander
**NASA Space Apps Challenge 2026**  
*Subjects: Games, Planets & Moons, Software, Space Exploration, Sun*  
*Target Audience: Students aged 7–12 (with flex for older siblings, parents, and classrooms)*

---

## 🌟 Overview & Educational Objectives
**ASTRAS** is an interactive, browser-based space engineering simulator designed to solve a central problem in space STEM education:
> Space-themed content often either oversimplifies the engineering trade-offs that define a real mission or presents them at a level too complex for young learners.

In ASTRAS, students take command of a **Lunar South Pole (Shackleton Crater)** or **Mars Jezero Crater** outpost. Through hands-on play, students experience the core reality that NASA mission planners face every day: **no choice is free, and every decision carries a resource cost that compounds over time.**

---

## 🚀 Key Gameplay & Engineering Mechanics

### 1. The 1,000-Credit NASA Outpost Architect Budget
Before launching their expedition, students enter the **Outpost Architect Console** with a **1,000 Credit (`1000 cr`) NASA Budget**. They must choose which modules to build:
* **Pressurized Habitat Core** (200 cr | -10 kW): Mandatory closed-loop crew quarters and life support.
* **Standard Solar Array Wing** (150 cr | +25 kW): Low-cost power, but vulnerable to dust storms and the 14-day lunar night.
* **Kilopower Nuclear Fission Reactor** (350 cr | +40 kW): High-cost investment that provides continuous power through dust storms and pitch darkness.
* **Hydroponic Greenhouse Dome** (200 cr | -15 kW): Produces fresh food and replenishes oxygen by absorbing carbon dioxide.
* **Subsurface Cryo-Ice Drill Rig** (200 cr | -15 kW): Mines permafrost water ice from crater rims.
* **RFC Regenerative Fuel Cell Battery Bank** (150 cr | Stores 50 kWh): Essential power reserve for surviving night and blackouts.
* **1.5m Sintered Regolith Radiation Bunker** (250 cr | -5 kW): Thick local regolith blocks 98% of solar flare protons.
* **High-Gain Deep Space Optical Comms Dish** (100 cr | -5 kW): Telemetry link to Mission Control for expert hints and science points.

*Interactive Budgeting*: Students can click any built module to refund/unbuild it and experiment with different engineering architectures.

---

### 2. Multi-Sol Survival Simulation (The 6-Resource Interconnected Loop)
Students manage 6 core interconnected resources:
1. **Oxygen ($O_2$)**: Breathable closed-loop air pressure.
2. **Power ($\text{kW}$)**: Solar arrays, nuclear reactor, and battery reserves.
3. **Water ($H_2O$)**: Ice drill extraction and ECLSS recycling.
4. **Food**: Greenhouse crop cycles.
5. **Hull Integrity**: Micrometeoroid seals and airlock structural pressure.
6. **Radiation Safety**: Dosimetry protection against solar proton storms.

---

### 3. Pre-Commit Forecast Previews & Compounding Effects
When critical events occur, every decision displays a **Pre-Commit Forecast Preview**:
* Shows immediate resource impact (e.g., `Today: +15% Oxygen Buffer`).
* Explains tomorrow's compounding cost (e.g., `Tomorrow: -20% Greenhouse crop growth from dimmed lights`).

---

### 4. Historical NASA Precedents
Every emergency links directly to actual spaceflight history:
* **2018 Opportunity Rover Dust Storm**: How global dust blocked 99% of sunlight and ended the mission.
* **1972 Apollo Solar Flare**: How unshielded astronauts on the lunar surface would have received dangerous radiation doses.
* **Apollo 15 Lunar Drill Basalt Jam**: The real-world difficulty of drilling into compacted regolith.
* **ISS ECLSS Closed-Loop Water Recovery**: How NASA purifies 98% of all moisture in space.

---

### 5. Grounded in Real NASA Open Data
* **Space Weather Database (DONKI)**: Live/curated solar flare telemetry (C-Class, M-Class, X-Class) and coronal mass ejection alerts.
* **Open Science Data Repository (OSDR)**: Spaceflight radiation dosimetry and astronaut health limits (50 mSv/year career guidance).
* **MOLA & REMS Data**: Martian atmospheric pressure (610 Pa) and Jezero Crater elevation logs.

---

### 6. Age-Adaptive Telemetry Toggle
A single click switches telemetry between:
* **Cadet Mode (%)**: Clean, intuitive percentages (`100% O2`, `85% Power`).
* **Specialist Units**: Real scientific units (`21.3 kPa O2`, `42.5 kW`, `320 L H2O`, `180 µGy/day radiation`).

---

### 7. Learn-From-Failure & Official NASA Diploma Certificate
* If a critical loop fails, a **3-step Root-Cause Chain Reaction** explains why and how to fix it.
* A **Rewind to Last Dilemma** button lets students retry immediately without frustration.
* On mission completion (7 Sols survived), the game generates a high-resolution downloadable **Official NASA Junior Outpost Commander Certificate Diploma (PNG)** with the astronaut crew's names and final score!

---

### 8. Space Systems Academy (6 Chapters & 24 Verified NASA Questions)
Organized into clear modules with explicit headlines and curriculum goals:
* **Chapter 1: NASA Space Weather & Solar Dynamics** (DONKI API & SDO Solar flares)
* **Chapter 2: Planetary Topography & Laser Altimetry** (LOLA Moon & MOLA Mars Jezero Crater)
* **Chapter 3: Spaceflight Biology & Human Health** (OSDR & GeneLab microgravity bone density)
* **Chapter 4: Closed-Loop Energy & Nuclear Grids** (Kilopower fission & RFC regenerative batteries)
* **Chapter 5: Deep Space Telemetry & Comms Delay** (NASA Deep Space Network 70m dishes & speed-of-light lag)
* **Chapter 6: In-Situ Resource Utilization** (MOXIE oxygen extraction & Shackleton PSR ice mining)

---

### 9. NOVA AI Companion & Gemini Space Intelligence Side Board
* An interactive AI copilot powered by Gemini space science knowledge.
* Expressive animated visor (neutral, thinking, speaking, celebrating).
* Instant explanations of scientific trade-offs, voice read-aloud, and prompt chips.

---

### 10. Authentic Design Sheet Graphics & UI/UX
* **Official Logo**: High-definition ASTRA Junior Astronaut Mission Trainer emblem.
* **4 Astronaut Specialists**: Cadet Leo (Pilot), Specialist Maya (EVA Engineer), Commander Dr. Arin (Nuclear/Systems), and Dr. Tara (Botanist & Flight Surgeon) with distinct browser voice profiles.
* **4 Space Environments**: Lunar South Pole, Mars Jezero Colony, ISS Earth Orbit Cupola, and Deep Space Gateway.
* **In-Game Operations HUD**: Active astronaut portrait with Health, Battery Power, and O2 reserve gauges plus a live rotating radar scanner.
* **Cosmic Background**: Continuous HTML5 canvas starfield with 220 twinkling stars and diagonal shooting stars.

---

## 💻 How to Run

### In PowerShell:
```powershell
Start-Process "c:\Users\HP\.antigravity-ide\ASTRAS\play_offline.html"
```
Or double-click `run_astras.bat` inside the `ASTRAS` folder.
*100% self-contained, browser-playable offline, zero external dependencies.*

