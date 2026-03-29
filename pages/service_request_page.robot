*** Settings ***
Documentation    Service Request Page Elements

*** Variables ***
# Main Navigation
${XPATH_SERVICE_MENU}                //li[@id='SERVICE']/a
${XPATH_SERVICE_REQUEST_SUBMENU}     //li[@id='SERVICEREQUEST']/a

# Service Request Menu Items
${XPATH_EMPLOYMENT_REQUEST}          //li[@id='EMPLOYMENTREQUEST']/a
${XPATH_PERSONAL_DETAILS}            //li[@id='PERSONALDETAILS']/a
${XPATH_REFUND_MAKER}                //li[@id='REFUNDMAKER']/a
${XPATH_VALUATION_SR}                //li[@id='VALUATIONSR']/a
${XPATH_ADD_COLLATERAL_SR}           //li[@id='ADDCOLLATERALSR']/a
${XPATH_CHANGE_ADDRESS}              //li[@id='CHANGEADDRESS']/a
${XPATH_CINET_CANCEL}                //li[@id='CINETCANCEL']/a
${XPATH_DEBT_ACK_CANCEL}             //li[@id='DEBTACKCANCEL']/a
${XPATH_REPAYMENT_MODE_SR}           //li[@id='REPAYMENTMODESR']/a
${XPATH_IDENTIFICATION}              //li[@id='IDENTIFICATION']/a
${XPATH_ADD_DOCUMENTS}               //li[@id='ADDDOCUMENTSMENUCODE']/a
${XPATH_SKIP_PAYMENT}                //li[@id='SKIPPAYMENT']/a
${XPATH_PARTIAL_SETTLEMENT}          //li[@id='PARTIALSETTLEMENT']/a
${XPATH_COMM_LOAN_EXTEN}             //li[@id='COMMLOANEXTENBALLON']/a
${XPATH_RETAIL_LOAN_AMEND}           //li[@id='RETAILLOANAMED']/a
${XPATH_ADD_GUARANTOR_SR}            //li[@id='ADDGUARANTORSR']/a
${XPATH_BLOCK_UNBLOCK_SERVICE}       //li[@id='BLOCKUNBLOCKSERVICE']/a
${XPATH_FULL_INSURANCE_RENEW}        //li[@id='FULLINSURANCERENEW']/a
${XPATH_INSURANCE_CANCEL}            //li[@id='INSURANCERECANCEL']/a
${XPATH_DELETE_GUARANTOR_SR}         //li[@id='DELETEGUARANTORSR']/a
${XPATH_TOTAL_LOSS}                  //li[@id='TOTALLOSS']/a
${XPATH_CHARGES_WAIVER}              //li[@id='CHARGESWAIVER']/a
${XPATH_DECEASED_FRAUD_SR}           //li[@id='DECEASEDFRAUDSR']/a
${XPATH_LEGAL_ACTION_SR}             //li[@id='LEGALACTIONSR']/a
${XPATH_CANCEL_DEAL_REQUEST}         //li[@id='CANCELDEALREQUEST']/a

# ── Customer Search Page ────────────────────────────────
# Form: id=commonSearchForm  action=viewServiceRCustSearch
${XPATH_SEARCH_FORM}                 //form[@id='commonSearchForm']

# Row 1 search fields
${XPATH_CUSTOMER_ID_INPUT}           //div[@id='cifNoDiv']//input[@id='cifNo']
${XPATH_CUSTOMER_NAME_INPUT}         //div[@id='custNameP']//input[@id='custName']
${XPATH_ACCOUNT_NO_INPUT}            //input[@id='accountNumber']
${XPATH_NATIONAL_ID_TYPE_DROPDOWN}   //div[@id='nationalIdTypeDropDownDiv']//select[@id='nationalIdType']

# Row 2 search fields
${XPATH_NATIONAL_ID_INPUT}           //div[@id='nationalIdP']//input[@id='nationalId']
${XPATH_CINET_REF_INPUT}             //div[@id='cinetRefNoDiv']//input[@id='cinetRefNo']
${XPATH_APPLICATION_NO_INPUT}        //input[@id='applicationNo']
${XPATH_VEHICLE_REG_INPUT}           //input[@id='vehicleRegNo']

# Row 3 search fields
${XPATH_CHASSIS_NO_INPUT}            //input[@id='chasisNo']
${XPATH_MOBILE_INPUT}                //div[@id='mobileNoDiv']//input[@id='mobileNo']
${XPATH_EMAIL_INPUT}                 //input[@id='emailId']
${XPATH_SEARCH_BTN}                  //button[@id='serviceCustSearch']

