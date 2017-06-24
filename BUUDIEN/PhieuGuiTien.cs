using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace BUUDIEN
{
    public partial class PhieuGuiTien : Form
    {
        private DataTable madichvu;
        private DataTable MaPhieu;
       
        public PhieuGuiTien()
        {
            InitializeComponent();
        }

        private void tinhngaydenhan()
        {
            DateTime ngGUI = DateTime.Parse(dateTimePicker1.Value.ToString());
            dateTimePicker1.Text = ngGUI.ToShortDateString();
            string kyhan = textBox8.Text.ToString();
            string []name = {"@NGAYGUI","@KYHAN"};
            object[] param = { ngGUI, kyhan };
            DataTable ngaydenhan = DBAcess.ExecuteQuery("SP_TINHNGAYDENHAN", name, param, 2);
            textBox1.DataBindings.Add("TEXT", ngaydenhan, "NGAYDENHAN");
            textBox1.DataBindings.Clear();

        }

        private void AddMaPhieutoCompo()
        {
            MaPhieu = DBAcess.ExecuteQuery("SP_LAYMAPHIEU");
            comboBox2.DataSource = MaPhieu;

            comboBox2.ValueMember = "MAPHIEU";



        }

        private void AddMaDichvuCompo()
        {
            madichvu = DBAcess.ExecuteQuery("SP_LAYMADICHVU");
            comboBox1.DataSource = madichvu;

            comboBox1.ValueMember = "MADV";
            
            
            
        }
        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void PhieuGuiTien_Load(object sender, EventArgs e)
        {
            AddMaDichvuCompo();
            AddMaPhieutoCompo();
            comboBox2.SelectedIndex = 0;
            comboBox1.SelectedIndex = 0;
            textBox1.Enabled = false;
            dateTimePicker1.Enabled = false;
            label14.Text = DBAcess.MAGDV;
            label15.Hide();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string maDV = comboBox1.SelectedValue.ToString();
           
            string[] name = { "@MADV" };
            object[] param = { maDV};
            
            DataTable thongtindichvu = DBAcess.ExecuteQuery("SP_LAYTHONGTINDICHVU", name, param, 1);
            textBox9.DataBindings.Add("TEXT", thongtindichvu, "TENDV");
            textBox9.DataBindings.Clear();
            textBox8.DataBindings.Add("TEXT", thongtindichvu, "KYHAN");
            textBox8.DataBindings.Clear();
            textBox10.DataBindings.Add("TEXT", thongtindichvu, "LAISUAT");
            textBox10.DataBindings.Clear();
            tinhngaydenhan();
           
            
           
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            string maphieu = comboBox2.SelectedValue.ToString();

            string[] name = { "@MAPHIEU" };
            object[] param = { maphieu };

            DataTable thongtindichvu = DBAcess.ExecuteQuery("SP_LAYTHONGTINKHACHANG", name, param, 1);
            textBox4.DataBindings.Add("TEXT", thongtindichvu, "HOTEN");
            textBox4.DataBindings.Clear();
            textBox5.DataBindings.Add("TEXT", thongtindichvu, "DIACHI");
            textBox5.DataBindings.Clear();
            textBox6.DataBindings.Add("TEXT", thongtindichvu, "NGAYCAP");
            textBox6.DataBindings.Clear();
            textBox7.DataBindings.Add("TEXT", thongtindichvu, "CMNDAN");
            textBox7.DataBindings.Clear();
            comboBox1.DataBindings.Add("TEXT", thongtindichvu, "MDV");
            comboBox1.DataBindings.Clear();
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Hide();
            PhieuGuiTien fguitien = new PhieuGuiTien();
            fguitien.Show();
        }

        private void dateTimePicker1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            this.Hide();
            FrmDangNhap f1 = new FrmDangNhap();
            FrmChucNang f2 = new FrmChucNang();
            f1.Show();
            f2.ShowDialog(f1);
            f2.Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
          
            string hoTen = textBox4.Text.ToString();
            string diaChi = textBox5.Text.ToString();          
            DateTime ngCap = DateTime.Parse(textBox6.Text.ToString());
            textBox6.Text = ngCap.ToString("dd/MM/yyyy");
            string CMNDAN = textBox7.Text.ToString();
            string maDV = comboBox1.Text.ToString();
            string maGDV_lpgui = label14.Text.ToString();
            string soTiengui = textBox11.Text.ToString();
            DateTime ngDenhan = DateTime.Parse(textBox6.Text.ToString());
            textBox6.Text = ngDenhan.ToString("dd/MM/yyyy");

            string[] name = { "@CMND","@HOTEN","@DIACHI" ,"@NGAYCAP","@MADV","@SOTIEN_GUI","@NGAYDENHAN","@MAGDV_LPGUI"};
            object[] param = { CMNDAN, hoTen, diaChi, ngCap, maDV, soTiengui, ngDenhan, maGDV_lpgui };
            DataTable thongtindichvu = DBAcess.ExecuteQuery("SP_THEMPHIEUGUI", name, param, 8);

            label15.DataBindings.Add("TEXT", thongtindichvu, "MAPHIEU");
            MessageBox.Show("Đã thêm thành công " + textBox11.Text + " "+"VDN vào phiếu gửi " + " "+ label15.Text.ToUpper());

             textBox4.DataBindings.Clear();
             textBox5.DataBindings.Clear();
             textBox6.DataBindings.Clear();
             textBox7.DataBindings.Clear();
             comboBox1.DataBindings.Clear();
             textBox11.DataBindings.Clear();
           /* string laiSuat =
           
            string ngdenHan =
            string maGDV_lpgui =*/

        }

        private void label15_Click(object sender, EventArgs e)
        {
            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn muốn xóa mã phiếu :"+ " "+comboBox2.Text , "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                string maPhieu = comboBox2.Text.ToString();
                string[] name = { "@MAPHIEU" };
                object[] param = { maPhieu };
                DataTable xoaphieugui = DBAcess.ExecuteQuery("SP_XOAPHIEUGUI", name, param, 1);
                MessageBox.Show("Đã xóa mã phiếu" + " " + maPhieu + " " + "thành công");
                comboBox2.DataBindings.Clear();
                PhieuGuiTien_Load(sender,e);

            }
            
        }
    }
}
