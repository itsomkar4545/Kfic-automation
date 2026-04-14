# KFIC Automation Framework — Technical Documentation

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

### 1.1 Purpose

A Test Automation Framework for the **KFIC Loan Origination System (LOS)**. Automates browser-based operations — login, form filling, approvals, and closures — that were previously performed manually.

### 1.2 Objectives

- Eliminate repetitive manual testing.
- Reduce human errors.
- Enable fast, accurate, and repeatable test execution.

### 1.3 Technology Stack

| # | Technology | Purpose |
|---|---|---|
| 1 | Robot Framework 6.1 | Keyword-driven test automation |
| 2 | SeleniumLibrary | Browser automation |
| 3 | Python 3.13 | Helper scripts and data processing |
| 4 | openpyxl | Excel file operations |
| 5 | Chrome | Primary test browser |
| 6 | Jenkins | CI/CD pipeline and email reports |
| 7 | Git / GitHub | Version control |

### 1.4 Application Under Test

- **URL:** `http://172.21.0.93:6661/finairoLending-1.0.1/LoginPage?tid=139&lang=en`
- **Environment:** QC | **Browser:** Chrome at 75% zoom

### 1.5 Workflow

| Step | Action |
|---|---|
| 1 | Read test data from Excel |
| 2 | Open browser and login |
| 3 | Navigate to Service Request |
| 4 | Search customer by CIF |
| 5 | Select account |
| 6 | Fill SR-specific form |
| 7 | Send for Verification to Manager |
| 8 | Manager approves |
| 9 | Maker closes |

### 1.6 User Roles

| Role | Responsibility | Example |
|---|---|---|
| Maker | Creates requests, fills forms | User ID: 20 |
| Manager | Reviews and approves/rejects | USER2, n.wisa, h.aldosari, a.ali |

---

## 2. Setup & Installation

