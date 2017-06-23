using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Configuration;

namespace BUUDIEN
{
    public partial class FrmDangNhap : Form
    {
    

        public FrmDangNhap()
        {
            InitializeComponent();
        }

        public string _btnLogin
        { 
            get { return btnLogin.Text; }
        }
        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void FrmDangNhap_Load(object sender, EventArgs e)
        {
            magdvTBOX.Hide();
        }

        private bool DangNhap_GDV(string username, string password)
        { 

            DBAcess.USERNAME = username;
            DBAcess.PASSWORD = password;
            DBAcess.Refresh();

           
                string[] name = { "@LOGINNAME" };
                object[] param = { username };
                SqlDataReader reader = DBAcess.ExecSqlDataReader("SP_DANGNHAP", name, param, 1);
                
                if (reader == null)
                {
                    return false;
                }
                   reader.Read();
                   if (reader.HasRows)
                {
                   
                    /*Console.WriteLine(reader["MAGDV"].ToString() + reader["HOTEN"].ToString() + reader["ROLE"].ToString());
                    DBAcess.ROLE = reader["ROLE"].ToString();
                    DBAcess.HOTEN = reader["HOTEN"].ToString();
                    DBAcess.MAGDV = reader["MAGDV"].ToString();

                    string hoten = DBAcess.HOTEN = reader["HOTEN"].ToString();
                    MessageBox.Show("Dang Nhap Thanh Cong! Xin Chào: " + hoten);*/
                    string hoten = DBAcess.HOTEN = reader["HOTEN"].ToString();
                    string magdv = DBAcess.MAGDV = reader["MAGDV"].ToString();

                    magdvTBOX.Text = magdv;
                    PhieuRutTien fphieurut = new PhieuRutTien();
                    //Gán giá trị của thuộc tính _textbox1 của Form1 cho thuộc tính _textbox của Form2
                    fphieurut._button1 = _btnLogin;
                    
                   
                    

                    //Gán giá trị của thuộc tính _textbox1 của Form1 cho thuộc tính _textbox của Form2           
                    //Hiển thị Form2

                    MessageBox.Show("xin chào " + hoten);

                    this.Hide();
                    FrmChucNang fchucnang = new FrmChucNang();
                    fchucnang.Show();
                    DBAcess.Close();
                    reader.Close();
                    return true;



                }
                DBAcess.Close();
                return false ;
        }
        

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {

            if (textBox1.Text.Trim() == "")
            {
                MessageBox.Show("không được để trống Username");
                textBox1.Focus();
                return;
            }
            string username = textBox1.Text.Trim().ToUpper();
            string password = textBox2.Text.Trim();

            if (!DangNhap_GDV(username, password))
                MessageBox.Show("Sai USERNAME hoặc PASSWORD");
           

            /*SqlDataReader reader = DBAcess.ExecSqlDataReader("SP_DANGNHAP", name, param, 1);
            if (reader.Read())
            {
                Console.WriteLine(reader["MAGDV"].ToString() + reader["HOTEN"].ToString() + reader["ROLE"].ToString());
                DBAcess.ROLE = reader["ROLE"].ToString();
                DBAcess.HOTEN = reader["HOTEN"].ToString();
                DBAcess.MAGDV = reader["MAGDV"].ToString();

                string hoten = DBAcess.HOTEN = reader["HOTEN"].ToString();
                MessageBox.Show("Dang Nhap Thanh Cong! Xin Chào: " + hoten);

            }
            else
            {
                MessageBox.Show("Dang Nhap Sai");
            }
            */


        }

        private void button1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void magdvTBOX_TextChanged(object sender, EventArgs e)
        {
           
        }
    }
}
