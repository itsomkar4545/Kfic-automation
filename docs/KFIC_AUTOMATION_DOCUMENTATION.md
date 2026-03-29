# KFIC Automation Framework - Complete Documentation
**Author:** Omkar Patil
**GitHub:** https://github.com/itsomkar4545/Kfic-automation
**Last Updated:** _(will be updated with each change)_

---

## Section 1: Project Overview

### Kya hai yeh framework?
Yeh ek **Test Automation Framework** hai jo **KFIC (Kuwait Finance & Investment Company)** ke LOS (Loan Origination System) application ko automate karta hai. Matlab jo kaam manually browser pe karte the — login, form fill, button click, approve — woh sab yeh code automatically karta hai.

### Kisliye banaya?
- Manual testing mein bahut time lagta tha
- Har baar same steps repeat karne padte the
- Human errors hote the
- Yeh framework sab kuch automatically karta hai — fast, accurate, repeatable

### Tech Stack (Kya kya use kiya hai)

| Technology | Kya kaam karta hai |
|---|---|
| **Robot Framework** | Test automation ka main tool — English jaisi language mein test likhte hain |
| **SeleniumLibrary** | Browser control karta hai — click, type, navigate sab |
| **Python** | Helper scripts ke liye — Excel read, data process |
| **openpyxl** | Python library jo Excel files read karti hai |
| **Chrome Browser** | Tests Chrome browser mein run hote hain |
| **Jenkins** | CI/CD — automatically tests run karta hai aur email bhejta hai |
| **Git/GitHub** | Code version control aur storage |

### Application Details
- **Application:** KFIC LOS (Loan Origination System)
- **URL:** `http://172.21.0.93:6661/finairoLending-1.0.1/LoginPage?tid=139&lang=en`
- **Environment:** QC (Quality Check)
- **Browser:** Chrome
- **Zoom Level:** 75% (kyunki application elements bade hain)

### Framework ka Main Flow
```
1. Excel se data read karo (Customer ID, Address, etc.)
2. Browser open karo → Login karo
3. Menu navigate karo → Service Request select karo
4. Customer search karo (CIF number se)
5. Account select karo
6. Service Request form fill karo (action part)
7. Send for Verification → Manager ko bhejo
8. Manager login → Approve kare
9. Maker login → Close kare
```

### Roles in Application
| Role | Kya karta hai | Example User |
|---|---|---|
| **Maker** | Service request create karta hai, form fill karta hai | User ID: 20 |
| **Manager** | Maker ka kaam review karke approve/reject karta hai | USER2, n.wisa, h.aldosari, a.ali |

---

## Section 2: Setup & Installation

### Step 1: Python Install karo
1. Download karo: https://www.python.org/downloads/
2. Install karte waqt **"Add Python to PATH"** checkbox ZAROOR check karo
3. Verify karo:
```bash
python --version
# Output: Python 3.13.x (ya jo bhi version ho)
```

### Step 2: Project Download karo
```bash
git clone https://github.com/itsomkar4545/Kfic-automation.git
cd Kfic-automation
```

### Step 3: Dependencies Install karo
```bash
pip install -r requirements.txt
```
Yeh command `requirements.txt` file mein likhi saari libraries install karega:
- `robotframework` — main test framework
- `robotframework-seleniumlibrary` — browser automation
- `selenium` — web driver
- `openpyxl` — Excel file reading (yeh requirements.txt mein nahi hai but zaruri hai)
- `robotframework-pabot` — parallel test execution

### Step 4: Chrome Browser & Driver
- Chrome browser installed hona chahiye
- `webdriver-manager` automatically sahi ChromeDriver download kar leta hai
- Agar issue aaye toh manually download karo: https://chromedriver.chromium.org/

### Step 5: Verify Installation
```bash
robot --version
# Output: Robot Framework 6.1.1 (Python 3.13.x on win32)
```

### Step 6: First Test Run karo
```bash
robot tests/service_request/change_address.robot
```
Yeh command:
1. Chrome browser open karega
2. KFIC application mein login karega
3. Change Address service request process karega
4. Results `output.xml`, `log.html`, `report.html` mein save karega

### Common Issues & Fixes

| Problem | Solution |
|---|---|
| `python not found` | Python install karo, PATH mein add karo |
| `robot not found` | `pip install robotframework` run karo |
| `ChromeDriver error` | Chrome browser update karo |
| `Module not found: openpyxl` | `pip install openpyxl` run karo |
| `Connection refused` | Check karo ki application server chal raha hai |

---

## Section 3: Project Folder Structure

```
kfic-automation-framework/
├── config/                          # ⚙️ Configuration files
│   ├── environment.robot             # URLs, DB config, browser settings
│   └── framework_config.robot        # Framework level settings
├── data/                            # 📊 Test data (Excel files)
│   ├── customer_search.xlsx          # Customer ID for search
│   ├── change_address.xlsx           # Address data (Residential, Permanent, Business)
│   ├── employment_request.xlsx       # Employment request input
│   ├── ... (25 SR excel files)       # Har service request ki apni excel
│   ├── create_all_sr_excels.py       # Script jo saari excel files banata hai
│   └── create_excel.py              # Original excel creator
├── pages/                           # 📄 Page Objects (XPATHs & Locators)
│   ├── common_keywords.robot         # ⭐ SHARED keywords (Login, Search, etc.)
│   ├── service_request_page.robot    # All SR page XPATHs & locators
│   ├── login_page.robot             # Login page locators
│   ├── base_page.robot              # Common page utilities
│   └── receipt_*.robot              # Receipt related pages
├── tests/                           # 🧪 Test files
│   ├── service_request/             # ⭐ 25 Service Request test files
│   │   ├── change_address.robot      # ✅ FULLY implemented
│   │   ├── commercial_loan_extension.robot
│   │   ├── employment_request.robot
│   │   └── ... (22 more)
│   ├── los/                         # LOS flow tests
│   ├── lms/                         # LMS tests
│   └── api/                         # API tests
├── utils/                           # 🔧 Python helper scripts
│   ├── excel_reader.py              # Excel se data read karta hai
│   ├── address_reader.py            # Change address excel reader
│   └── arabic_translator.py         # Arabic text handling
├── docs/                            # 📝 Documentation
│   └── KFIC_AUTOMATION_DOCUMENTATION.md  # ⭐ YEH FILE!
├── results/                         # 📈 Test results (auto-generated)
├── scripts/                         # 🚀 Execution scripts
│   └── run_tests.bat                # Windows batch file to run tests
├── Jenkinsfile                      # CI/CD pipeline config
└── requirements.txt                 # Python dependencies list
```

### Har Folder ka Kaam (Simple Explanation)

| Folder | Kya hai | Example |
|---|---|---|
| `config/` | Settings — URL, browser, environment | `environment.robot` mein QC URL hai |
| `data/` | Input data — Excel files jismein test data hai | `change_address.xlsx` mein address data |
| `pages/` | Page ke elements — buttons, fields ke XPATHs | `service_request_page.robot` mein saare locators |
| `tests/` | Actual test files — yeh run hote hain | `change_address.robot` run karo toh test chalega |
| `utils/` | Helper scripts — Excel read, data process | `excel_reader.py` Excel se data laata hai |
| `results/` | Output — reports, logs, screenshots | `report.html` open karo results dekhne ke liye |
| `docs/` | Documentation — yeh file! | Yeh document jismein sab explain hai |

