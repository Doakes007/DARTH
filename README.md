# FraudX – AI-Powered Fraud Detection in Digital Transactions

FraudX is a full-stack digital banking simulation platform with AI-powered fraud detection for financial transactions. The system combines machine learning, backend APIs, mobile application development, and transaction monitoring to simulate fraud prevention in a banking environment.

---

## Overview

FraudX detects suspicious financial transactions using a Balanced Random Forest model trained on the PaySim dataset (~6M transactions).

Features include:

- Real-time fraud prediction
- Fraud probability scoring
- Device verification checks
- Dynamic user risk levels
- Transaction history tracking
- Fraud alerts dashboard
- Admin analytics panel
- User/Admin role separation

---

## Architecture Diagram

<img width="552" height="732" alt="image" src="https://github.com/user-attachments/assets/e8f04bac-d2e8-42e1-b4fa-9e83de9a0cf9" />


---

## Tech Stack

### Frontend
- Flutter
- Dart

### Backend
- Flask
- REST APIs

### Machine Learning
- Balanced Random Forest
- Scikit-Learn
- Pandas
- NumPy

### Database
- PostgreSQL

### Deployment & Tools
- Ubuntu VM
- Git
- GitHub

---

## ML Pipeline

### Dataset
PaySim Dataset (~6M records)

### Feature Engineering

Implemented features:

- Transaction type encoding
- Amount-to-balance ratio
- Device transaction statistics
- User behavioral averages
- Night transaction flag
- Device verification checks
- Distance-from-home estimation
- Risk transaction indicators

### Model

BalancedRandomForestClassifier

Model configuration:

- n_estimators = 300
- max_depth = 5

### Evaluation Metrics

| Metric | Value |
|----------|-------|
| Precision | 93.9% |
| Recall | 100% |

---

## API Endpoints

### Transfer Money

**POST** `/api/transaction/transfer`

Request:

```json
{
  "sender": 1,
  "receiver": 2,
  "amount": 5000,
  "device_id": "abc123"
}
```

Response:

```json
{
  "is_fraud": 0,
  "fraud_probability": 0.12
}
```

---

### Transaction History

**GET** `/api/transaction/history/<user_id>`

---

### Fraud Transactions

**GET** `/api/transaction/fraud/<user_id>`

---

### Admin Statistics

**GET** `/api/admin/stats`

---

## Screenshots

- Login Screen
- Dashboard
- Send Money
- Fraud Alert
- Transaction History
- Admin Dashboard

---

## Database Schema

### Users

- user_id
- email
- password
- risk_level

### Transactions

- sender_id
- receiver_id
- amount
- fraud_flag
- fraud_probability
- timestamp

### Devices

- device_id
- user_id

---

## How To Run

### Clone Repository

```bash
git clone <repo_url>
```

### Backend

```bash
cd backend

pip install -r requirements.txt

python app.py
```

### Frontend

```bash
flutter pub get

flutter run
```

---

## Results

- Precision: 93.9%
- Recall: 100%
- Fraud probability scoring
- Dynamic risk level updates
- Device verification workflow

---

## Future Work

- JWT authentication
- Docker deployment
- Redis caching
- CI/CD pipeline
- Explainable AI integration

---

## Contributors

- Rhiya Giridhara Bhat
- Chirag N
- Ghanashyam D
- Tarun GP