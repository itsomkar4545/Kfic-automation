# KFIC Automation Framework — Documentation

> **Author:** Omkar Patil
> **GitHub:** [https://github.com/itsomkar4545/Kfic-automation](https://github.com/itsomkar4545/Kfic-automation)
> **Version:** 1.0
> **Last Updated:** February 2026

---

## Table of Contents

1. Project Overview
2. Setup & Installation
3. Project Structure
4. Common Keywords
5. Service Request Page — Locators
6. Change Address — Full Implementation
7. All 25 Service Requests — Status
8. Excel Input Files & Python Readers
9. Validation Logic
10. Test Execution
11. CI/CD — Jenkins & Email
12. Coding Concepts
13. Change Log

---

## 1. Project Overview

### 1.1 Kya Hai?

KFIC ke LOS (Loan Origination System) application ka **Test Automation Framework**. Jo kaam manually browser pe karte the — login, form fill, approve — woh sab automatically hota hai.

### 1.2 Kyun Banaya?

- Manual testing slow aur error-prone thi.
- Same steps baar baar repeat hote the.
- Automation se — fast, accurate, repeatable.

### 1.3 Tech Stack

| # | Technology | Purpose |
|---|---|---|
| 1 | Robot Framework | Test likhne ka tool — English jaisi language |
| 2 | SeleniumLibrary | Browser control — click, type, navigate |
| 3 | Python | Helper scripts — Excel read, data process |
| 4 | openpyxl | Excel files read/write |
| 5 | Chrome | Test browser |
| 6 | Jenkins | Auto test run + email reports |
| 7 | Git / GitHub | Code versioning |

### 1.4 Application

- **URL:** `http://172.21.0.93:6661/finairoLending-1.0.1/LoginPage?tid=139&lang=en`
- **Environment:** QC | **Browser:** Chrome | **Zoom:** 75%

### 1.5 Workflow

| Step | Action |
|---|---|
| 1 | Excel se data read |
| 2 | Browser open → Login |
| 3 | Menu → Service Request select |
| 4 | Customer search (CIF) |
| 5 | Account select |
| 6 | Form fill (SR specific) |
| 7 | Send for Verification → Manager |
| 8 | Manager Approve |
| 9 | Maker Close |

### 1.6 Roles

| Role | Kaam | Example |
|---|---|---|
| Maker | SR create + form fill | User 20 |
| Manager | Review + Approve/Reject | USER2, n.wisa, h.aldosari, a.ali |

---

## 2. Setup & Installation

| Step | Command / Action |
|---|---|
| Python install | [python.org](https://www.python.org/downloads/) — "Add to PATH" check karo |
| Clone repo | `git clone https://github.com/itsomkar4545/Kfic-automation.git` |
| Dependencies | `pip install -r requirements.txt` |
| Verify | `robot --version` |
| First run | `robot tests/service_request/change_address.robot` |

### Common Issues

| Problem | Fix |
|---|---|
| `python not found` | PATH mein add karo |
| `robot not found` | `pip install robotframework` |
| `ChromeDriver error` | Chrome update karo |
| `openpyxl not found` | `pip install openpyxl` |

---

## 3. Project Structure

| Folder | Purpose |
|---|---|
| `config/` | URLs, browser settings, environment config |
| `data/` | Excel input files (25 — ek per SR) |
| `pages/` | XPATHs, locators, shared keywords |
| `tests/service_request/` | 25 SR test files |
| `utils/` | Python helpers (Excel readers) |
| `results/` | Auto-generated reports, logs, screenshots |
| `docs/` | Documentation |

### Key Files

| File | Role |
|---|---|
| `common_keywords.robot` | Shared keywords — Login, Search, Logout, Approve, Close |
| `service_request_page.robot` | Saare SR page ke XPATHs |
| `environment.robot` | Application URL + config |
| `excel_reader.py` | Excel → Dictionary |
| `address_reader.py` | Change Address Excel (3 sections) |

---

## 4. Common Keywords

> File: `pages/common_keywords.robot` — saare 24 SR tests isko use karte hain.

| # | Keyword | Purpose |
|---|---|---|
| 1 | Open Browser And Setup | Chrome open, maximize, 75% zoom, 10s wait |
| 2 | Login To Application | Re-login check → credentials enter → login |
| 3 | Navigate To Service Request Menu | Menu → Service → SR → specific SR page |
| 4 | Search And Select Customer | CIF input → validate → search → select → proceed |
| 5 | Select First Account | First account select → validate → proceed |
| 6 | **Maker Creates Service Request** ★ | Master keyword — steps 1-5 ek line mein |
| 7 | Logout From Application | Session end |
| 8 | Navigate To Service Request Inbox | SR Inbox open |
| 9 | Open Application By CIF | CIF se application dhundho inbox mein |
| 10 | Approve Application | Manager approve button |
| 11 | Close Application | Maker close button |
| 12 | Send For Verification | Manager ko bhejo |
| 13 | Fill Move To Next Form | Manager assign + remarks |

---

## 5. Service Request Page — Locators

> File: `pages/service_request_page.robot`

### 5.1 Kya Hai XPATH?

Web page pe har element (button, field, link) ka ek address hota hai. XPATH woh address hai.

**Syntax:** `//tag[@attribute='value']`

**Example:** `//button[@id='userLogin']` → "Woh button jiska id 'userLogin' hai"

### 5.2 Locator Types

| Type | Syntax | Kab Use Karo |
|---|---|---|
| ID | `id=loginId` | Unique ID ho |
| Name | `name=cifNo` | Name attribute ho |
| XPath | `xpath=//button[@id='save']` | Complex path |
| CSS | `css=#loginBtn` | CSS selector |

### 5.3 Action Buttons

| Button | Used By | Purpose |
|---|---|---|
| Send for Verification | Maker | Manager ko bhejta hai |
| Approve | Manager | Application approve |
| Reject | Manager | Application reject |
| Return | Manager | Wapas Maker ko bheje |
| Close | Maker | Final close |

---

## 6. Change Address — Full Implementation

> Reference implementation — isko samjho toh baaki sab samajh aayega.

### 6.1 Flow

| Phase | Who | Steps |
|---|---|---|
| 1 | Maker | Login → Menu → Search → Account → Form fill → Save → Send for Verification → Logout |
| 2 | Manager | Login → Inbox → Find by CIF → Approve → Logout |
| 3 | Maker | Login → Inbox → Find by CIF → Close → Browser Close |

### 6.2 Address Types

| Type | Excel Row | Actions |
|---|---|---|
| Residential | Row 3 | Create / Edit / Skip |
| Permanent | Row 7 | Create / Edit / Skip |
| Business | Row 11 | Create / Edit / Skip |

### 6.3 Form Fields

| # | Field | Type | Validated? |
|---|---|---|---|
| 1 | Customer Type | Select2 Dropdown | ✓ |
| 2 | Address Type | Select2 Dropdown | ✓ |
| 3 | Status | Select2 Dropdown | ✓ |
| 4 | Living Since | Date Field | — |
| 5 | Country | Select2 (KUWAIT) | ✓ |
| 6 | District | Select2 By Label | ✓ |
| 7 | Area | Select2 Dropdown | ✓ |
| 8 | Block, Street, Building | Text Input | ✓ |
| 9 | Unit Type | Select2 Dropdown | ✓ |
| 10 | Unit No, Floor | Text Input | ✓ |
| 11 | Document | File Upload | — |

### 6.4 Key Concepts

| Concept | Explanation |
|---|---|
| **iframe** | Form ek iframe ke andar hai — `Select Frame` se andar jao, `Unselect Frame` se bahar |
| **Select2** | Fancy dropdown — pehle visible span click, phir hidden select mein value set |
| **Mapping Dictionary** | Excel text (e.g. "Main Applicant") → App code (e.g. "101") |
| **Random Document** | Folder se random file pick karke upload |

---

## 7. All 25 Service Requests — Status

| # | Service Request | Status |
|---|---|---|
| 1 | Employment Request | ⏳ Common flow |
| 2 | Personal Details | ⏳ Common flow |
| 3 | Refund Maker | ⏳ Common flow |
| 4 | Valuation SR | ⏳ Common flow |
| 5 | Add Collateral SR | ⏳ Common flow |
| 6 | **Change Address** | ✅ **Fully Done** |
| 7 | CINET Cancel | ⏳ Common flow |
| 8 | Debt Ack Cancel | ⏳ Common flow |
| 9 | Repayment Mode SR | ⏳ Common flow |
| 10 | Identification | ⏳ Common flow |
| 11 | Add Documents | ⏳ Common flow |
| 12 | Skip Payment | ⏳ Common flow |
| 13 | Partial Settlement | ⏳ Common flow |
| 14 | Commercial Loan Extension | ⏳ Common flow |
| 15 | Retail Loan Amendment | ⏳ Common flow |
| 16 | Add Guarantor SR | ⏳ Common flow |
| 17 | Block/Unblock Service | ⏳ Common flow |
| 18 | Full Insurance Renew | ⏳ Common flow |
| 19 | Insurance Cancel | ⏳ Common flow |
| 20 | Delete Guarantor SR | ⏳ Common flow |
| 21 | Total Loss | ⏳ Common flow |
| 22 | Charges Waiver | ⏳ Common flow |
| 23 | Deceased/Fraud SR | ⏳ Common flow |
| 24 | Legal Action SR | ⏳ Common flow |
| 25 | Cancel Deal Request | ⏳ Common flow |

> **Common flow** = Login → Menu → Search → Account Select → SR page open.
> Action part pending for 24 SRs.

---

## 8. Excel Input Files & Python Readers

### 8.1 Excel Structure

| Type | Format | Used By |
|---|---|---|
| Simple (24 files) | Row 1: Header, Row 2: Value (e.g. Customer ID = 200125) | All SRs |
| Change Address | 3 sections — Residential (Row 3), Permanent (Row 7), Business (Row 11) | Change Address only |

### 8.2 Python Readers

| File | Kya Karta Hai | Output |
|---|---|---|
| `excel_reader.py` | Excel read → dictionary return | `{'Customer ID': '200125'}` |
| `address_reader.py` | 3 address sections read + date format convert | 3 dictionaries with all fields |

---

## 9. Validation Logic

### 9.1 Validation Types

| Type | Method | Applied To |
|---|---|---|
| Text Field | Field ka `value` attribute read → expected se compare | Block, Street, Building, Unit No, Floor |
| Select2 Dropdown | Container ka displayed text read → compare (case-insensitive) | Customer Type, Country, Area, etc. |
| Customer ID | Input field value check | Search se pehle |
| Radio Button | JavaScript `checked` property | Account selection |

### 9.2 Failure Behavior

- **Mismatch →** Test FAIL with message: `VALIDATION FAILED: Field 'block' expected '1' but got ''`
- **Match →** Log: `✓ VALIDATED: block = 1`

---

## 10. Test Execution

| Purpose | Command |
|---|---|
| Single test | `robot tests/service_request/change_address.robot` |
| All SR tests | `robot tests/service_request/` |
| By tag | `robot --include change_address tests/` |
| Parallel (4x fast) | `pabot --processes 4 tests/service_request/` |
| Debug mode | `robot --loglevel DEBUG tests/...` |

### Output Files

| File | Content |
|---|---|
| `report.html` | Summary — pass/fail, graphs |
| `log.html` | Detailed — step by step + screenshots |
| `output.xml` | Machine readable — Jenkins ke liye |

---

## 11. CI/CD — Jenkins & Email

### Pipeline

| Stage | Action |
|---|---|
| Checkout | Git se code download |
| Setup | Dependencies install |
| Run Tests | Parallel execution |
| Report | Email to omkar.patil@kiya.ai |

### Email

- **Success →** ✅ Green — pass count, rate, duration
- **Failure →** ❌ Red — fail details, investigation links
- **Attachments →** report.html, log.html, output.xml

---

## 12. Coding Concepts

### 12.1 Robot Framework

English jaisi language mein test likhte hain. Python pe based hai.

**Comparison:**
| Python | Robot Framework |
|---|---|
| `driver.find_element(By.ID, "loginId").send_keys("20")` | `Input Text    id=loginId    20` |

### 12.2 Robot File — 4 Sections

| Section | Purpose |
|---|---|
| `*** Settings ***` | Imports — libraries, resources |
| `*** Variables ***` | Data store — constants, paths |
| `*** Test Cases ***` | Actual tests — yeh run hote hain |
| `*** Keywords ***` | Custom functions — reusable steps |

### 12.3 Variable Types

| Type | Syntax | Use |
|---|---|---|
| Scalar | `${NAME}` | Single value |
| List | `@{NAME}` | Multiple values |
| Dictionary | `&{NAME}` | Key-value pairs |
| Global | `Set Global Variable` | Sab jagah accessible |
| Test | `Set Test Variable` | Sirf current test |

### 12.4 Keywords = Functions

| Type | Description |
|---|---|
| Simple | No arguments — e.g. `Logout From Application` |
| With Arguments | Inputs accept karta hai — `[Arguments]    ${user}    ${pass}` |
| With Return | Value return — `RETURN    ${data}` |

### 12.5 Key Built-in Keywords

| Keyword | Purpose |
|---|---|
| `Log` | Print to log |
| `Sleep` | Hard wait (fixed time) |
| `Should Be Equal As Strings` | Compare 2 values |
| `Should Be True` | Boolean check |
| `Run Keyword If` | If condition |
| `Run Keyword And Return Status` | Try-catch (returns True/False) |
| `FOR ... IN ... END` | Loop |
| `Get From Dictionary` | Dictionary se value |
| `Evaluate` | Python expression inline |

### 12.6 Key Selenium Keywords

| Keyword | Purpose |
|---|---|
| `Open Browser` / `Close Browser` | Browser lifecycle |
| `Click Element` | Click |
| `Input Text` | Type |
| `Wait Until Element Is Visible` | Smart wait (preferred) |
| `Select From List By Value` | Dropdown select |
| `Execute JavaScript` | JS run (hidden elements, zoom, scroll) |
| `Choose File` | File upload |
| `Select Frame` / `Unselect Frame` | iframe handling |

### 12.7 Sleep vs Wait

| Type | Behavior | Use |
|---|---|---|
| `Sleep 3s` | Fixed 3 sec wait | Last resort |
| `Wait Until Element Is Visible` | Jaise hi dikhe, aage badhe | Preferred |

### 12.8 Python Integration

| Step | Action |
|---|---|
| 1 | Python file banao (`utils/excel_reader.py`) |
| 2 | Robot mein import: `Library    ../../utils/excel_reader.py` |
| 3 | Robot mein call: `Read Excel Data    ${path}` |

**Rule:** Python `read_excel_data` → Robot `Read Excel Data` (auto convert)

### 12.9 Python Libraries Used

| Library | Purpose |
|---|---|
| openpyxl | Excel read/write |
| datetime | Date parsing |
| random | Random selection |
| os | File paths |

---

## 13. Change Log

> *Har progress ke saath update hota rahega.*

### ✅ Completed

| # | Milestone |
|---|---|
| 1 | Framework setup — Robot Framework, Selenium, structure |
| 2 | Login test working |
| 3 | Receipt management tests |
| 4 | LOS Retail Flow — Select2, Excel, alerts |
| 5 | Change Address — fully implemented |
| 6 | 25 SR XPATHs defined |
| 7 | Common keywords extracted |
| 8 | 25 SR test files created |
| 9 | 25 Excel input files created |
| 10 | Validation — CIF, Account, Change Address fields |
| 11 | Email → omkar.patil@kiya.ai |
| 12 | GitHub → itsomkar4545/Kfic-automation |
| 13 | Documentation — Hinglish + English |

### ⏳ Pending

| # | Priority | Task |
|---|---|---|
| 1 | High | Action part for 24 remaining SRs |
| 2 | High | Manager approve + Maker close for all SRs |
| 3 | Medium | SR-specific Excel columns |
| 4 | Medium | Validation in each SR |
| 5 | Low | Screenshots at key steps |
| 6 | Low | Retry mechanism |

---

> **Maintained by:** Omkar Patil
> **GitHub:** [https://github.com/itsomkar4545/Kfic-automation](https://github.com/itsomkar4545/Kfic-automation)