### Important Files Samjho

| File | Kya karta hai |
|---|---|
| `common_keywords.robot` | Saare shared keywords — Login, Search, Account Select, Logout, Approve, Close |
| `service_request_page.robot` | Saare XPATHs — menu items, form fields, buttons |
| `environment.robot` | Application URL, database config |
| `excel_reader.py` | Excel file read karke dictionary return karta hai |
| `address_reader.py` | Change address excel ke 3 sections (Residential, Permanent, Business) read karta hai |

---

## Section 4: Common Keywords (common_keywords.robot)

Yeh file sabse important hai — saare 24 service request tests isko use karte hain. Har keyword ka explanation:

### 4.1 Open Browser And Setup
```robot
Open Browser And Setup
    [Arguments]    ${url}=${LOS_QC_URL}
    Open Browser    ${url}    chrome          # Chrome browser open karo
    Maximize Browser Window                    # Full screen karo
    Execute JavaScript    document.body.style.zoom='75%'   # 75% zoom (app elements bade hain)
    Set Selenium Implicit Wait    10           # 10 sec wait for elements
```
**Kya karta hai:** Browser open karta hai, maximize karta hai, zoom set karta hai.

### 4.2 Login To Application
```robot
Login To Application
    [Arguments]    ${username}    ${password}
    # Pehle check karo ki "Re-login" button hai ya nahi (agar session expired ho)
    ${relogin_present}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    id=relogin    timeout=2s
    Run Keyword If    ${relogin_present}    Click Element    id=relogin
    # Ab login karo
    Wait Until Element Is Visible    id=loginId    timeout=15s
    Input Text    id=loginId    ${username}     # Username type karo
    Input Text    id=uiPwd    ${password}        # Password type karo
    Click Element    id=userLogin               # Login button click
    Sleep    3s                                  # 3 sec wait for page load
```
**Kya karta hai:** Application mein login karta hai. Pehle check karta hai ki re-login button hai ya nahi.
**Arguments:** `username` (e.g. 20) aur `password` (e.g. abcd@1234)

### 4.3 Navigate To Service Request Menu
```robot
Navigate To Service Request Menu
    [Arguments]    ${service_xpath}
    Click Element    xpath=//a[@class='item-nav'][@data-original-title='Menu']   # Hamburger menu
    Sleep    1s
    Click Element    ${XPATH_SERVICE_MENU}              # "Service" menu click
    Sleep    1s
    Click Element    ${XPATH_SERVICE_REQUEST_SUBMENU}   # "Service Request" submenu
    Sleep    1s
    Click Element    ${service_xpath}                   # Specific SR (e.g. Change Address)
    Sleep    2s
```
**Kya karta hai:** Menu → Service → Service Request → Specific SR navigate karta hai.
**Argument:** `service_xpath` — kaunsa SR open karna hai (e.g. `${XPATH_CHANGE_ADDRESS}`)

### 4.4 Search And Select Customer
```robot
Search And Select Customer
    [Arguments]    ${customer_id}
    Wait Until Element Is Visible    ${XPATH_CUSTOMER_ID_INPUT}    timeout=15s
    Click Element       ${XPATH_CUSTOMER_ID_INPUT}
    Clear Element Text  ${XPATH_CUSTOMER_ID_INPUT}      # Purana text clear karo
    Input Text    ${XPATH_CUSTOMER_ID_INPUT}    ${customer_id}   # CIF number type karo
    # VALIDATION: Check ki sahi value input hui
    ${actual_cif}=    Get Element Attribute    ${XPATH_CUSTOMER_ID_INPUT}    value
    Should Be Equal As Strings    ${actual_cif}    ${customer_id}
    ...    msg=VALIDATION FAILED: Customer ID expected '${customer_id}' but got '${actual_cif}'
    Log    ✓ VALIDATED: Customer ID = ${actual_cif}
    Sleep    1s
    Click Element    ${XPATH_SEARCH_BTN}                # Search button click
    Wait Until Element Is Visible    id=customerServiceList    timeout=15s
    Click Element    xpath=//input[@name='cifNo'][@type='radio']   # First result select
    Click Element    id=okServiceProceed                # Proceed button
    Sleep    2s
```
**Kya karta hai:** Customer ID (CIF) dalke search karta hai, result select karta hai.
**Validation:** Input ke baad check karta hai ki sahi value set hui ya nahi.

### 4.5 Select First Account
```robot
Select First Account
    Wait Until Element Is Visible    ${XPATH_ACCOUNT_INFO_DIV}    timeout=15s
    Sleep    3s
    Wait Until Element Is Visible    xpath=//input[@type='radio'][@name='accountNumber']    timeout=10s
    Execute JavaScript    document.getElementById('accountNumber1').click()   # First account select
    Sleep    1s
    # VALIDATION: Check ki radio button selected hai
    ${is_checked}=    Execute JavaScript    return document.getElementById('accountNumber1').checked
    Should Be True    ${is_checked}
    ...    msg=VALIDATION FAILED: Account radio button not selected
    Log    ✓ VALIDATED: Account radio button selected
    Execute JavaScript    document.getElementById('proceedAccData').click()   # Proceed
    Sleep    3s
```
**Kya karta hai:** Pehla account select karta hai aur proceed karta hai.
**Validation:** Radio button actually selected hua ya nahi check karta hai.
**Note:** `Execute JavaScript` isliye use kiya kyunki normal `Click Element` kabhi kabhi kaam nahi karta hidden elements pe.

### 4.6 Maker Creates Service Request (MASTER KEYWORD)
```robot
Maker Creates Service Request
    [Arguments]    ${login_id}    ${password}    ${service_xpath}    ${excel_path}
    Login To Application    ${login_id}    ${password}
    Navigate To Service Request Menu    ${service_xpath}
    ${data}=    Read Customer Search Data From Excel    ${excel_path}
    ${customer_id}=    Get From Dictionary    ${data}    Customer ID
    Set Global Variable    ${CUSTOMER_ID}    ${customer_id}
    Search And Select Customer    ${customer_id}
    Select First Account
```
**Kya karta hai:** Ek line mein pura flow — Login → Menu → Excel read → Search → Account Select.
**Yeh keyword saare 24 SR tests mein use hota hai.** Isliye common_keywords mein hai.

### 4.7 Other Keywords

| Keyword | Kya karta hai |
|---|---|
| `Logout From Application` | Logout button click karke session end karta hai |
| `Navigate To Service Request Inbox` | SR Inbox page open karta hai (Manager/Maker ke liye) |
| `Open Application By CIF` | Inbox table mein CIF number se application dhundhke open karta hai |
| `Approve Application` | Manager ka Approve button click karta hai |
| `Close Application` | Maker ka Close button click karta hai |
| `Send For Verification` | "Send for Verification" button click karta hai |
| `Fill Move To Next Form` | Manager assign karta hai aur remarks dalta hai |

---

## Section 5: Service Request Page (XPATHs & Locators)

