import xlsxwriter

# Create a new Excel file
workbook = xlsxwriter.Workbook('../../data/change_address.xlsx')
worksheet = workbook.add_worksheet('Address Data')

# Create a hidden sheet for dropdown lists
lists_sheet = workbook.add_worksheet('Lists')
lists_sheet.hide()

# Define dropdown options
action_options = ['Create', 'Edit', 'Skip']
customer_type_options = ['Main Applicant', 'Joint Applicant', 'Guarantor']
status_options = ['Active', 'InActive']

# District options
district_options = ['HAWALLI', 'AHMADI', 'CAPITAL', 'FARWANIYA', 'JAHRA', 'MUBARAK AL-KABEER']

# Area options organized by district (comprehensive list)
# Note: In Excel, we'll show all areas. User should select area that matches their district.
area_options = [
    # HAWALLI District areas
    'HAWALLI', 'SALMIYA', 'JABRIYA', 'BAYAN', 'MISHREF', 'SALWA', 'RUMAITHIYA', 'SHAAB',
    # AHMADI District areas
    'AHMADI', 'FAHAHEEL', 'MANGAF', 'FINTAS', 'ABU HALIFA', 'SABAH AL SALEM',
    # CAPITAL District areas
    'ABDULLA AL-SALEM', 'ADAILIYA', 'BNEID AL-QAR', 'DAIYA', 'DASMA', 'DOHA', 'FAIHA', 'KAIFAN', 'KHALDIYA', 'MANSOURIYA', 'NUZHA', 'QADSIYA', 'QIBLA', 'SHARQ', 'SHUWAIKH', 'SURRA',
    # FARWANIYA District areas
    'FARWANIYA', 'JLEEB AL-SHUYOUKH', 'KHAITAN', 'ARDIYA', 'FERDOUS', 'REHAB',
    # JAHRA District areas
    'JAHRA', 'QASR', 'SULAIBIYA', 'NAEEM', 'OYOUN',
    # MUBARAK AL-KABEER District areas
    'MUBARAK AL-KABEER', 'QURAIN', 'SABAH AL-SALEM', 'ABU FTAIRA', 'FUNAITEES'
]

unit_type_options = ['Apartment', 'Villa']

# Write dropdown options to Lists sheet
lists_sheet.write_column('A1', action_options)
lists_sheet.write_column('B1', customer_type_options)
lists_sheet.write_column('C1', status_options)
lists_sheet.write_column('D1', district_options)
lists_sheet.write_column('E1', area_options)
lists_sheet.write_column('F1', unit_type_options)

# Define named ranges for dropdowns
workbook.define_name('ActionList', '=Lists!$A$1:$A$3')
workbook.define_name('CustomerTypeList', '=Lists!$B$1:$B$3')
workbook.define_name('StatusList', '=Lists!$C$1:$C$2')
workbook.define_name('DistrictList', '=Lists!$D$1:$D$6')
workbook.define_name('AreaList', f'=Lists!$E$1:$E${len(area_options)}')
workbook.define_name('UnitTypeList', '=Lists!$F$1:$F$2')

# Format for headers
header_format = workbook.add_format({
    'bold': True,
    'bg_color': '#4472C4',
    'font_color': 'white',
    'border': 1
})

# Format for section headers
section_format = workbook.add_format({
    'bold': True,
    'bg_color': '#FFC000',
    'border': 1
})

# Format for data cells
data_format = workbook.add_format({
    'border': 1
})

# Format for instruction
instruction_format = workbook.add_format({
    'italic': True,
    'font_color': 'red',
    'border': 0
})

# Set column widths
worksheet.set_column('A:A', 15)  # Action
worksheet.set_column('B:B', 18)  # Customer Type
worksheet.set_column('C:C', 12)  # Status
worksheet.set_column('D:D', 15)  # Living Since
worksheet.set_column('E:E', 20)  # District
worksheet.set_column('F:F', 20)  # Area
worksheet.set_column('G:L', 12)  # Block to Floor

# Write headers in row 1
headers = ['Action', 'Customer Type', 'Status', 'Living Since', 'District', 'Area', 'Block', 'Street', 'Building', 'Unit Type', 'Unit No', 'Floor']
for col, header in enumerate(headers):
    worksheet.write(0, col, header, header_format)

# ========== RESIDENTIAL SECTION ==========
# Row 2: Section header
worksheet.write('A2', 'RESIDENTIAL', section_format)

# Row 3: Data with dropdowns
worksheet.data_validation('A3', {'validate': 'list', 'source': '=ActionList'})
worksheet.data_validation('B3', {'validate': 'list', 'source': '=CustomerTypeList'})
worksheet.data_validation('C3', {'validate': 'list', 'source': '=StatusList'})
worksheet.data_validation('E3', {'validate': 'list', 'source': '=DistrictList'})
worksheet.data_validation('F3', {'validate': 'list', 'source': '=AreaList'})
worksheet.data_validation('J3', {'validate': 'list', 'source': '=UnitTypeList'})

