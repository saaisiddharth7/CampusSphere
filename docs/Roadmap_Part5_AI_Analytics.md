# CampusSphere – Complete Roadmap

## Part 5: AI/ML Analytics Layer & Predictive Engine

> **Document Series:** Part 5 of 8
> **Continues from:** [Part 4: Fees & White-Label](./Roadmap_Part4_Fees_WhiteLabel.md)

---

## 5.1 AI Module Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│              AI/ML SERVICE ARCHITECTURE                           │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                  Cloudflare Workers (Hono API)              │  │
│  │  Triggers AI Service via HTTP                               │  │
│  └──────────────────────┬─────────────────────────────────────┘  │
│                         │                                        │
│                         ▼                                        │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                  FastAPI (Python) – Hosted on Railway/Fly   │  │
│  │                                                            │  │
│  │  ┌──────────────┐ ┌──────────────┐ ┌────────────────────┐ │  │
│  │  │ Attendance   │ │ Dropout      │ │ Performance        │ │  │
│  │  │ Predictor    │ │ Risk Model   │ │ Trend Analyzer     │ │  │
│  │  │              │ │              │ │                    │ │  │
│  │  │ Input:       │ │ Input:       │ │ Input:             │ │  │
│  │  │ • Past att.  │ │ • Attendance │ │ • All semester     │ │  │
│  │  │ • Day/time   │ │ • Grades     │ │   results          │ │  │
│  │  │ • Weather    │ │ • Fee status │ │ • Subject-wise     │ │  │
│  │  │ • Subject    │ │ • Engagement │ │   trends           │ │  │
│  │  │              │ │ • Demographics│                    │ │  │
│  │  │ Output:      │ │              │ │ Output:            │ │  │
│  │  │ Next week    │ │ Output:      │ │ • Improving/       │ │  │
│  │  │ likelihood   │ │ Risk score   │ │   declining subjs  │ │  │
│  │  │ per subject  │ │ 0-100        │ │ • CGPA prediction  │ │  │
│  │  └──────────────┘ └──────────────┘ └────────────────────┘ │  │
│  │                                                            │  │
│  │  Model: XGBoost / Random Forest (scikit-learn)             │  │
│  │  Training: Nightly batch via Celery + Upstash Redis        │  │
│  │  Serving: Real-time via FastAPI endpoints                  │  │
│  │  Cache: Upstash Redis (predictions cached for 24hrs)       │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │  Data Pipeline                                             │  │
│  │  ──────────────                                            │  │
│  │  Supabase PostgreSQL → Pandas DataFrame → Feature Eng.     │  │
│  │  → Model Training (nightly) → Model Serialization (.pkl)   │  │
│  │  → FastAPI loads model → Serves predictions                │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 5.2 Model 1: Attendance Predictor

### Feature Engineering

```python
# ai-service/app/services/data_processor.py

def prepare_attendance_features(student_id: str, tenant_id: str) -> pd.DataFrame:
    """
    Features for attendance prediction model
    """
    features = {
        # Attendance History (rolling windows)
        'att_pct_overall': 78.5,          # Overall attendance %
        'att_pct_last_7_days': 60.0,      # Last 7 days %
        'att_pct_last_30_days': 72.0,     # Last 30 days %
        'att_pct_subject': 85.0,          # Subject-specific %
        'consecutive_absent_days': 2,     # Streak of absences
        'absent_monday_pct': 40.0,        # Day-specific patterns
        'absent_friday_pct': 35.0,
        'absent_first_period_pct': 30.0,  # Time-slot patterns

        # Academic
        'current_cgpa': 7.8,
        'subject_grade_last_sem': 8.0,
        'total_backlogs': 1,
        'assignment_submission_rate': 85.0,   # NEW: Assignment compliance

        # Temporal
        'day_of_week': 1,                 # 0=Mon, 5=Sat
        'period_number': 1,
        'is_after_holiday': 0,
        'days_to_exam': 45,
        'week_of_semester': 8,

        # Fee-related
        'has_pending_fees': 1,
        'fee_overdue_days': 15,
    }
    return pd.DataFrame([features])
```

### Model Training