File: `pages/service_request_page.robot`

Yeh file mein saare web elements ke addresses (XPATHs) stored hain. Jaise ghar ka address hota hai, waise hi har button/field ka XPATH hota hai jisse Selenium usse dhundh sake.

### 5.1 Main Navigation
```robot
${XPATH_SERVICE_MENU}                //li[@id='SERVICE']/a
${XPATH_SERVICE_REQUEST_SUBMENU}     //li[@id='SERVICEREQUEST']/a
```
**Matlab:** Menu mein "Service" aur uske andar "Service Request" ka link.

### 5.2 All 25 Service Request Menu Items

| Variable | Menu Item | HTML ID |
|---|---|---|
| `${XPATH_EMPLOYMENT_REQUEST}` | Employment Request | EMPLOYMENTREQUEST |
| `${XPATH_PERSONAL_DETAILS}` | Personal Details | PERSONALDETAILS |
| `${XPATH_REFUND_MAKER}` | Refund Maker | REFUNDMAKER |
| `${XPATH_VALUATION_SR}` | Valuation SR | VALUATIONSR |
| `${XPATH_ADD_COLLATERAL_SR}` | Add Collateral SR | ADDCOLLATERALSR |
| `${XPATH_CHANGE_ADDRESS}` | Change Address | CHANGEADDRESS |
| `${XPATH_CINET_CANCEL}` | CINET Cancel | CINETCANCEL |
| `${XPATH_DEBT_ACK_CANCEL}` | Debt Ack Cancel | DEBTACKCANCEL |
| `${XPATH_REPAYMENT_MODE_SR}` | Repayment Mode SR | REPAYMENTMODESR |
| `${XPATH_IDENTIFICATION}` | Identification | IDENTIFICATION |
| `${XPATH_ADD_DOCUMENTS}` | Add Documents | ADDDOCUMENTSMENUCODE |
| `${XPATH_SKIP_PAYMENT}` | Skip Payment | SKIPPAYMENT |
| `${XPATH_PARTIAL_SETTLEMENT}` | Partial Settlement | PARTIALSETTLEMENT |
| `${XPATH_COMM_LOAN_EXTEN}` | Commercial Loan Extension | COMMLOANEXTENBALLON |
| `${XPATH_RETAIL_LOAN_AMEND}` | Retail Loan Amendment | RETAILLOANAMED |
| `${XPATH_ADD_GUARANTOR_SR}` | Add Guarantor SR | ADDGUARANTORSR |
| `${XPATH_BLOCK_UNBLOCK_SERVICE}` | Block/Unblock Service | BLOCKUNBLOCKSERVICE |
| `${XPATH_FULL_INSURANCE_RENEW}` | Full Insurance Renew | FULLINSURANCERENEW |
| `${XPATH_INSURANCE_CANCEL}` | Insurance Cancel | INSURANCERECANCEL |
| `${XPATH_DELETE_GUARANTOR_SR}` | Delete Guarantor SR | DELETEGUARANTORSR |
| `${XPATH_TOTAL_LOSS}` | Total Loss | TOTALLOSS |
| `${XPATH_CHARGES_WAIVER}` | Charges Waiver | CHARGESWAIVER |
| `${XPATH_DECEASED_FRAUD_SR}` | Deceased/Fraud SR | DECEASEDFRAUDSR |
| `${XPATH_LEGAL_ACTION_SR}` | Legal Action SR | LEGALACTIONSR |
| `${XPATH_CANCEL_DEAL_REQUEST}` | Cancel Deal Request | CANCELDEALREQUEST |

**Pattern:** Sab ka XPATH same pattern follow karta hai: `//li[@id='MENU_ID']/a`

### 5.3 Customer Search Form Fields

| Variable | Field | HTML ID |
|---|---|---|
| `${XPATH_CUSTOMER_ID_INPUT}` | Customer ID (CIF) | cifNo |
| `${XPATH_CUSTOMER_NAME_INPUT}` | Customer Name | custName |
| `${XPATH_ACCOUNT_NO_INPUT}` | Account Number | accountNumber |
| `${XPATH_NATIONAL_ID_INPUT}` | National ID | nationalId |
| `${XPATH_MOBILE_INPUT}` | Mobile Number | mobileNo |
| `${XPATH_EMAIL_INPUT}` | Email ID | emailId |
| `${XPATH_SEARCH_BTN}` | Search Button | serviceCustSearch |

### 5.4 Action Buttons

| Variable | Button | Kab use hota hai |
|---|---|---|
| `${XPATH_SEND_FOR_VERIFICATION_BTN}` | Send for Verification | Maker form fill karke Manager ko bhejta hai |
| `${XPATH_APPROVE_BTN}` | Approve | Manager approve karta hai |
| `${XPATH_REJECT_BTN}` | Reject | Manager reject karta hai |
| `${XPATH_RETURN_BTN}` | Return | Manager wapas Maker ko bhejta hai |
| `${XPATH_CLOSE_BTN}` | Close | Maker final close karta hai |

### 5.5 XPATH Kya Hota Hai? (Beginner Explanation)
XPATH ek address hai web page pe kisi element ka. Jaise:
- `//button[@id='userLogin']` → "Woh button dhundho jiska id 'userLogin' hai"
- `//li[@id='CHANGEADDRESS']/a` → "Woh list item dhundho jiska id 'CHANGEADDRESS' hai, uske andar ka link do"
- `//input[@name='cifNo'][@type='radio']` → "Woh radio button dhundho jiska name 'cifNo' hai"

---

## Section 6: Change Address - Full Implementation

Yeh sirf ek SR hai jo **fully implemented** hai. Isko samajh lo toh baaki sab samajh aa jayega.

### 6.1 Complete Flow (3 Phases)

```
PHASE 1: MAKER (User 20)
  Login → Menu → Change Address → Search Customer → Select Account
  → iframe mein form fill (Create/Edit address) → Save
  → Send for Verification → Manager assign → Logout

PHASE 2: MANAGER (Random: USER2/n.wisa/h.aldosari/a.ali)
  Login → SR Inbox → CIF se application dhundho → Approve → Logout

PHASE 3: MAKER (User 20 again)
  Login → SR Inbox → CIF se application dhundho → Close → Browser Close
```

### 6.2 Test Case Structure
```robot
Change Address Request
    Open Browser    ${LOS_QC_URL}    chrome
    Maximize Browser Window
    Execute JavaScript    document.body.style.zoom='75%'
    Set Selenium Implicit Wait    10

    # PHASE 1: Maker
    Login To Application    ${LOGIN_ID}    ${PASSWORD}
    Navigate To Service Request
    Search Customer
    Select Account
    Process Address Changes          # ⭐ Yeh main action hai
    Logout From Application

    # PHASE 2: Manager
    Login To Application    ${SELECTED_MANAGER_USER}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Approve Application
    Logout From Application

    # PHASE 3: Maker Close
    Login To Application    ${LOGIN_ID}    ${PASSWORD}
    Navigate To Service Request Inbox
    Open Application By CIF    ${CUSTOMER_ID}
    Close Application
    Close Browser
```

### 6.3 Process Address Changes (Main Logic)

