# 🚀 Flash Hustle – Gamified Skill Challenge Platform

## 📌 Project Overview

Flash Hustle is a **gamified, skill-based mobile application** designed to encourage continuous learning through **daily time-bound challenges**. The platform allows users to participate in quizzes, skill tasks, and prediction-based challenges to earn virtual rewards such as coins, XP, and levels. By combining learning with competition, Flash Hustle motivates users to stay consistent and improve their skills in an engaging and interactive way.

---

## 🎯 Objectives

* Promote **daily learning habits** using micro-challenges
* Provide a **real-time challenge experience** with countdown timers
* Reward users based on **performance, speed, and consistency**
* Encourage healthy competition using **leaderboards**

---

## ✨ Key Features

* Secure **User Authentication**
* Personalized **Dashboard** with streaks, XP, and coins
* **Live Challenges** with countdown timer
* Multiple challenge types:

  * Quiz Challenges
  * Trivia & Practice Challenges
  * Prediction-Based Challenges
* **Wallet & Rewards** system
* **Leaderboard** for ranking users
* Push notifications for challenge alerts
* Responsive and user-friendly UI

---

## 🧑‍💻 How the Application Works

1. Users sign up or log in through a secure authentication screen.
2. After login, users are redirected to the dashboard showing streaks, coins, XP level, and upcoming challenges.
3. Users receive notifications when a new challenge becomes active.
4. Each challenge is time-bound, requiring users to complete it within the given countdown.
5. Submissions are evaluated and rewards are calculated based on accuracy, speed, and streak multipliers.
6. Earned rewards are reflected in the wallet section with a detailed transaction history.
7. Leaderboards rank users based on their performance and consistency.

---

## 🏆 Wallet & Rewards

* Displays total coins and XP earned
* Shows current user level and progress
* Maintains transaction history for transparency
* Motivates users through reward multipliers

---

## 📊 Leaderboard

* Ranks users based on scores and activity
* Encourages competition and engagement
* Updates dynamically after each challenge

---

## 🛠️ Technologies Used

* **Frontend:** Flutter
* **Backend:** REST APIs
* **Database:** PostgreSQL / Firebase
* **Authentication:** Secure login & session handling
* **Notifications:** Push notification services

---

## 🔐 Security Considerations

* Secure authentication and session management
* Input validation and submission time checks
* Protected user data and reward transactions

---
APIs Used:
Authentication API, Challenge API, Submission & Scoring API, Wallet & Rewards API, Leaderboard API, Notification API.

Data flow diagram
┌─────────────────┐       ┌─────────────────┐
│      User       │       │    Challenge    │
├─────────────────┤       ├─────────────────┤
│ PK userId       │◄──┐   │ PK challengeId  │
│ username        │   └───┤ FK userId       │
│ avatar          │       │ type            │
│ ...             │       │ title           │
│ isOnline        │       │ ...             │
└─────────────────┘       │ multiplier      │
       │                  └─────────────────┘
       │                         │
       │                         │
       │  ┌─────────────────┐    │ 1..N
       └──┤ Achievement     │    │
      1..N├─────────────────┤    ▼
          │ PK badgeId      │┌─────────────────┐
          │ FK userId       ││   QuizQuestion  │
          │ name            │├─────────────────┤
          │ ...             ││ PK id           │
          │ isNew           ││ FK challengeId  │
          └─────────────────┘│ type            │
                  ▲           │ question        │
                  │           │ ...             │
                  │           │ points          │
       ┌─────────────────┐    └─────────────────┘
       │   Transaction   │
       ├─────────────────┤
       │ PK id           │
       │ FK userId       │
       │ type            │       ┌─────────────────┐
       │ amount (+/-)    │       │     Reward      │
       │ multipliers     │       ├─────────────────┤
       │ status          │◄─────►│ PK id           │
       └─────────────────┘ N   M │ type            │
                  ▲              │ title           │
                  │              │ minCoins        │
       ┌─────────────────┐       │ ...             │
       │LeaderboardEntry │       └─────────────────┘
       ├─────────────────┤
       │ PK rank         │
       │ FK userId       │
       │ name            │
       │ score           │
       └─────────────────┘
