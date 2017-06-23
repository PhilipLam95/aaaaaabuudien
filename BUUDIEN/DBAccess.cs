using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Windows.Forms;

namespace BUUDIEN
{
    static class DBAcess
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        /// 
        public static SqlConnection connection;

        public static String DATA_SOURCE = @"DELL-PC\SERVER";//địa chỉ cơ sở dữ liệu
        public static String INITIAL_CATALOG = "TKBUUDIEN";//tên cơ sở dữ liệu

        public static String USERNAME = "";//tài khoản
        public static String PASSWORD = "";//mật khẩu


        public static String HOTEN = "";
        public static String ROLE = "";
        public static String MAGDV = "";
        public static string connectionString;
        

        public static void Refresh()
        {
            connectionString = string.Format(@"Data Source=" + DATA_SOURCE + ";" + "Initial Catalog=" + INITIAL_CATALOG + ";"
                     + "Integrated Security=True" + ";" + "User ID=" + USERNAME + ";" + "password=" + PASSWORD + ";");
        }

        public static void Connect()
        {
            if (connection != null && connection.State == ConnectionState.Open)
                connection.Close();
            try
            {
                /*string connectionString = string.Format(@"Data Source=DELL-PC\SERVER;Initial Catalog=TKBUUDIEN;Integrated Security=True");
                connection = new SqlConnection(connectionString);
                connection.Open();
                return true;*/
                
                string connectionString = string .Format(@"Data Source=" + DATA_SOURCE + ";" + "Initial Catalog=" + INITIAL_CATALOG + ";"
                     + "Integrated Security=True" + ";" + "User ID=" + USERNAME + ";" + "password=" + PASSWORD + ";");
                
                connection = new SqlConnection(connectionString);
                connection.Open();
                


            }
           catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                
            }
        }

        public static void Close()
        {
            if (connection.State == ConnectionState.Open)
                connection.Close();
        }

        public static DataTable ExecuteQuery(string _cmd, string[] name = null, object[] value = null, int NoParam = 0,
            CommandType cmdType = CommandType.StoredProcedure)
        {
            try
            {
                DataTable dataTable;
                if (connection == null || connection.State == ConnectionState.Closed)
                {
                    Connect();
                }
                using (SqlCommand sqlCmd = new SqlCommand(_cmd, connection))
                {
                    for (int i = 0; i < NoParam; i++)
                    {
                        sqlCmd.Parameters.AddWithValue(name[i], value[i]);
                    }
                    sqlCmd.CommandType = cmdType;
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(sqlCmd);
                    dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    Close();
                }
                return dataTable;
            }
            catch (SqlException e)
            {
                MessageBox.Show(e.Message);
                Close();
                return null;
            }

        }

        public static SqlDataReader ExecSqlDataReader(string _cmd, string[] name = null, object[] value = null, int NoParam = 0,
                    CommandType cmdType = CommandType.StoredProcedure)
        {
            try
            {
                SqlDataReader reader;
                if (connection == null || connection.State == ConnectionState.Closed)
                    Connect();
                using (SqlCommand sqlCmd = new SqlCommand(_cmd, connection) { CommandType = CommandType.Text })
                {
                    for (int i = 0; i < NoParam; i++)
                    {
                        sqlCmd.Parameters.AddWithValue(name[i], value[i]);
                    }
                    sqlCmd.CommandType = cmdType;
                    reader = sqlCmd.ExecuteReader();
                }
                return reader;
            }
            catch (SqlException e)
            {
                MessageBox.Show(e.Message);
                Close();
                return null;
            }

        }

        public static int ExecuteNonQuery(string _cmd, string[] name = null, object[] value = null, int NoParam = 0,
            CommandType cmdType = CommandType.StoredProcedure)
        {
            int retval;
            if (connection == null || connection.State == ConnectionState.Closed)
            {
                Connect();
            }
            try
            {
                using (SqlCommand sqlCmd = new SqlCommand(_cmd, connection))
                {
                    for (int i = 0; i < NoParam; i++)
                    {
                        sqlCmd.Parameters.AddWithValue(name[i], value[i]);
                    }
                    SqlParameter retParam = new SqlParameter() { SqlDbType = SqlDbType.Int, ParameterName = "@retParam", Direction = ParameterDirection.ReturnValue };
                    sqlCmd.Parameters.Add(retParam);
                    sqlCmd.CommandType = cmdType;
                    sqlCmd.ExecuteNonQuery();
                    retval = (int)sqlCmd.Parameters["@retParam"].Value;
                    Close();
                }
            }
            catch (SqlException e)
            {
                MessageBox.Show(e.Message);
                Close();
                return -1;
            }
            return retval;
        }
       
    }
}