Yeh keyword 3 address types process karta hai: **RESIDENTIAL, PERMANENT, BUSINESS**

```robot
Process Address Changes
    # 1. iframe mein switch karo (form iframe ke andar hai)
    Select Frame    id=viewChangeAddressFrame

    # 2. Excel se data read karo
    ${addresses}=    Read Address Sections    ${excel_path}

    # 3. Har address type ke liye loop
    FOR    ${addr_type}    IN    RESIDENTIAL    PERMANENT    BUSINESS
        ${addr_data}=    Get From Dictionary    ${addresses}    ${addr_type}
        # Check ki Action key hai ya nahi
        Run Keyword If    ${has_data}    Route Address Action    ${addr_type}    ${addr_data}
    END

    # 4. Send for Verification
    Send For Verification
```

**Key Concept - iframe:** Application ka form ek iframe ke andar hai. Matlab page ke andar ek aur page hai. Isliye `Select Frame` karna padta hai form access karne ke liye, aur baad mein `Unselect Frame` karna padta hai wapas aane ke liye.

### 6.4 Route Address Action
Excel mein har address ke liye **Action** column hota hai:
- `Create` → Naya address banao
- `Edit` → Existing address modify karo
- `Skip` → Kuch mat karo

### 6.5 Create Address Section (Naya Address)
Yeh keyword naya address create karta hai. Har field ke baad **validation** bhi hai:

| Step | Field | Type | Validation |
|---|---|---|---|
| 1 | Customer Type | Select2 Dropdown | ✓ Select2 text check |
| 2 | Fetch Details | Button Click | - |
| 3 | Address Type | Select2 Dropdown | ✓ Select2 text check |
| 4 | Status | Select2 Dropdown | ✓ Select2 text check |
| 5 | Living Since | Date Field | - |
| 6 | Country | Select2 (always KUWAIT) | ✓ Select2 text check |
| 7 | District | Select2 By Label | ✓ Select2 text check |
| 8 | Area | Select2 Dropdown | ✓ Select2 text check |
| 9 | Block | Text Input | ✓ value attribute check |
| 10 | Street | Text Input | ✓ value attribute check |
| 11 | Building | Text Input | ✓ value attribute check |
| 12 | Unit Type | Select2 Dropdown | ✓ Select2 text check |
| 13 | Unit No | Text Input | ✓ value attribute check |
| 14 | Floor | Text Input | ✓ value attribute check |
| 15 | Document | File Upload (random) | - |
| 16 | Save | Button Click | - |

### 6.6 Edit Address Section (Existing Address Modify)
Pehle table mein existing address dhundhta hai, edit button click karta hai, phir form fields update karta hai. Same validation lagti hai.

### 6.7 Select2 Dropdown Kya Hai?
Application mein normal `<select>` dropdown nahi hai. **Select2** ek JavaScript library hai jo fancy dropdowns banati hai. Isliye:
1. Pehle visible span click karo (dropdown open hota hai)
2. Phir hidden `<select>` element mein value set karo

```robot
Select2 Dropdown
    [Arguments]    ${field_id}    ${value}    ${label}
    Click Element    xpath=//span[@aria-labelledby='select2-${field_id}-container']
    Sleep    1s
    Select From List By Value    id=${field_id}    ${value}
    Sleep    1s
```

### 6.8 Document Upload
Random document upload karta hai folder se:
```robot
Upload Random Document
    @{files}=    List Files In Directory    ${DOCUMENT_FOLDER}
    ${random_index}=    Evaluate    random.randint(0, ${file_count}-1)    modules=random
    ${selected_file}=    Set Variable    ${files}[${random_index}]
    Choose File    ${XPATH_DOCUMENT_DATA}    ${file_path}
```
**Folder:** `C:\Users\omkar.patil\OneDrive - KIYA.AI\Desktop\Omkar\Customer ID Proof`

### 6.9 Send For Verification + Move To Next
1. iframe se bahar aao (`Unselect Frame`)
2. "Send for Verification" button click
3. Manager assign karo (random select from list)
4. Remarks likho
5. Submit

### 6.10 Mapping Dictionaries
Excel mein text values hain (e.g. "Main Applicant") but application ko numeric codes chahiye (e.g. "101"). Isliye mapping dictionaries use kiye:

```robot
&{CUST_TYPE_MAP}       Main Applicant=101    Guarantor=103    Joint Applicant=102
&{ADDRESS_TYPE_MAP}    RESIDENTIAL ADDRESS=1    PERMANENT ADDRESS=4    BUSINESS ADDRESS=6
&{STATUS_MAP}          Active=1    InActive=2
&{AREA_MAP}            SALMIYA=103    JABRIYA=115    HAWALLI=114    ...
&{UNIT_TYPE_MAP}       Apartment=1    Villa=2
```
**Matlab:** Excel mein "Main Applicant" likho, code automatically "101" bhejega application ko.

---

## Section 7: Other 24 Service Requests

### Current Status
Saare 24 SR files mein abhi **common flow** implemented hai (login → menu → search → account select). Action part `# TODO` hai — baad mein har ek ka alag implement hoga.

### Har SR File ka Structure (Same Pattern)
```robot
*** Settings ***
Resource         ../../pages/common_keywords.robot    # Common keywords import

*** Variables ***
${LOGIN_ID}      20
${PASSWORD}      abcd@1234
${CUSTOMER_ID}   ${EMPTY}
${EXCEL_PATH}    ${CURDIR}/../../data/<sr_name>.xlsx    # Apni excel file

*** Test Cases ***
<SR Name> Request
    Open Browser And Setup
    Maker Creates Service Request    ${LOGIN_ID}    ${PASSWORD}    ${XPATH_<SR>}    ${EXCEL_PATH}
    # TODO: Add specific processing here
    Close Browser
```

### All 25 Service Requests - Status Table

