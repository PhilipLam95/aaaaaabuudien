using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace BUUDIEN
{
    public partial class PhieuRutTien : Form
    {
        private DataTable maphieu;
        
        public PhieuRutTien()
        {
            InitializeComponent();
        }

        
        
        DataTable dt = new DataTable();
        public string _button1
        {
            set { label11.Text = value; }
        }
        private void PhieuRutTien_Load(object sender, EventArgs e)
        {
            AddMaPhieutoCompo();
            comboBox1.SelectedIndex = 0;
            
            btnGhi.Enabled = false;
            button1.PerformClick();
            btnTienlai.PerformClick();
            magdvTBOX.Hide();
            btnGhi.Enabled = false;
            label11.Text = DBAcess.MAGDV; 
        }


     

        private void AddMaPhieutoCompo()
        {
            maphieu = DBAcess.ExecuteQuery("SP_LAYMAPHIEU");
            comboBox1.Items.Clear();
            foreach (DataRow s in maphieu.Rows)
            {
                comboBox1.Items.Add(s[1]);
            }
            comboBox1.SelectedIndex = 0;
        }

        private void AddThongTin()
        {
           /* thongtin = DBAcess.ExecuteQuery("SP_LAYDULIEUFORPHIEURUT");
            hotenTBOX.Text = "";
            foreach (DataRow s in thongtin.Rows)
            {
                hotenTBOX.Rows[0].Cells["HOTEN"]

            }
            comboBox1.SelectedIndex = 0;*/
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
                
        

        }

        private void btnLapPhieu_Click(object sender, EventArgs e)
        {
            this.Hide();
            PhieuRutTien f1 = new PhieuRutTien();
            f1.Show();
        }

        private void button1_Click(object sender, EventArgs e)
        {
          
          
                 string maPH = comboBox1.SelectedItem.ToString();
                 string[] name = { "@MAPHIEU" };
                 object[] param = { maPH };      
                 DataTable thongtin = DBAcess.ExecuteQuery("SP_LAYDULIEUFORPHIEURUT", name, param, 1);
                  /*SqlCommand cmd = new SqlCommand("SP_LAYDULIEUFORPHIEURUT", conn);
                  cmd.CommandType = CommandType.StoredProcedure;*/
                
                 hotenTBOX.DataBindings.Add("TEXT", thongtin, "HOTEN");        
                 cmndTBOX.DataBindings.Add("TEXT", thongtin, "CMND");
                 diachiTBOX.DataBindings.Add("TEXT", thongtin, "DIACHI");
                 ngaycapTBOX.DataBindings.Add("TEXT", thongtin, "NGAYCAP");
                 madichvuTBOX.DataBindings.Add("TEXT", thongtin, "MADV");
                 dichvuTBOX.DataBindings.Add("TEXT", thongtin, "TENDV");
                 kyhanTBOX.DataBindings.Add("TEXT", thongtin, "KYHAN");
                 ngayguiTBOX.DataBindings.Add("TEXT", thongtin, "NGAYGUI");              
                 ngaydenhanTBOX.DataBindings.Add("TEXT", thongtin, "NGAYDENHAN");
                 laisuatTBOX.DataBindings.Add("TEXT", thongtin, "LAISUAT");
                 sotienguiTBOX.DataBindings.Add("TEXT", thongtin, "SOTIEN_GUI");
                 magdvTBOX.DataBindings.Add("TEXT", thongtin, "MAGDV_LPGUI");
                
                
            /* clear databindings */
                hotenTBOX.DataBindings.Clear();
                cmndTBOX.DataBindings.Clear();
                diachiTBOX.DataBindings.Clear();
                ngaycapTBOX.DataBindings.Clear();
                madichvuTBOX.DataBindings.Clear();
                dichvuTBOX.DataBindings.Clear();
                kyhanTBOX.DataBindings.Clear();
                ngayguiTBOX.DataBindings.Clear();
                ngaydenhanTBOX.DataBindings.Clear();
                laisuatTBOX.DataBindings.Clear();
                sotienguiTBOX.DataBindings.Clear();
                magdvTBOX.DataBindings.Clear();

                 /* enable text box */

                 hotenTBOX.Enabled = false;
                 cmndTBOX.Enabled = false;
                 diachiTBOX.Enabled = false;
                 ngaycapTBOX.Enabled = false;
                 madichvuTBOX.Enabled = false;
                 dichvuTBOX.Enabled = false;
                 kyhanTBOX.Enabled = false;
                 ngayguiTBOX.Enabled = false;
                 ngaydenhanTBOX.Enabled = false;
                 laisuatTBOX.Enabled = false;
                 sotienguiTBOX.Enabled = false;
                 btnTienlai.Enabled = true;
            
        }

        private void makhachhangTBOX_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnGhi_Click(object sender, EventArgs e)
        {
            try
            {

                /*Double value;
                if (Double.TryParse(tongtienrutTBOX.Text, out value))
                    tongtienrutTBOX.Text = String.Format(System.Globalization.CultureInfo.CurrentCulture, "{0:C2}", value);
                else
                    tongtienrutTBOX.Text = String.Empty;
                */
               


                    string maPH = comboBox1.SelectedItem.ToString();
                    string maGDV = magdvTBOX.Text.ToString();
                    DateTime ngRut = DateTime.Parse(dateTimePicker1.Value.ToString());
                    dateTimePicker1.Text = ngRut.ToShortDateString();
                    string sotienGui = sotienguiTBOX.Text.ToString();
                    string tienlai = tienlaiTBOX.Text.ToString();
                    string sotienRut = tongtienrutTBOX.Text.ToString();
                 
                   /* MessageBox.Show("toi day");
                    string.Format("{#.0000}",sotienRut);
                    MessageBox.Show("toi day");*/
                    /*string sotienRut = String.Format("{0:C}", sotienRut);*/
                    
                

                    string[] name = { "@MAPHIEU", "@MAGDV_LPRUT", "@NGAYRUT", "@SOTIENGUI", "@TIENLAI","@SOTIEN_RUT" };
                    object[] param = { maPH, maGDV, ngRut, sotienGui, tienlai, sotienRut};

                    int x = DBAcess.ExecuteNonQuery("SP_THEMPHIEURUT", name, param, 6);
                    if (x == 0)
                    {
                        MessageBox.Show("RUT TIEN THANH CONG");
                        tongtienrutTBOX.DataBindings.Clear();
                        tienlaiTBOX.DataBindings.Clear();
                        sotienguiTBOX.DataBindings.Clear();
                    }
                    if (x == 1)
                    {
                        MessageBox.Show("TIEN BAN RUT QUA LON");
                    }                    
                   
                    
                    
                    
                
            }
            catch
            {
                MessageBox.Show(" loi roi");
            }            
           
        }

        private void btnTienlai_Click(object sender, EventArgs e)
        {
            try
            {

                  /* Chuyen kieu string sang date time */
                    DateTime ngGUI = DateTime.Parse(ngayguiTBOX.Text.ToString());
                    ngayguiTBOX.Text = ngGUI.ToString("dd/MM/yyyy");
                  

                  /*  DateTime ngGUI = DateTime.Parse(DateTime.Now.ToShortDateString());
                    string ngayguiTBOX = ngGUI.Day + "/" + ngGUI.Month + "/" + ngGUI.Year;
                   MessageBox.Show(ngayguiTBOX);*/
               
                    DateTime ngDenHan = DateTime.Parse(ngaydenhanTBOX.Text.ToString());
                    ngaydenhanTBOX.Text = ngDenHan.ToString("dd/MM/yyyy");
                    

                    DateTime ngRut = DateTime.Parse(dateTimePicker1.Value.ToString());
                    dateTimePicker1.Text = ngRut.ToShortDateString();
                    
                    

                /*string maDV = madichvuTBOX.Text.ToString();*/
                /*string ngGUI = ngayguiTBOX.Text.ToString();*/
                /*string ngDenHan = ngaydenhanTBOX.Text.ToString();*/
                string laiSuat = laisuatTBOX.Text.ToString();
                string sotienGui = sotienguiTBOX.Text.ToString();
                /*string ngRut = dateTimePicker1.Value.ToString();*/
                string kyHan = kyhanTBOX.Text.ToString();
               

                // truyen bien vao thuoc tinh khai bao trong sp
                string[] name = { "@NGAYGUI", "@NGAYDENHAN", "@NGAYRUT", "@LAISUAT" ,"@SOTIENGUI" ,"@KYHAN"};
                object[] param = { ngGUI, ngDenHan, ngRut, laiSuat, sotienGui, kyHan };
                DataTable tien_lai = DBAcess.ExecuteQuery("SP_TINHLAISUAT", name, param, 6);
                
                

                ngayguiTBOX.DataBindings.Clear();
                ngaydenhanTBOX.DataBindings.Clear();
                dateTimePicker1.DataBindings.Clear();
                MessageBox.Show("TOI DAY");
                tienlaiTBOX.DataBindings.Add("TEXT", tien_lai, "TIENLAI");
                
                tienlaiTBOX.DataBindings.Clear();
                
               

                
                tienlaiTBOX.Enabled = false;
                btnGhi.Enabled = true;
                btnTienlai.Enabled = false;
   
            }
            catch 
            {
                MessageBox.Show("co loi");
            }



        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void tienlaiTBOX_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void magdvTBOX_TextChanged(object sender, EventArgs e)
        {
           
        }

        

       

        private void tongtienrutTBOX_MaskInputRejected(object sender, MaskInputRejectedEventArgs e)
        {
            int n = Int32.Parse(tongtienrutTBOX.Text);//lay gia tri cua textbox
            if (n < 1)
            {
                MessageBox.Show("moi ban nhap lai so tien");
            }
            if (n > 10)
            {
                MessageBox.Show("So tien toi da rut chi duoc 1 tỷ");
            }
        }
        

        private void tongtienrutTBOX_KeyPress_1(object sender, KeyPressEventArgs e)
        {
            if (!Char.IsDigit(e.KeyChar) && !Char.IsControl(e.KeyChar))
            {
                e.Handled = true;
                MessageBox.Show("TONG TIEN phai  là kieu  số ", "Thông Báo ");
            }
            //Char.IsDigit(e.KeyChar) --> kiểm tra xem phím vừa nhập vào textbox có phải là ký tự số hay không, hàm này trả về kiểu bool
            /*Char.IsContro(e.KeyChar) --> kiểm tra xem phím vừa nhập vào textbox có phải là các ký tự điều khiển (các phím mũi tên,
              Delete,Insert,backspace,space bar) hay không, mục đích dùng hàm này là để cho phép người dùng xóa số trong trường hợp nhập sai.*/
            
        }
      

      
    }
}
 