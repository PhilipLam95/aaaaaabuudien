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
        private DataTable CMNDAN;
       
        public PhieuGuiTien()
        {
            InitializeComponent();
        }

        private void AddCmndtoCompo()
        {
            CMNDAN = DBAcess.ExecuteQuery("SP_LAYCMND");
            comboBox2.DataSource = CMNDAN;

            comboBox2.ValueMember = "CMND";



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
            AddCmndtoCompo();
            comboBox2.SelectedIndex = 0;
            comboBox1.SelectedIndex = 0;
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
           
            
           
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            string cmnd = comboBox2.SelectedValue.ToString();

            string[] name = { "@CMND" };
            object[] param = { cmnd };

            DataTable thongtindichvu = DBAcess.ExecuteQuery("SP_LAYTHONGTINKHACHANG", name, param, 1);
            textBox4.DataBindings.Add("TEXT", thongtindichvu, "HOTEN");
            textBox4.DataBindings.Clear();
            textBox5.DataBindings.Add("TEXT", thongtindichvu, "DIACHI");
            textBox5.DataBindings.Clear();
            textBox6.DataBindings.Add("TEXT", thongtindichvu, "NGAYCAP");
            textBox6.DataBindings.Clear();
            textBox7.DataBindings.Add("TEXT", thongtindichvu, "CMND");
            textBox7.DataBindings.Clear();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Hide();
            PhieuGuiTien fguitien = new PhieuGuiTien();
            fguitien.Show();
        }
    }
}