| # | Service Request | File | Tag | Status |
|---|---|---|---|---|
| 1 | Employment Request | `employment_request.robot` | employment_request | ⏳ Common flow only |
| 2 | Personal Details | `personal_details.robot` | personal_details | ⏳ Common flow only |
| 3 | Refund Maker | `refund_maker.robot` | refund_maker | ⏳ Common flow only |
| 4 | Valuation SR | `valuation_sr.robot` | valuation_sr | ⏳ Common flow only |
| 5 | Add Collateral SR | `add_collateral_sr.robot` | add_collateral_sr | ⏳ Common flow only |
| 6 | **Change Address** | `change_address.robot` | change_address | ✅ **FULLY IMPLEMENTED** |
| 7 | CINET Cancel | `cinet_cancel.robot` | cinet_cancel | ⏳ Common flow only |
| 8 | Debt Ack Cancel | `debt_ack_cancel.robot` | debt_ack_cancel | ⏳ Common flow only |
| 9 | Repayment Mode SR | `repayment_mode_sr.robot` | repayment_mode_sr | ⏳ Common flow only |
| 10 | Identification | `identification.robot` | identification | ⏳ Common flow only |
| 11 | Add Documents | `add_documents.robot` | add_documents | ⏳ Common flow only |
| 12 | Skip Payment | `skip_payment.robot` | skip_payment | ⏳ Common flow only |
| 13 | Partial Settlement | `partial_settlement.robot` | partial_settlement | ⏳ Common flow only |
| 14 | Commercial Loan Extension | `commercial_loan_extension.robot` | commercial_loan_extension | ⏳ Common flow only |
| 15 | Retail Loan Amendment | `retail_loan_amendment.robot` | retail_loan_amendment | ⏳ Common flow only |
| 16 | Add Guarantor SR | `add_guarantor_sr.robot` | add_guarantor_sr | ⏳ Common flow only |
| 17 | Block/Unblock Service | `block_unblock_service.robot` | block_unblock_service | ⏳ Common flow only |
| 18 | Full Insurance Renew | `full_insurance_renew.robot` | full_insurance_renew | ⏳ Common flow only |
| 19 | Insurance Cancel | `insurance_cancel.robot` | insurance_cancel | ⏳ Common flow only |
| 20 | Delete Guarantor SR | `delete_guarantor_sr.robot` | delete_guarantor_sr | ⏳ Common flow only |
| 21 | Total Loss | `total_loss.robot` | total_loss | ⏳ Common flow only |
| 22 | Charges Waiver | `charges_waiver.robot` | charges_waiver | ⏳ Common flow only |
| 23 | Deceased/Fraud SR | `deceased_fraud_sr.robot` | deceased_fraud_sr | ⏳ Common flow only |
| 24 | Legal Action SR | `legal_action_sr.robot` | legal_action_sr | ⏳ Common flow only |
| 25 | Cancel Deal Request | `cancel_deal_request.robot` | cancel_deal_request | ⏳ Common flow only |

### Kaise Run kare specific SR?
```bash
# Single SR run karo
robot tests/service_request/employment_request.robot

# Tag se run karo
robot --include change_address tests/service_request/

# Saare SR run karo
robot tests/service_request/
```

---

## Section 8: Excel Input Files & Python Readers

### 8.1 Excel Files List
Har SR ki apni excel file hai `data/` folder mein. Sab mein basic structure same hai:

**Simple SR Excel (24 files):**
```
Row 1: Customer ID     (Header)
Row 2: 200125          (Value)
```
Bas ek column — Customer ID. Baad mein jab action part implement hoga toh aur columns add honge.

**Change Address Excel (special):**
```
Row 1:  Headers (Action, Customer_Type, Status, Living_Since, District, Area, Block, Street, Building, Unit_Type, Unit_No, Floor)
Row 2:  RESIDENTIAL (section label)
Row 3:  Edit, Main Applicant, Active, 01/01/2020, HAWALLI, SALMIYA, 1, 10, Building A, Apartment, 101, 1
Row 6:  PERMANENT (section label)
Row 7:  Create, Main Applicant, Active, 01/01/2019, HAWALLI, JABRIYA, 2, 20, Building B, Villa, 201, 2
Row 10: BUSINESS (section label)
Row 11: Skip, Main Applicant, Active, ...
```

### 8.2 excel_reader.py (Simple Reader)
```python
def read_excel_data(file_path):
    wb = openpyxl.load_workbook(file_path)   # Excel file open karo
    ws = wb.active                            # First sheet lo
    headers = [cell.value for cell in ws[1]]  # Row 1 = headers
    values = [cell.value for cell in ws[2]]   # Row 2 = values
    # Dictionary banao: {'Customer ID': '200125'}
    for i, header in enumerate(headers):
        data[str(header)] = str(values[i])
    return data
```
**Input:** Excel file path
**Output:** Dictionary like `{'Customer ID': '200125'}`
**Used by:** Saare 24 SR tests (common_keywords mein)

### 8.3 address_reader.py (Change Address Reader)
```python
def read_address_sections(file_path):
    # Row 3 = RESIDENTIAL, Row 7 = PERMANENT, Row 11 = BUSINESS
    # Har section ke liye dictionary banata hai
    # Date format bhi handle karta hai (DD/MM/YYYY → DD-MM-YYYY)
    return {
        'RESIDENTIAL': {'Action': 'Edit', 'Block': '1', ...},
        'PERMANENT':   {'Action': 'Create', 'Block': '2', ...},
        'BUSINESS':    {'Action': 'Skip', ...}
    }
```
**Input:** change_address.xlsx path
**Output:** 3 sections ka dictionary with all address fields
**Special:** Date format automatically convert karta hai (Excel date object → DD-MM-YYYY string)
**Used by:** Only change_address.robot

### 8.4 create_all_sr_excels.py (Excel Generator)
Yeh script ek baar run karke saari 25 excel files bana deta hai:
```bash
cd data
python create_all_sr_excels.py
# Output: 25 .xlsx files created
```

---

## Section 9: Validation Logic

Validation matlab — jo value Excel se read ki, woh actually field mein set hui ya nahi. Agar nahi hui toh test **FAIL** hoga.

### 9.1 Text Field Validation
```robot
Validate Text Field
    [Arguments]    ${field_id}    ${expected_value}
    ${actual_value}=    Get Element Attribute    id=${field_id}    value
    Should Be Equal As Strings    ${actual_value}    ${expected_str}
    ...    msg=VALIDATION FAILED: Field '${field_id}' expected '${expected_str}' but got '${actual_value}'
    Log    ✓ VALIDATED: ${field_id} = ${actual_value}
```
**Kaise kaam karta hai:**
1. Field ka `value` attribute read karo (jo actually browser mein dikhta hai)
2. Expected value se compare karo
3. Match nahi hua → Test FAIL with clear error message
4. Match hua → Log mein ✓ VALIDATED print hoga

**Used for:** Block, Street, Building, Unit No, Floor

### 9.2 Select2 Dropdown Validation
```robot
Validate Select2 Value
    [Arguments]    ${field_id}    ${expected_label}
    ${actual_text}=    Get Text    xpath=//span[@id='select2-${field_id}-container']
    ${expected_upper}=    Convert To Upper Case    ${expected_label}
    ${actual_upper}=     Convert To Upper Case    ${actual_text}
    Should Contain    ${actual_upper}    ${expected_upper}
    ...    msg=VALIDATION FAILED: Dropdown '${field_id}' expected '${expected_label}' but got '${actual_text}'
    Log    ✓ VALIDATED: ${field_id} = ${actual_text}
```
**Kaise kaam karta hai:**
1. Select2 container ka displayed text read karo
2. Case-insensitive compare karo (SALMIYA = salmiya = Salmiya)
3. Match nahi hua → Test FAIL

**Used for:** Customer Type, Address Type, Status, Country, District, Area, Unit Type

### 9.3 Customer ID Validation (Common Keywords)
```robot
${actual_cif}=    Get Element Attribute    ${XPATH_CUSTOMER_ID_INPUT}    value
Should Be Equal As Strings    ${actual_cif}    ${customer_id}
```
**Kab:** Customer ID input karne ke baad, search se pehle.

### 9.4 Account Radio Button Validation (Common Keywords)
```robot
${is_checked}=    Execute JavaScript    return document.getElementById('accountNumber1').checked
Should Be True    ${is_checked}
```
**Kab:** Account radio button click karne ke baad, proceed se pehle.

### 9.5 Validation Summary

