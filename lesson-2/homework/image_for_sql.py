import pyodbc

con_str = "DRIVER={SQL SERVER}; SERVER=DESKTOP-1C79NNN\SQLEXPRESS; DATABASE=master; Trusted_connection=yes;"

con = pyodbc.connect(con_str)
cursor = con.cursor()
cursor.execute(
    """
    SELECT * FROM photos
"""
) 

row = cursor.fetchone()

img_id, img_data = row 
with open ('apple.png', 'wb') as file:
    file.write(img_data) 