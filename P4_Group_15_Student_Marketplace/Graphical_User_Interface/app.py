import streamlit as st
import pyodbc
import pandas as pd


try:
    # Database Connection
    conn = pyodbc.connect('DRIVER={SQL Server};'
                        'SERVER=;'
                        'DATABASE=;'
                        'Trusted_Connection=yes;')

    # Function to read data from a specific table
    def read_data(table):
        query = f"SELECT * FROM {table}"
        data = pd.read_sql(query, conn)
        return data

    # Function to insert data into STUDENT table
    def insert_student(student_id, first_name, last_name, email, phone, date_of_birth, address, zip_code):
        cursor = conn.cursor()
        date_of_birth_str = date_of_birth.strftime('%Y-%m-%d')  # Convert to string
        sql = """INSERT INTO STUDENT (Student_ID, First_Name, Last_Name, Email, Phone, Date_of_Birth, Address, Zip_Code) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)"""
        cursor.execute(sql, (student_id, first_name, last_name, email, phone, date_of_birth_str, address, zip_code))
        conn.commit()

    # Function to insert data into ITEM table
    def insert_item(item_id, seller_user_id, item_name, item_desc, item_category, item_price, item_cond, mfg_date):
        cursor = conn.cursor()
        if item_cond in ['New', 'Refurbished', 'Like-New', 'Good', 'Acceptable', 'Damaged']:
            mfg_date_str = mfg_date.strftime('%Y-%m-%d') if mfg_date is not None else None
            sql = """INSERT INTO ITEM (Item_ID, Seller_User_ID, Item_Name, Item_Desc, Item_Category, Item_Price, Item_Cond, Mfg_Date) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)"""
            cursor.execute(sql, (item_id, seller_user_id, item_name, item_desc, item_category, item_price, item_cond, mfg_date_str))
            conn.commit()
        else:
            st.error("Invalid Item Condition")

    # Function to insert data into LISTING table
    def insert_listing(listing_id, listing_seller_id, date_posted, location, is_live, title):
        cursor = conn.cursor()
        if is_live in ['TRUE', 'FALSE']:
            # Convert date_posted to string format, if it's not None
            date_posted_str = date_posted.strftime('%Y-%m-%d') if date_posted is not None else None
            sql = """INSERT INTO LISTING (Listing_ID, Listing_Seller_ID, Date_Posted, Location, IsLive, Title) 
                    VALUES (?, ?, ?, ?, ?, ?)"""
            cursor.execute(sql, (listing_id, listing_seller_id, date_posted_str, location, is_live, title))
            conn.commit()
        else:
            st.error("Invalid IsLive Value")


    # Function to update data in any table
    def update_data(table, primary_key_column, primary_key, column_to_update, new_value):
        cursor = conn.cursor()
        sql = f"UPDATE {table} SET {column_to_update} = ? WHERE {primary_key_column} = ?"
        cursor.execute(sql, (new_value, primary_key))
        conn.commit()

    # Function to delete data from any table
    def delete_data(table, primary_key_column, primary_key):
        cursor = conn.cursor()
        sql = f"DELETE FROM {table} WHERE {primary_key_column} = ?"
        cursor.execute(sql, primary_key)
        conn.commit()


            
    # Streamlit UI
    st.title('Student Marketplace Database Operations')

    # Choose operation
    operation = st.sidebar.selectbox("Choose Operation", ["Read", "Insert", "Update", "Delete"])
    table_name = st.sidebar.selectbox("Choose Table", ["STUDENT", "ITEM", "LISTING"])

    if operation == "Read":
        st.dataframe(read_data(table_name))

    elif operation == "Insert":
        if table_name == "STUDENT":
            with st.form("Insert Student Form"):
                student_id = st.text_input("Student ID")
                first_name = st.text_input("First Name")
                last_name = st.text_input("Last Name")
                email = st.text_input("Email")
                phone = st.text_input("Phone")
                date_of_birth = st.date_input("Date of Birth")
                address = st.text_input("Address")
                zip_code = st.number_input("Zip Code", step=1)
                submit_button = st.form_submit_button("Insert")
                
                if submit_button:
                    insert_student(student_id, first_name, last_name, email, phone, date_of_birth, address, zip_code)
                    st.success("Student Added Successfully!")
                
        elif table_name == "ITEM":
            with st.form("Insert Item Form"):
                item_id = st.text_input("Item ID")
                seller_user_id = st.number_input("Seller User ID", step=1)
                item_name = st.text_input("Item Name")
                item_desc = st.text_area("Item Description")
                item_category = st.number_input("Item Category", step=1)
                item_price = st.number_input("Item Price", step=1)
                item_cond = st.selectbox("Item Condition", ["New", "Refurbished", "Like-New", "Good", "Acceptable", "Damaged"])
                mfg_date = st.date_input("Manufacturing Date")
                submit_button = st.form_submit_button("Insert Item")
                
                if submit_button:
                    insert_item(item_id, seller_user_id, item_name, item_desc, item_category, item_price, item_cond, mfg_date)
                    st.success("Item Added Successfully!")

        elif table_name == "LISTING":
            with st.form("Insert Listing Form"):
                listing_id = st.text_input("Listing ID")
                listing_seller_id = st.number_input("Listing Seller ID", step=1)
                date_posted = st.date_input("Date Posted")
                location = st.text_input("Location")
                is_live = st.selectbox("Is Live", ["TRUE", "FALSE"])
                title = st.text_input("Title")
                submit_button = st.form_submit_button("Insert Listing")
                
                if submit_button:
                    insert_listing(listing_id, listing_seller_id, date_posted, location, is_live, title)
                    st.success("Listing Added Successfully!")

    elif operation == "Update":
        with st.form("Update Form"):
            # Common fields for update
            primary_key = st.text_input(f"{table_name} ID to Update")
            column_to_update = st.text_input("Column Name to Update")
            new_value = st.text_input("New Value")
            submit_button = st.form_submit_button("Update")
            if submit_button:
                update_data(table_name, f"{table_name}_ID", primary_key, column_to_update, new_value)
                st.success(f"{table_name} Updated Successfully!")
                st.dataframe(read_data(table_name))  # Show updated table

    elif operation == "Delete":
        with st.form("Delete Form"):
            primary_key = st.text_input(f"{table_name} ID to Delete")
            submit_button = st.form_submit_button("Delete")
            if submit_button:
                delete_data(table_name, f"{table_name}_ID", primary_key)
                st.success(f"{table_name} Deleted Successfully!")
                st.dataframe(read_data(table_name))  # Show updated table

    # Close the connection
    conn.close()

except Exception as e:
    st.error("Error connecting to database")
    st.write(e)