| Where | What | How |
|---|---|---|
| Common Keywords | Customer ID input | value attribute check |
| Common Keywords | Account radio button | JavaScript checked property |
| Change Address - Create | All dropdowns (7) | Select2 container text |
| Change Address - Create | All text fields (5) | value attribute check |
| Change Address - Edit | All dropdowns (4) | Select2 container text |
| Change Address - Edit | All text fields (5) | value attribute check |

---

## Section 10: How to Execute Tests

### 10.1 Single Test Run
```bash
# Specific SR run karo
robot tests/service_request/change_address.robot

# Specific SR with output folder
robot --outputdir results tests/service_request/change_address.robot
```

### 10.2 Multiple Tests
```bash
# Saare service request tests
robot tests/service_request/

# Saare tests (including LOS, LMS, API)
robot tests/
```

### 10.3 Run by Tag
```bash
# Sirf change_address tag wale tests
robot --include change_address tests/

# Sirf employment_request
robot --include employment_request tests/
```

### 10.4 Parallel Execution (Fast!)
```bash
# 4 browsers ek saath chalao
pabot --processes 4 tests/service_request/
```
**Note:** Parallel mein har test alag browser mein chalega — 4x fast!

### 10.5 Debug Mode
```bash
# Detailed logs ke saath
robot --loglevel DEBUG tests/service_request/change_address.robot
```

### 10.6 Using Batch Script
```bash
# Windows batch file se
scripts\run_tests.bat smoke      # Smoke tests
scripts\run_tests.bat full       # Full suite
scripts\run_tests.bat parallel   # Parallel
scripts\run_tests.bat tag change_address   # By tag
scripts\run_tests.bat setup      # Install dependencies
```

### 10.7 Results Kahan Milenge?
Test run hone ke baad 3 files banti hain:

| File | Kya hai |
|---|---|
| `report.html` | Summary report — pass/fail count, graphs |
| `log.html` | Detailed log — har step ka detail with screenshots |
| `output.xml` | Machine readable XML — Jenkins/CI tools ke liye |

**Report dekhne ke liye:** Browser mein `report.html` open karo.

---

## Section 11: CI/CD (Jenkins & Email)

### 11.1 Jenkins Kya Hai?
Jenkins ek tool hai jo automatically tests run karta hai — tum code push karo, Jenkins detect karega aur tests chalayega. Results email pe aa jayenge.

### 11.2 Jenkinsfile Structure
```
Stage 1: Checkout     → Code download karo Git se
Stage 2: Setup        → pip install -r requirements.txt
Stage 3: Run Tests    → Smoke + Receipt tests parallel mein
Stage 4: Parallel     → pabot --processes 4 tests/
Post: Always          → Results archive + Email bhejo
Post: Success         → Green email — “✅ All tests passed!”
Post: Failure         → Red email — “❌ Tests failed! Check logs”
```

### 11.3 Email Notifications
Har test run ke baad email aata hai:
- **To:** omkar.patil@kiya.ai
- **Subject:** 🚀 KFIC Test Results - Build #123 - SUCCESS/FAILURE
- **Body:** Pass/Fail count, pass rate, duration, links to reports
- **Attachments:** report.html, log.html, output.xml

### 11.4 Email Setup
File: `docs/EMAIL_SETUP.md` mein detailed guide hai.
SMTP config: Gmail (`smtp.gmail.com:587`) ya Corporate mail.

### 11.5 send_email_report.py
Yeh standalone Python script hai — bina Jenkins ke bhi email bhej sakta hai:
```bash
python send_email_report.py
# Tests run karega + email bhejega
```

---

## Section 12: Change Log / Progress Tracker

> **Yeh section update hota rahega jese jese progress hoga.**

### ✅ Completed

| Date | What was done |
|---|---|
| - | Initial framework setup — Robot Framework, Selenium, folder structure |
| - | Login test created and working |
| - | Receipt management tests created |
| - | LOS Retail Flow — SELECT2 dropdowns, Excel auto-read, alert handling |
| - | Change Address SR — **FULLY IMPLEMENTED** (Create + Edit + iframe + Select2 + date + document upload) |
| - | `service_request_page.robot` — All 25 SR menu XPATHs defined |
| - | `common_keywords.robot` — Shared keywords extracted (Login, Search, Account Select, Logout, Approve, Close) |
| - | 25 SR robot test files created (common flow: login → menu → search → account select) |
| - | 25 Excel input files created (one per SR) |
| - | Validation added — Customer ID, Account radio, all Change Address fields |
| - | Email references updated from akarshit.raj to omkar.patil |
| - | Git remote updated to https://github.com/itsomkar4545/Kfic-automation |
| - | Code pushed to GitHub |
| - | This documentation created |

### ⏳ Pending / Next Steps

| Priority | Task |
|---|---|
| HIGH | Implement action part for remaining 24 SRs (each has different form/logic) |
| HIGH | Add Manager approve + Maker close flow to all 24 SRs |
| MEDIUM | Add more Excel columns for each SR's specific input data |
| MEDIUM | Add validation in each SR's action part |
| LOW | Add screenshot capture at key steps |
| LOW | Add retry mechanism for flaky elements |
| LOW | Add parallel execution support for SRs |

### 📝 Notes
- Change Address is the reference implementation — study this to understand the pattern
- All 24 SRs follow same common flow, only action part differs
- `common_keywords.robot` is the single source of truth for shared logic
- Excel files are the single source of truth for test data
- Validation ensures data integrity — if field value doesn't match Excel, test fails

---

## Section 13: Coding Concepts - Robot Framework, Python & How It All Works

### 13.1 Robot Framework Kya Hai?
Robot Framework ek **test automation tool** hai jismein tum English jaisi language mein test likhte ho. Yeh Python pe based hai.

**Normal Python:**
```python
driver.find_element(By.ID, "loginId").send_keys("20")
```
**Robot Framework (same kaam, easy language):**
```robot
Input Text    id=loginId    20
```
Dono same kaam karte hain — but Robot Framework padhne mein easy hai.

### 13.2 Robot File ka Structure (.robot file)
Har `.robot` file mein **4 sections** hote hain:

```robot
*** Settings ***        # Section 1: Imports (libraries, resources)
*** Variables ***       # Section 2: Variables (data store)
*** Test Cases ***      # Section 3: Actual tests (yeh run hote hain)
*** Keywords ***        # Section 4: Custom functions (reusable steps)
```

**Real Example:**
```robot
*** Settings ***
Library    SeleniumLibrary              # Browser control library import
Resource   ../../pages/common_keywords.robot   # Apni keywords file import

*** Variables ***
${LOGIN_ID}    20                       # Variable — value store karta hai
${PASSWORD}    abcd@1234

*** Test Cases ***
My First Test                           # Test case name
    Open Browser    https://google.com    chrome    # Step 1
    Input Text    name=q    Robot Framework          # Step 2
    Close Browser                                     # Step 3

*** Keywords ***
My Custom Keyword                       # Apna function banaya
    Log    Hello World                  # Print karta hai
```

### 13.3 Variables (Data Store Karna)

Robot Framework mein 4 type ke variables hain:

