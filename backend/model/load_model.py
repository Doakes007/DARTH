class DummyModel:
    def predict(self, X):
        # Always predict no fraud for now (can return random too)
        return [0 for _ in X]

    def predict_proba(self, X):
        # Return low confidence for fraud, high for safe
        return [[0.1, 0.9] for _ in X]  # [fraud prob, safe prob]

# Use dummy model instead of loading real one
model = DummyModel()
print("⚠️ Loaded dummy model. Replace with real fraud_model.pkl when ready.")

