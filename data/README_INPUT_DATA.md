# LOS Retail Flow - Input Data Instructions

## ⚠️ IMPORTANT - READ BEFORE RUNNING TESTS

### Mandatory Step:
**You MUST update the input data file before running the test:**

📁 File Location: `data/retail_flow_input.csv`

### How to Update:
1. Open `retail_flow_input.csv` in Excel
2. Update the `Parameter_Data` column with your test values
3. Save the file
4. Run the test: `robot tests/los/LOS_Retail_Flow.robot`

### Current Fields:
- **ID_Type**: Select "Civil ID Number" or "Passport Number"
- **ID_Number**: Enter 12 digit ID (default: 345464701011)

### ❌ DO NOT run tests without updating input data!

---
Last Updated: $(date)