| Type | Syntax | Example | Kya store karta hai |
|---|---|---|---|
| **Scalar** | `${NAME}` | `${LOGIN_ID}    20` | Ek single value (string, number) |
| **List** | `@{NAME}` | `@{USERS}    USER1    USER2    USER3` | Multiple values (array) |
| **Dictionary** | `&{NAME}` | `&{MAP}    key1=val1    key2=val2` | Key-value pairs |
| **Empty** | `${EMPTY}` | `${CUSTOMER_ID}    ${EMPTY}` | Khaali value |

**Variable kaise use karte hain:**
```robot
*** Variables ***
${NAME}      Omkar                    # Define karo
${AGE}       25

*** Test Cases ***
Test Variable
    Log    My name is ${NAME}         # Use karo — Output: My name is Omkar
    Log    Age is ${AGE}
```

**Global Variable (sab jagah accessible):**
```robot
Set Global Variable    ${CUSTOMER_ID}    200125
# Ab ${CUSTOMER_ID} kisi bhi keyword mein use ho sakta hai
```

**Test Variable (sirf current test mein):**
```robot
Set Test Variable    ${day}    15
# Sirf is test case mein accessible hai
```

### 13.4 Keywords (Functions/Methods)

Keyword = Function. Reusable steps jo baar baar use ho sakti hain.

**Simple Keyword (no arguments):**
```robot
*** Keywords ***
Logout From Application
    Click Element    ${XPATH_LOGOUT}     # Step 1
    Sleep    2s                           # Step 2
```
**Call kaise karo:** Bas naam likho
```robot
Logout From Application
```

**Keyword with Arguments (inputs):**
```robot
*** Keywords ***
Login To Application
    [Arguments]    ${username}    ${password}       # 2 inputs accept karta hai
    Input Text    id=loginId    ${username}
    Input Text    id=uiPwd    ${password}
    Click Element    id=userLogin
```
**Call kaise karo:**
```robot
Login To Application    20    abcd@1234
#                       ↑↑    ↑↑↑↑↑↑↑↑↑
#                    username  password
```

**Keyword with Return Value:**
```robot
*** Keywords ***
Read Customer Search Data From Excel
    [Arguments]    ${excel_path}
    ${data}=    Read Excel Data    ${excel_path}    # Python function call
    RETURN    ${data}                                # Value return karo
```
**Call kaise karo:**
```robot
${data}=    Read Customer Search Data From Excel    ${excel_path}
# Ab ${data} mein Excel ka data hai
```

### 13.5 Built-in Keywords (Robot Framework ke apne)

Yeh keywords pehle se bane hue hain — bas use karo:

| Keyword | Kya karta hai | Example |
|---|---|---|
| `Log` | Console/log mein print karta hai | `Log    Hello World` |
| `Sleep` | Wait karta hai | `Sleep    3s` |
| `Set Variable` | Variable set karta hai | `${x}=    Set Variable    hello` |
| `Should Be Equal` | 2 values compare karta hai | `Should Be Equal    ${a}    ${b}` |
| `Should Be True` | Condition check karta hai | `Should Be True    ${is_checked}` |
| `Run Keyword If` | If condition | `Run Keyword If    ${x}    Do Something` |
| `Run Keyword And Return Status` | Try-catch jaisa | Returns True/False |
| `FOR ... IN` | Loop | `FOR    ${item}    IN    @{list}` |
| `Get From Dictionary` | Dictionary se value lo | `${val}=    Get From Dictionary    ${dict}    key` |
| `Convert To String` | Type convert | `${str}=    Convert To String    ${number}` |
| `Convert To Upper Case` | Uppercase | `${upper}=    Convert To Upper Case    hello` |
| `Create List` | List banao | `@{list}=    Create List    a    b    c` |
| `Get Length` | Length nikalo | `${len}=    Get Length    ${list}` |
| `Evaluate` | Python expression run karo | `${rand}=    Evaluate    random.randint(0,5)    modules=random` |

### 13.6 SeleniumLibrary Keywords (Browser Control)

Yeh keywords browser control karte hain:

| Keyword | Kya karta hai | Example |
|---|---|---|
| `Open Browser` | Browser open karo | `Open Browser    ${URL}    chrome` |
| `Close Browser` | Browser band karo | `Close Browser` |
| `Maximize Browser Window` | Full screen | `Maximize Browser Window` |
| `Click Element` | Element pe click | `Click Element    id=loginBtn` |
| `Input Text` | Text type karo | `Input Text    id=name    Omkar` |
| `Clear Element Text` | Field khaali karo | `Clear Element Text    id=name` |
| `Select From List By Value` | Dropdown select (value se) | `Select From List By Value    id=country    KWT` |
| `Select From List By Label` | Dropdown select (text se) | `Select From List By Label    id=area    SALMIYA` |
| `Wait Until Element Is Visible` | Element dikhne tak wait | `Wait Until Element Is Visible    id=btn    timeout=15s` |
| `Get Element Attribute` | Attribute read karo | `${val}=    Get Element Attribute    id=name    value` |
| `Get Text` | Element ka text lo | `${txt}=    Get Text    id=label` |
| `Execute JavaScript` | JS code run karo | `Execute JavaScript    document.body.style.zoom='75%'` |
| `Choose File` | File upload | `Choose File    id=upload    C:\\file.pdf` |
| `Select Frame` | iframe mein jao | `Select Frame    id=myFrame` |
| `Unselect Frame` | iframe se bahar aao | `Unselect Frame` |
| `Press Keys` | Keyboard keys press | `Press Keys    id=field    CTRL+a` |
| `Capture Page Screenshot` | Screenshot lo | `Capture Page Screenshot` |
| `Set Selenium Implicit Wait` | Default wait set | `Set Selenium Implicit Wait    10` |

### 13.7 Element Locators (Element Kaise Dhundhte Hain)

Browser mein har element ka ek address hota hai. Robot Framework mein yeh locators use hote hain:

| Locator | Syntax | Example | Kab use karo |
|---|---|---|---|
| **id** | `id=value` | `id=loginId` | Jab element ka unique id ho |
| **name** | `name=value` | `name=cifNo` | Jab name attribute ho |
| **xpath** | `xpath=//path` | `xpath=//button[@id='save']` | Jab complex path chahiye |
| **css** | `css=selector` | `css=#loginBtn` | CSS selector se |
| **class** | `class=value` | `class=item-nav` | Class name se |

**XPATH Examples (sabse zyada use hota hai):**
```
//button[@id='save']                    → id se dhundho
//input[@type='radio']                  → type se dhundho
//li[@id='SERVICE']/a                   → parent ke andar child
//table//tr[td[contains(text(),'200')]] → text contain karta ho
//span[@aria-labelledby='select2-country-container']  → attribute se
```

### 13.8 Resource & Library (Import Karna)

```robot
*** Settings ***
Library    SeleniumLibrary                    # Built-in library import
Library    Collections                         # Dictionary/List operations
Library    String                              # String operations
Library    OperatingSystem                     # File operations
Library    ../../utils/excel_reader.py         # Custom Python file import
Resource   ../../pages/common_keywords.robot   # Another .robot file import
Resource   ../../config/environment.robot      # Config file import
```