| Step | Action |
|---|---|
| Install Python | Download from [python.org](https://www.python.org/downloads/) — check "Add to PATH" |
| Clone repository | `git clone https://github.com/itsomkar4545/Kfic-automation.git` |
| Install dependencies | `pip install -r requirements.txt` |
| Verify | `robot --version` |
| First test run | `robot tests/service_request/change_address.robot` |

### Troubleshooting

| Issue | Resolution |
|---|---|
| `python not found` | Add Python to system PATH |
| `robot not found` | `pip install robotframework` |
| `ChromeDriver error` | Update Chrome browser |
| `openpyxl not found` | `pip install openpyxl` |

---

## 3. Project Structure

| Folder | Purpose |
|---|---|
| `config/` | Environment URLs, browser settings |
| `data/` | Excel input files (25 — one per SR) |
| `pages/` | Page locators and shared keywords |
| `tests/service_request/` | 25 service request test files |
| `utils/` | Python helper scripts |
| `results/` | Auto-generated reports and logs |
| `docs/` | Documentation |

### Key Files

| File | Role |
|---|---|
| `common_keywords.robot` | Shared keywords used by all 24 SR tests |
| `service_request_page.robot` | All SR page element locators |
| `environment.robot` | Application URL and configuration |
| `excel_reader.py` | Reads Excel and returns dictionary |
| `address_reader.py` | Reads Change Address Excel (3 sections) |

---

## 4. Common Keywords

> File: `pages/common_keywords.robot` — used by all 24 service request tests.

| # | Keyword | Purpose |
|---|---|---|
| 1 | Open Browser And Setup | Opens Chrome, maximizes, sets zoom and wait |
| 2 | Login To Application | Handles re-login, enters credentials, logs in |
| 3 | Navigate To Service Request Menu | Navigates through menu to specific SR |
| 4 | Search And Select Customer | Inputs CIF, validates, searches, selects result |
| 5 | Select First Account | Selects first account, validates, proceeds |
| 6 | **Maker Creates Service Request** ★ | Master keyword — executes steps 1-5 in one call |
| 7 | Logout From Application | Ends session |
| 8 | Navigate To Service Request Inbox | Opens SR Inbox |
| 9 | Open Application By CIF | Finds application in inbox by CIF number |
| 10 | Approve Application | Manager approval action |
| 11 | Close Application | Maker closure action |
| 12 | Send For Verification | Sends to Manager for review |
| 13 | Fill Move To Next Form | Assigns Manager and adds remarks |

---

## 5. Service Request Page — Locators

> File: `pages/service_request_page.robot`

### 5.1 What Are Locators?

Locators are addresses used to identify web elements (buttons, fields, links) on a page.

| Strategy | Syntax | Best For |
|---|---|---|
| ID | `id=loginId` | Elements with unique IDs |
| Name | `name=cifNo` | Elements with name attribute |
| XPath | `xpath=//button[@id='save']` | Complex element paths |
| CSS | `css=#loginBtn` | CSS selector patterns |

### 5.2 Action Buttons

| Button | Used By | Purpose |
|---|---|---|
| Send for Verification | Maker | Forwards to Manager |
| Approve | Manager | Approves application |
| Reject | Manager | Rejects application |
| Return | Manager | Returns to Maker |
| Close | Maker | Final closure |

---

## 6. Change Address — Full Implementation

> The only fully implemented SR. Serves as the reference for all others.

### 6.1 Execution Flow

| Phase | Actor | Steps |
|---|---|---|
| 1 | Maker | Login → Navigate → Search → Account → Fill Form → Save → Send → Logout |
| 2 | Manager | Login → Inbox → Find by CIF → Approve → Logout |
| 3 | Maker | Login → Inbox → Find by CIF → Close → End |

### 6.2 Address Types

| Type | Excel Row | Supported Actions |
|---|---|---|
| Residential | Row 3 | Create / Edit / Skip |
| Permanent | Row 7 | Create / Edit / Skip |
| Business | Row 11 | Create / Edit / Skip |

### 6.3 Form Fields

| # | Field | Input Type | Validated |
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

### 6.4 Technical Concepts

| Concept | Description |
|---|---|
| **iframe** | Form is inside an iframe — requires frame switching |
| **Select2** | Custom dropdown — click visible span, then set hidden select value |
| **Mapping Dictionary** | Converts Excel text to application codes (e.g., "Main Applicant" → "101") |
| **Random Upload** | Picks a random file from a folder for document upload |

---

## 7. All 25 Service Requests — Status

| # | Service Request | Status |
|---|---|---|
| 1 | Employment Request | ⏳ Common flow |
| 2 | Personal Details | ⏳ Common flow |
| 3 | Refund Maker | ⏳ Common flow |
| 4 | Valuation SR | ⏳ Common flow |
| 5 | Add Collateral SR | ⏳ Common flow |
| 6 | **Change Address** | ✅ **Fully Implemented** |
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

> **Common flow** = Login → Menu → Search → Account Select → SR page opens.

---

## 8. Excel Input Files & Python Readers

### 8.1 Excel Structure

| Type | Format | Used By |
|---|---|---|
| Standard (24 files) | Header row + value row (Customer ID) | All SRs |
| Change Address | 3 sections — Residential, Permanent, Business with 12 columns each | Change Address |

### 8.2 Python Readers

| File | Function | Output |
|---|---|---|
| `excel_reader.py` | Reads any SR Excel | Key-value dictionary |
| `address_reader.py` | Reads 3 address sections + date conversion | Nested dictionary |

---

## 9. Validation Logic

### 9.1 Methods

| Type | How It Works | Applied To |
|---|---|---|
| Text Field | Reads field `value` attribute, compares with expected | Block, Street, Building, Unit No, Floor |
| Select2 Dropdown | Reads container text, case-insensitive compare | Customer Type, Country, Area, etc. |
| Customer ID | Input value verification | Pre-search validation |
| Radio Button | JavaScript `checked` property | Account selection |

### 9.2 Behavior

- **Mismatch →** Test FAILS: `VALIDATION FAILED: Field 'block' expected '1' but got ''`
- **Match →** Logged: `✓ VALIDATED: block = 1`

---

## 10. Test Execution

| Purpose | Command |
|---|---|
| Single test | `robot tests/service_request/change_address.robot` |
| All SR tests | `robot tests/service_request/` |
| By tag | `robot --include change_address tests/` |
| Parallel (4x) | `pabot --processes 4 tests/service_request/` |
| Debug | `robot --loglevel DEBUG tests/...` |

### Output

| File | Content |
|---|---|
| `report.html` | Summary — pass/fail counts, graphs |
| `log.html` | Detailed — step-by-step with screenshots |
| `output.xml` | Machine-readable — for CI/CD integration |

---

## 11. CI/CD — Jenkins & Email

### Pipeline

| Stage | Action |
|---|---|
| Checkout | Download code from Git |
| Setup | Install dependencies |
| Run Tests | Parallel execution |
| Report | Email results to omkar.patil@kiya.ai |

### Email Notifications

| Result | Content |
|---|---|
| Success | ✅ Pass count, rate, duration |
| Failure | ❌ Fail details, investigation links |
| Always | Attachments: report.html, log.html, output.xml |

---

## 12. Coding Concepts

### 12.1 Robot Framework

A keyword-driven test automation framework. Tests are written in near-English syntax, built on Python.

### 12.2 File Structure

Every `.robot` file has up to 4 sections:

| Section | Purpose |
|---|---|
| `*** Settings ***` | Import libraries and resources |
| `*** Variables ***` | Define constants and data |
| `*** Test Cases ***` | Executable test definitions |
| `*** Keywords ***` | Reusable custom functions |

### 12.3 Variable Types

| Type | Syntax | Scope |
|---|---|---|
| Scalar | `${NAME}` | Single value |
| List | `@{NAME}` | Ordered collection |
| Dictionary | `&{NAME}` | Key-value pairs |
| Global | `Set Global Variable` | All keywords and tests |
| Test | `Set Test Variable` | Current test only |

### 12.4 Keyword Types

| Type | Description |
|---|---|
| Simple | No arguments — directly callable |
| Parameterized | Accepts inputs via `[Arguments]` |
| Return | Returns value via `RETURN` |

### 12.5 Key Built-in Keywords

| Keyword | Purpose |
|---|---|
| `Log` | Write to execution log |
| `Sleep` | Fixed-duration wait |
| `Should Be Equal As Strings` | Assert equality |
| `Should Be True` | Assert condition |
| `Run Keyword If` | Conditional execution |
| `Run Keyword And Return Status` | Error handling (returns True/False) |
| `FOR ... IN ... END` | Loop iteration |
| `Get From Dictionary` | Retrieve dictionary value |
| `Evaluate` | Execute Python expression |

### 12.6 Key Selenium Keywords

| Keyword | Purpose |
|---|---|
| `Open Browser` / `Close Browser` | Browser lifecycle |
| `Click Element` | Click web element |
| `Input Text` | Enter text in field |
| `Wait Until Element Is Visible` | Smart wait (preferred over Sleep) |
| `Select From List By Value` | Dropdown selection |
| `Execute JavaScript` | Direct JS execution for hidden elements |
| `Choose File` | File upload |
| `Select Frame` / `Unselect Frame` | iframe navigation |

### 12.7 Python Integration

| Step | Description |
|---|---|
| 1 | Create Python function in `utils/` |
| 2 | Import in Robot: `Library    path/to/file.py` |
| 3 | Call in Robot: function name with spaces instead of underscores |

> **Convention:** Python `read_excel_data` becomes Robot `Read Excel Data`

### 12.8 Python Libraries Used

| Library | Purpose |
|---|---|
| openpyxl | Excel operations |
| datetime | Date parsing and formatting |
| random | Random number generation |
| os | File path handling |

---

## 13. Change Log

> *Updated with each milestone.*

### ✅ Completed

| # | Milestone |
|---|---|
| 1 | Framework setup — Robot Framework, Selenium, project structure |
| 2 | Login test verified |
| 3 | Receipt management tests |
| 4 | LOS Retail Flow — Select2, Excel, alert handling |
| 5 | Change Address — fully implemented with validation |
| 6 | 25 SR XPATHs defined |
| 7 | Common keywords extracted |
| 8 | 25 SR test files created |
| 9 | 25 Excel input files created |
| 10 | Validation — CIF, Account, Change Address fields |
| 11 | Email updated to omkar.patil@kiya.ai |
| 12 | GitHub — itsomkar4545/Kfic-automation |
| 13 | Documentation — Hinglish + English versions |

### ⏳ Pending

| # | Priority | Task |
|---|---|---|
| 1 | High | Implement action processing for 24 remaining SRs |
| 2 | High | Add Manager approve + Maker close to all SRs |
| 3 | Medium | SR-specific Excel input columns |
| 4 | Medium | Field validation for each SR |
| 5 | Low | Screenshot capture at key steps |
| 6 | Low | Retry mechanism for flaky elements |

---

> **Maintained by:** Omkar Patil
> **Repository:** [https://github.com/itsomkar4545/Kfic-automation](https://github.com/itsomkar4545/Kfic-automation)