# Write default values for RESIDENTIAL
worksheet.write('A3', 'Edit', data_format)
worksheet.write('B3', 'Main Applicant', data_format)
worksheet.write('C3', 'Active', data_format)
worksheet.write('D3', '01/01/2020', data_format)
worksheet.write('E3', 'HAWALLI', data_format)
worksheet.write('F3', 'SALMIYA', data_format)
worksheet.write('G3', '1', data_format)
worksheet.write('H3', '10', data_format)
worksheet.write('I3', 'Building A', data_format)
worksheet.write('J3', 'Apartment', data_format)
worksheet.write('K3', '101', data_format)
worksheet.write('L3', '1', data_format)

# Empty row 4
worksheet.write('A4', '', data_format)

# ========== PERMANENT SECTION ==========
# Row 5: Empty
worksheet.write('A5', '', data_format)

# Row 6: Section header
worksheet.write('A6', 'PERMANENT', section_format)

# Row 7: Data with dropdowns
worksheet.data_validation('A7', {'validate': 'list', 'source': '=ActionList'})
worksheet.data_validation('B7', {'validate': 'list', 'source': '=CustomerTypeList'})
worksheet.data_validation('C7', {'validate': 'list', 'source': '=StatusList'})
worksheet.data_validation('E7', {'validate': 'list', 'source': '=DistrictList'})
worksheet.data_validation('F7', {'validate': 'list', 'source': '=AreaList'})
worksheet.data_validation('J7', {'validate': 'list', 'source': '=UnitTypeList'})

# Write default values for PERMANENT
worksheet.write('A7', 'Create', data_format)
worksheet.write('B7', 'Main Applicant', data_format)
worksheet.write('C7', 'Active', data_format)
worksheet.write('D7', '01/01/2019', data_format)
worksheet.write('E7', 'HAWALLI', data_format)
worksheet.write('F7', 'JABRIYA', data_format)
worksheet.write('G7', '2', data_format)
worksheet.write('H7', '20', data_format)
worksheet.write('I7', 'Building B', data_format)
worksheet.write('J7', 'Villa', data_format)
worksheet.write('K7', '201', data_format)
worksheet.write('L7', '2', data_format)

# Empty row 8
worksheet.write('A8', '', data_format)

# ========== BUSINESS SECTION ==========
# Row 9: Empty
worksheet.write('A9', '', data_format)

# Row 10: Section header
worksheet.write('A10', 'BUSINESS', section_format)

# Row 11: Data with dropdowns
worksheet.data_validation('A11', {'validate': 'list', 'source': '=ActionList'})
worksheet.data_validation('B11', {'validate': 'list', 'source': '=CustomerTypeList'})
worksheet.data_validation('C11', {'validate': 'list', 'source': '=StatusList'})
worksheet.data_validation('E11', {'validate': 'list', 'source': '=DistrictList'})
worksheet.data_validation('F11', {'validate': 'list', 'source': '=AreaList'})
worksheet.data_validation('J11', {'validate': 'list', 'source': '=UnitTypeList'})

# Write default values for BUSINESS
worksheet.write('A11', 'Skip', data_format)
worksheet.write('B11', 'Main Applicant', data_format)
worksheet.write('C11', 'Active', data_format)
worksheet.write('D11', '01/01/2021', data_format)
worksheet.write('E11', 'AHMADI', data_format)
worksheet.write('F11', 'AHMADI', data_format)
worksheet.write('G11', '3', data_format)
worksheet.write('H11', '30', data_format)
worksheet.write('I11', 'Building C', data_format)
worksheet.write('J11', 'Apartment', data_format)
worksheet.write('K11', '301', data_format)
worksheet.write('L11', '3', data_format)

# Add instruction note
worksheet.write('A13', 'NOTE: Select District first, then select Area that belongs to that District', instruction_format)

workbook.close()
print("Excel file with dropdowns created successfully!")
print("File location: ../../data/change_address.xlsx")
print("\nColumn Order: Action | Customer Type | Status | Living Since | District | Area | Block | Street | Building | Unit Type | Unit No | Floor")
print("\nDropdown fields:")
print("- Action: Create, Edit, Skip")
print("- Customer Type: Main Applicant, Joint Applicant, Guarantor")
print("- Status: Active, InActive")
print("- District: HAWALLI, AHMADI, CAPITAL, FARWANIYA, JAHRA, MUBARAK AL-KABEER")
print("- Area: Comprehensive list of all areas (select area matching your district)")
print("- Unit Type: Apartment, Villa")