```python
# ai-service/app/models/attendance_predictor.py

from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import cross_val_score
import joblib

class AttendancePredictor:
    def __init__(self):
        self.model = GradientBoostingClassifier(
            n_estimators=200,
            max_depth=5,
            learning_rate=0.1,
            min_samples_split=10,
            random_state=42
        )

    def train(self, X: pd.DataFrame, y: pd.Series):
        """Train on historical attendance data"""
        scores = cross_val_score(self.model, X, y, cv=5, scoring='accuracy')
        print(f"CV Accuracy: {scores.mean():.3f} (+/- {scores.std():.3f})")
        self.model.fit(X, y)
        joblib.dump(self.model, 'models/attendance_predictor.pkl')

    def predict(self, features: pd.DataFrame) -> dict:
        """Predict attendance probability"""
        proba = self.model.predict_proba(features)[0]
        return {
            'will_attend_probability': round(proba[1] * 100, 1),
            'risk_level': 'HIGH' if proba[1] < 0.5 else
                         'MEDIUM' if proba[1] < 0.75 else 'LOW',
            'top_risk_factors': self._get_top_factors(features),
        }

    def _get_top_factors(self, features: pd.DataFrame) -> list:
        importances = self.model.feature_importances_
        feature_names = features.columns
        top_indices = importances.argsort()[-3:][::-1]
        return [
            {'factor': feature_names[i], 'importance': round(importances[i], 3)}
            for i in top_indices
        ]
```

---

## 5.3 Model 2: Dropout Risk Scoring

```python
# ai-service/app/models/dropout_risk.py

class DropoutRiskModel:
    """
    Predicts probability that a student will drop out.
    Critical for Indian context:
    - Financial constraints (fee defaults)
    - Academic pressure (multiple backlogs)
    - Attendance falling (disengagement signal)
    - Assignment non-compliance (NEW metric)
    """

    FEATURES = [
        'cgpa', 'cgpa_trend',
        'total_backlogs', 'new_backlogs_this_sem',
        'attendance_pct', 'attendance_trend',
        'fee_payment_delays_count',
        'current_fee_overdue_days',
        'scholarship_holder',
        'assignment_submission_rate',      # NEW
        'chatroom_activity_score',         # NEW: engagement via chatrooms
        'meeting_attendance_rate',         # NEW: meeting participation
        'days_since_last_login',
        'is_first_gen_graduate',
        'distance_from_home_km',
        'hostel_or_day_scholar',
        'category',
    ]

    RISK_THRESHOLDS = {
        'LOW':      (0, 20),     # Score 0-20: Safe
        'MODERATE': (20, 50),    # Score 20-50: Monitor
        'HIGH':     (50, 75),    # Score 50-75: Intervene
        'CRITICAL': (75, 100),   # Score 75-100: Immediate action
    }
```

### Dropout Risk Dashboard (Admin View)

```
┌──────────────────────────────────────────────────────────────────┐
│              AI INSIGHTS – DROPOUT RISK MONITOR                  │
│              CampusSphere AI Analytics                            │
│                                                                  │
│  Department: Computer Science | Semester: 3rd | Batch: 2024-28  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Risk Distribution                                       │   │
│  │  ───────────────────                                     │   │
│  │  🟢 Low Risk (0-20):      156 students  ████████████ 65% │   │
│  │  🟡 Moderate (20-50):      52 students  █████        22% │   │
│  │  🟠 High Risk (50-75):     22 students  ██            9% │   │
│  │  🔴 Critical (75-100):      10 students  █             4% │   │
│  │                             ─────                        │   │
│  │                             240 total                    │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  🔴 CRITICAL RISK STUDENTS (Immediate Attention)         │   │
│  │  ─────────────────────────────────────────               │   │
│  │  Roll     Name           Risk   Key Factors              │   │
│  │  ─────    ────           ────   ──────────               │   │
│  │  21CS104  Deepika R      92%    Att: 48%, CGPA: 4.2,    │   │
│  │                                  Fees: 60 days overdue    │   │
│  │  21CS107  Ganesh K       87%    Att: 52%, 3 backlogs,   │   │
│  │                                  0 assignments submitted  │   │
│  │  21CS133  Meera S        81%    Att: 58%, Fee default,   │   │
│  │                                  No chatroom activity     │   │
│  │                                                          │   │
│  │  Recommended Actions:                                    │   │
│  │  ├── 📞 Contact parent/guardian immediately               │   │
│  │  ├── 📋 Schedule counselor meeting                        │   │
│  │  ├── 💰 Check scholarship eligibility                     │   │
│  │  └── 📊 Create personalized recovery plan                │   │
│  │                                                          │   │
│  │  [Send Alert to HOD]  [Schedule Meetings]  [Export CSV]  │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
```

