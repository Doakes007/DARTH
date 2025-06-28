from flask import Blueprint, request, jsonify
from db.db_config import get_connection
from utils.jwt_helper import token_required
import sys, os

# Add backend path so we can import model and utils
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from model.load_model import model
from utils.preprocess import preprocess_input

# Create blueprint
txn_bp = Blueprint("transaction", __name__)

@txn_bp.route("/transfer", methods=["POST"])
@token_required
def transfer():
    try:
        data = request.get_json()
        from_id = data["from_id"]
        to_id = data["to_id"]
        amount = float(data["amount"])

        conn = get_connection()
        cur = conn.cursor()

        # ✅ Fetch balances
        cur.execute("SELECT balance FROM accounts WHERE user_id = %s", (from_id,))
        sender_row = cur.fetchone()

        cur.execute("SELECT balance FROM accounts WHERE user_id = %s", (to_id,))
        receiver_row = cur.fetchone()

        if not sender_row or not receiver_row:
            return jsonify({"error": "Invalid user(s)"}), 400

        sender_balance = float(sender_row[0])
        receiver_balance = float(receiver_row[0])

        # ✅ Check if sender has enough balance
        if sender_balance < amount:
            return jsonify({"error": "Insufficient balance"}), 400

        # ✅ Compute new balances
        new_sender = sender_balance - amount
        new_receiver = receiver_balance + amount

        # ✅ Add required fields for model + DB
        data["type"] = data.get("type", "TRANSFER")
        data["step"] = data.get("step", 1)
        data["oldbalanceOrg"] = sender_balance
        data["newbalanceOrig"] = new_sender
        data["oldbalanceDest"] = receiver_balance
        data["newbalanceDest"] = new_receiver

        # ✅ Predict fraud
        features = preprocess_input(data)
        prediction = model.predict([features])[0]
        confidence = max(model.predict_proba([features])[0])

        # ✅ Save transaction
        cur.execute("""
            INSERT INTO transactions (
                from_id, to_id, amount, type, step,
                oldbalanceOrg, newbalanceOrig,
                oldbalanceDest, newbalanceDest,
                is_fraud
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            from_id, to_id, amount, data["type"], data["step"],
            sender_balance, new_sender, receiver_balance, new_receiver,
            bool(prediction)
        ))

        # ✅ Update balances
        cur.execute("UPDATE accounts SET balance = %s WHERE user_id = %s", (new_sender, from_id))
        cur.execute("UPDATE accounts SET balance = %s WHERE user_id = %s", (new_receiver, to_id))

        conn.commit()
        cur.close()
        conn.close()

        return jsonify({
            "is_fraud": bool(prediction),
            "confidence": round(confidence, 3)
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


        
@txn_bp.route("/history/<int:user_id>", methods=["GET"])
def get_transaction_history(user_id):
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT id, from_id, to_id, amount, type, step,
                   oldbalanceOrg, newbalanceOrig,
                   oldbalanceDest, newbalanceDest,
                   is_fraud, timestamp
            FROM transactions
            WHERE from_id = %s
            ORDER BY timestamp DESC
        """, (user_id,))

        rows = cur.fetchall()
        cur.close()
        conn.close()

        history = []
        for row in rows:
            history.append({
                "id": row[0],
                "from_id": row[1],
                "to_id": row[2],
                "amount": float(row[3]),
                "type": row[4],
                "step": row[5],
                "oldbalanceOrg": float(row[6]),
                "newbalanceOrig": float(row[7]),
                "oldbalanceDest": float(row[8]),
                "newbalanceDest": float(row[9]),
                "is_fraud": row[10],
                "timestamp": row[11].strftime('%Y-%m-%d %H:%M:%S')
            })

        return jsonify({"transactions": history})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
        
@txn_bp.route("/fraud/<int:user_id>", methods=["GET"])
def get_fraud_transactions(user_id):
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT id, from_id, to_id, amount, type, step,
                   oldbalanceOrg, newbalanceOrig,
                   oldbalanceDest, newbalanceDest,
                   is_fraud, timestamp
            FROM transactions
            WHERE from_id = %s AND is_fraud = TRUE
            ORDER BY timestamp DESC
        """, (user_id,))

        rows = cur.fetchall()
        cur.close()
        conn.close()

        frauds = []
        for row in rows:
            frauds.append({
                "id": row[0],
                "from_id": row[1],
                "to_id": row[2],
                "amount": float(row[3]),
                "type": row[4],
                "step": row[5],
                "oldbalanceOrg": float(row[6]),
                "newbalanceOrig": float(row[7]),
                "oldbalanceDest": float(row[8]),
                "newbalanceDest": float(row[9]),
                "is_fraud": row[10],
                "timestamp": row[11].strftime('%Y-%m-%d %H:%M:%S')
            })

        return jsonify({"fraud_transactions": frauds})

    except Exception as e:
        return jsonify({"error": str(e)}), 500
        
@txn_bp.route("/admin/stats", methods=["GET"])
def get_admin_stats():
    try:
        conn = get_connection()
        cur = conn.cursor()

        # Get total transactions
        cur.execute("SELECT COUNT(*) FROM transactions")
        total_txns = cur.fetchone()[0]

        # Get total frauds
        cur.execute("SELECT COUNT(*) FROM transactions WHERE is_fraud = true")
        total_frauds = cur.fetchone()[0]

        # Get total users
        cur.execute("SELECT COUNT(*) FROM users")
        total_users = cur.fetchone()[0]

        # Get high-risk users
        cur.execute("SELECT COUNT(*) FROM users WHERE risk_level = 'high'")
        high_risk_users = cur.fetchone()[0]

        cur.close()
        conn.close()

        return jsonify({
            "total_transactions": total_txns,
            "total_frauds": total_frauds,
            "fraud_rate_percent": round((total_frauds / total_txns) * 100, 2) if total_txns > 0 else 0,
            "total_users": total_users,
            "high_risk_users": high_risk_users
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500