| Keyword | Kya import karta hai | Kab use karo |
|---|---|---|
| `Library` | Python library ya .py file | SeleniumLibrary, Collections, custom .py |
| `Resource` | Another .robot file | Keywords, variables share karne ke liye |

### 13.9 Python Integration (Robot + Python)

Robot Framework Python pe chalta hai. Tum apni Python functions directly Robot mein use kar sakte ho.

**Step 1: Python file banao** (`utils/excel_reader.py`)
```python
import openpyxl

def read_excel_data(file_path):          # Function name = Robot keyword name
    wb = openpyxl.load_workbook(file_path)
    ws = wb.active
    data = {}
    headers = [cell.value for cell in ws[1]]
    values = [cell.value for cell in ws[2]]
    for i, header in enumerate(headers):
        if header and i < len(values):
            data[str(header)] = str(values[i]) if values[i] is not None else ''
    wb.close()
    return data                           # Dictionary return karta hai
```

**Step 2: Robot mein import karo**
```robot
*** Settings ***
Library    ../../utils/excel_reader.py
```

**Step 3: Robot mein use karo**
```robot
${data}=    Read Excel Data    ${excel_path}
#           ↑↑↑↑↑↑↑↑↑↑↑↑↑↑
#    Python function name (underscores → spaces, auto convert)
```

**Important Rule:** Python function `read_excel_data` Robot mein `Read Excel Data` ban jaata hai (underscores spaces ban jaate hain, case insensitive).

### 13.10 Python Concepts Used in This Project

**openpyxl (Excel Library):**
```python
import openpyxl
wb = openpyxl.load_workbook('file.xlsx')   # Excel file open
ws = wb.active                              # Active sheet lo
cell_value = ws.cell(row=1, column=1).value # Cell read karo (A1)
ws['A1'] = 'Hello'                          # Cell mein likho
wb.save('file.xlsx')                        # Save karo
wb.close()                                  # Band karo
```

**Dictionary (key-value pairs):**
```python
data = {'Customer ID': '200125', 'Name': 'Omkar'}
print(data['Customer ID'])    # Output: 200125
```

**String operations:**
```python
str(value)                    # Kuch bhi string mein convert
value.strip()                 # Extra spaces hatao
value.lower()                 # Lowercase
date_str.split('-')           # Split karo: '01-02-2024' → ['01','02','2024']
```

**datetime (Date handling):**
```python
from datetime import datetime
dt = datetime.strptime('01/02/2024', '%d/%m/%Y')   # String → Date object
formatted = dt.strftime('%d-%m-%Y')                  # Date → String (01-02-2024)
```

**os (File paths):**
```python
import os
filepath = os.path.join(folder, 'file.xlsx')   # Path banao safely
```

**random (Random selection):**
```python
import random
random.randint(0, 5)          # 0 se 5 ke beech random number
```

### 13.11 FOR Loop (Robot Framework)
```robot
# List pe loop
FOR    ${item}    IN    apple    banana    cherry
    Log    Fruit: ${item}
END

# Humne kaise use kiya (change_address.robot):
FOR    ${addr_type}    IN    RESIDENTIAL    PERMANENT    BUSINESS
    ${addr_data}=    Get From Dictionary    ${addresses}    ${addr_type}
    Route Address Action    ${addr_type}    ${addr_data}
END
```

### 13.12 IF Condition (Robot Framework)
```robot
# Simple if
Run Keyword If    '${action}' == 'Create'    Create Address Section    ${data}

# If-Else
Run Keyword If    '${action}' == 'Create'    Create Address Section    ${data}
...    ELSE IF    '${action}' == 'Edit'    Edit Address Section    ${addr_type}    ${data}
...    ELSE    Log    Skipping

# Try-Catch jaisa (error handle karo)
${status}=    Run Keyword And Return Status    Click Element    id=someBtn
# ${status} = True agar click hua, False agar element nahi mila
Run Keyword If    ${status}    Log    Button clicked!
```

### 13.13 Test Case Tags
```robot
*** Test Cases ***
Change Address Request
    [Documentation]    Service request for address change
    [Tags]    change_address                    # Tag lagao
    [Teardown]    Run Keyword If Test Failed    Capture Page Screenshot   # Fail pe screenshot
```

| Setting | Kya karta hai |
|---|---|
| `[Documentation]` | Test ka description |
| `[Tags]` | Labels — filter karne ke liye (`--include tag_name`) |
| `[Teardown]` | Test end hone pe (pass ya fail) yeh run hoga |
| `[Arguments]` | Keyword ke inputs define karo |

### 13.14 Sleep vs Wait (Important Difference)
```robot
Sleep    3s
# HARD WAIT — 3 second rukega chahe element aa jaye ya na aaye. Slow but safe.

Wait Until Element Is Visible    id=btn    timeout=15s
# SMART WAIT — jaise hi element dikhe, aage badh jayega. Max 15 sec wait karega.
```
**Best Practice:** `Wait Until Element Is Visible` use karo jab bhi possible ho. `Sleep` sirf tab use karo jab koi aur option na ho.

### 13.15 Execute JavaScript (Kab aur Kyun)
Kabhi kabhi normal Selenium commands kaam nahi karte — tab JavaScript directly run karte hain:

```robot
# Element click nahi ho raha (hidden hai ya covered hai)
Execute JavaScript    document.getElementById('accountNumber1').click()

# Page zoom set karna
Execute JavaScript    document.body.style.zoom='75%'

# Field value clear karna
Execute JavaScript    document.getElementById('addressStartDate').value = ''

# Element scroll karna
Execute JavaScript    var elem = document.getElementById('btn'); elem.scrollIntoView({block: 'center'});

# Value read karna
${is_checked}=    Execute JavaScript    return document.getElementById('accountNumber1').checked
```

### 13.16 Dictionary Operations (Bahut Use Hota Hai)
```robot
# Dictionary banao
&{MY_MAP}    key1=value1    key2=value2

# Value nikalo
${val}=    Get From Dictionary    ${MY_MAP}    key1
# ${val} = value1

# Check ki key hai ya nahi
${has_key}=    Run Keyword And Return Status
...    Dictionary Should Contain Key    ${MY_MAP}    key1

# Humne kaise use kiya:
${cust_type_val}=    Get From Dictionary    ${CUST_TYPE_MAP}    Main Applicant
# ${cust_type_val} = 101
```

### 13.17 File Structure Summary — Kya Kahan Likhte Hain

| Kya likhna hai | Kahan likhte hain | Example |
|---|---|---|
| XPATHs / Locators | `pages/*.robot` ke Variables section | `${XPATH_LOGIN_BTN}    //button[@id='login']` |
| Shared Keywords | `pages/common_keywords.robot` | Login, Search, Logout |
| Test-specific Keywords | Test file ke Keywords section | Process Address Changes |
| Test Cases | `tests/*.robot` ke Test Cases section | Change Address Request |
| Python helpers | `utils/*.py` | excel_reader.py, address_reader.py |
| Test Data | `data/*.xlsx` | customer_search.xlsx |
| Config/URLs | `config/*.robot` | environment.robot |

---

**Document maintained by:** Omkar Patil
**GitHub:** https://github.com/itsomkar4545/Kfic-automation
**Framework:** Robot Framework + Selenium + Python

---