---

## 5.4 Model 3: Performance Trend Analysis

```
┌──────────────────────────────────────────────────────────────────┐
│         PERFORMANCE TREND – STUDENT VIEW                         │
│         CampusSphere AI Insights                                  │
│                                                                  │
│  Student: Rahul Kumar (21CS101) | Dept: CSE                     │
│                                                                  │
│  CGPA Trend:                                                     │
│  10 ┤                                                            │
│   9 ┤            ╭──╮                                            │
│   8 ┤     ╭──────╯  ╰──╮    ← Current: 8.2                     │
│   7 ┤╭────╯             ╰──╮                                    │
│   6 ┤╯                     ╰── ← Predicted next sem: 7.8       │
│   5 ┤                                                            │
│     ┼──┬──┬──┬──┬──┬──┬──┬──                                    │
│      S1 S2 S3 S4 S5 S6 S7 S8                                    │
│                                                                  │
│  Subject-wise Strengths & Weaknesses:                            │
│  ┌───────────────────────────────────────────────────────┐       │
│  │  💪 Strengths                  ⚠️ Needs Improvement    │       │
│  │  ─────────────                ──────────────────      │       │
│  │  Data Structures: A+ (9.5)   Mathematics III: B (6.5)│       │
│  │  DBMS: A (8.5)               Physics: B+ (7.0)       │       │
│  │  OS: A+ (9.0)                                        │       │
│  └───────────────────────────────────────────────────────┘       │
│                                                                  │
│  AI Recommendations:                                             │
│  ├── 📚 Focus more on Mathematics III (declining trend)          │
│  ├── 📊 Increase attendance in Math (currently 65%)              │
│  ├── 📝 Submit remaining 2 pending Math assignments              │
│  └── 🎯 Predicted final CGPA if trends continue: 7.8            │
│         Target path to 8.5+: Need 85%+ in remaining exams       │
└──────────────────────────────────────────────────────────────────┘
```

### FastAPI Endpoints

```python
# ai-service/app/routes/predict.py

from fastapi import APIRouter, Header
router = APIRouter(prefix="/ai", tags=["AI Predictions"])

@router.get("/attendance-prediction/{student_id}")
async def predict_attendance(
    student_id: str,
    x_tenant_id: str = Header(...),
):
    """Predict next week's attendance probability per subject"""
    predictor = AttendancePredictor.load()
    features = await prepare_attendance_features(student_id, x_tenant_id)

    predictions = []
    for subject in features:
        pred = predictor.predict(subject['features'])
        predictions.append({
            'subjectCode': subject['code'],
            'subjectName': subject['name'],
            'attendProbability': pred['will_attend_probability'],
            'riskLevel': pred['risk_level'],
            'topFactors': pred['top_risk_factors'],
        })

    return {
        'studentId': student_id,
        'predictions': predictions,
        'generatedAt': datetime.now(IST).isoformat(),
    }

@router.get("/dropout-risk/{student_id}")
async def get_dropout_risk(
    student_id: str,
    x_tenant_id: str = Header(...),
):
    """Get dropout risk score for a student"""
    model = DropoutRiskModel.load()
    features = await prepare_dropout_features(student_id, x_tenant_id)
    result = model.predict(features)

    return {
        'studentId': student_id,
        'riskScore': result['score'],
        'riskLevel': result['level'],
        'factors': result['contributing_factors'],
        'recommendations': result['recommendations'],
    }

@router.get("/department-insights/{dept_id}")
async def department_insights(
    dept_id: str,
    x_tenant_id: str = Header(...),
):
    """Aggregate AI insights for a department"""
    return {
        'departmentId': dept_id,
        'totalStudents': 240,
        'riskDistribution': {
            'low': 156, 'moderate': 52, 'high': 22, 'critical': 10
        },
        'avgAttendance': 78.5,
        'attendanceTrend': 'declining',
        'avgSubmissionRate': 84.2,        # NEW
        'chatEngagementScore': 72.1,      # NEW
        'topRiskStudents': [...],
        'performanceTrends': {...},
    }
```

---

> **→ Continue to [Part 6: Complete ASCII UI Wireframes](./Roadmap_Part6_UI_Wireframes.md)**
