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
    public partial class FrmChucNang : Form
    {
        public FrmChucNang()
        {
            InitializeComponent();
        }

        private void button3_Click(object sender, EventArgs e)
        {
           
        }

        private void button1_Click(object sender, EventArgs e)
        {
            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            PhieuRutTien f1 = new PhieuRutTien();
            f1.Show();
        }

        private void FrmChucNang_Load(object sender, EventArgs e)
        {
            
            button3.Enabled = false;
            if (DBAcess.ROLE == "ADMIN")
            {
                button3.Enabled = true;
            }
          
        }

       
    }
}