# Account Information Section
${XPATH_ACCOUNT_INFO_DIV}            //div[@id='accountInfo']
${XPATH_ACCOUNT_LIST_DIV}            //div[@id='accountList']
${XPATH_ACCOUNT_RADIO_BTN}           //input[@type='radio'][@name='accountNumber']
${XPATH_PROCEED_BTN}                 //button[@id='proceedAccData']

# Change Address Form (Inside iframe)
${XPATH_CUST_TYPE}                   //div[@id='custTypeDiv']//select[@id='custType']
${XPATH_FETCH_CUST_DETAILS}          //button[@id='fetchCustDetails']
${XPATH_CUST_NAME}                   //div[@id='custNameDiv']//select[@id='custName']
${XPATH_CIF_NO}                      //div[@id='cifNoDiv']//input[@id='cifNo']
${XPATH_ADDRESS_TYPE}                //div[@id='addressTypeDropDownDiv']//select[@id='addressType']
${XPATH_ACTIVE_INACTIVE_TYPE}        //div[@id='activeInActiveDropDownDiv']//select[@id='activeInActiveType']
${XPATH_ID_TYPE}                     //div[@id='idTypeDiv']//select[@id='idType']
${XPATH_ID_NUMBER}                   //div[@id='idNumberDiv']//input[@id='idNumber']
${XPATH_FETCH_DETAILS}               //button[@id='fetchDetails']
${XPATH_ADDRESS_START_DATE}          //div[@id='addressStartDateDiv']//input[@id='addressStartDate']
${XPATH_COUNTRY}                     //div[@id='countryDiv']//select[@id='country']
${XPATH_DISTRICT}                    //div[@id='districtDiv']//select[@id='district']
${XPATH_AREA}                        //div[@id='areaDiv']//select[@id='area']
${XPATH_BLOCK}                       //div[@id='blockDiv']//input[@id='block']
${XPATH_STREET}                      //div[@id='streetDiv']//input[@id='street']
${XPATH_BUILDING}                    //div[@id='buildingDiv']//input[@id='building']
${XPATH_UNIT_TYPE}                   //div[@id='unitTypeDiv']//select[@id='unitType']
${XPATH_UNIT_NO}                     //div[@id='unitNoDiv']//input[@id='unitNo']
${XPATH_FLOOR}                       //div[@id='floorDiv']//input[@id='floor']
${XPATH_ADDRESS_LINE1}               //div[@id='addressLine1Div']//input[@id='addressLine1']
${XPATH_DOCUMENT_DATA}               //input[@id='documentData']
${XPATH_VIEW_UPLOADED_DOC}           //a[@id='viewUploadedDoc']
${XPATH_SMART_CARD_YES}              //input[@id='smartCardReaderConsentY']
${XPATH_SMART_CARD_NO}               //input[@id='smartCardReaderConsentN']
${XPATH_FETCH_DETAILS_BTN}           //div[@id='fetchDetailsDiv']//button[@id='fetchDetails']
${XPATH_PERM_ADDR_SAME_AS_RES}       //input[@id='isPermantAdd']
${XPATH_PERM_ADDR_HIDDEN}            //input[@id='isPermantAddHidden']
${XPATH_BIZ_ADDR_SAME_AS_RES}        //input[@id='isBusinessAdd']
${XPATH_BIZ_ADDR_HIDDEN}             //input[@id='isBusinessAddHidden']
${XPATH_REQUEST_FORM_DATA}           //input[@id='requestFormData']
${XPATH_UPLOAD_REQUEST_FORM_BTN}     //button[@id='uplaodDocRequestForm']
${XPATH_VIEW_REQUEST_FORM}           //a[@id='viewRequestFormCheque']
${XPATH_SAVE_BTN}                    //button[@id='changeAddressDetailsSubmit']
${XPATH_RESET_BTN}                   //button[@id='reset']

# Move to Next Form Fields
${XPATH_GROUP_NAME}                  //select[@id='grpName']
${XPATH_ASSIGN_USER}                 //select[@id='assignUser']
${XPATH_MAKER_REMARKS}               //textarea[@id='makerRemarks']
${XPATH_MOVE_TO_NEXT_SUBMIT}         //button[@id='moveToNextSubmit']

# Header Navigation Items
${XPATH_LOGOUT}                      //a[@class='item-logout']
${XPATH_SERVICE_REQUEST_INBOX}       //a[@class='item-servieSummary']

# Service Request Inbox Table
${XPATH_INBOX_TABLE}                 //table[@id='dt-authdata']

# Action Buttons (Page Level)
${XPATH_SEND_FOR_VERIFICATION_BTN}   //li[@id='NextSR']/a
${XPATH_APPROVE_BTN}                 //li[@id='ApproveSR']/a
${XPATH_REJECT_BTN}                  //li[@id='RejectSR']/a
${XPATH_RETURN_BTN}                  //li[@id='appealSR']/a
${XPATH_CLOSE_BTN}                   //li[@id='closeSR']/a
