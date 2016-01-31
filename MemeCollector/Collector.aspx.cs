using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MemeCollector
{
    public partial class Collector : System.Web.UI.Page
    {
        DataTable MemeList;
        DataTable GenreMemeList;
        Int32 UserId;
        Int32 SelectedMemeID;

        protected void Page_Load(object sender, EventArgs e)
        {
            // When first arriving, load to list
            if (!IsPostBack)
            {
                UserId = 1;
                Session["CurrentUser"] = UserId;
                Session["LastMeme"] = 0;
                LoadUserMemeList();
                ResetGrid();
            }
            else
            {
                UserId = (Int32)Session["CurrentUser"];
                MemeList = (DataTable)Session["FullUserMemes"];
                SelectedMemeID = (Int32)Session["LastMeme"];
            }
        }

        private void LoadUserMemeList()
        {
            SqlConnection MemeDBConnection = new SqlConnection("Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;");
            string MemeDBCall = "EXEC MemeListByUser " + UserId.ToString();
            SqlCommand MemeDBScript = new SqlCommand(MemeDBCall, MemeDBConnection);
            MemeDBConnection.Open();
            SqlDataReader dr = MemeDBScript.ExecuteReader(CommandBehavior.CloseConnection);
            MemeList = new DataTable();
            MemeList.Load(dr);
            Session["FullUserMemes"] = MemeList;
        }

        private void FilterMemeList()
        {
            if (GenreSelect.SelectedValue == "0")
            {
                GenreMemeList = MemeList;
            }
            else
            {
                Int32 GenreId;
                if (Int32.TryParse(GenreSelect.SelectedValue, out GenreId))
                {
                    DataTable filt = MemeList.AsEnumerable()
                               .Where(i => i.Field<Int32>("MemeCategoryID") == GenreId)
                               .CopyToDataTable();
                    GenreMemeList = filt;
                }
                else
                {
                    GenreMemeList = MemeList;
                }
            }
        }

        private void ResetGrid()
        {
            FilterMemeList();
            MemeGrid.DataSource = GenreMemeList;
            MemeGrid.DataBind();
        }

        protected void ViewButton_Click(object sender, ImageClickEventArgs e)
        {
            using (DataGridItem ThisMeme = (DataGridItem)((ImageButton)sender).Parent.Parent)
            {
                ShowImage.Value = ThisMeme.Cells[2].Text;
                ScriptManager.RegisterStartupScript(Ajaxifier, Ajaxifier.GetType(), "MemeWindow", "DisplayFullImage();", true);
            }
        }

        protected void EditButton_Click(object sender, ImageClickEventArgs e)
        {
            using (DataGridItem ThisMeme = (DataGridItem)((ImageButton)sender).Parent.Parent)
            {
                MemeURL.ReadOnly = true;
                AddEditLabel.Text = "Edit Meme";
                SelectedMemeID = int.Parse(ThisMeme.Cells[0].Text);
                Session["LastMeme"] = SelectedMemeID;
                MemeTitle.Text = ThisMeme.Cells[4].Text;
                MemeDescription.Text = ThisMeme.Cells[5].Text;
                MemeURL.Text = ThisMeme.Cells[2].Text;
                AddEditCategories.SelectedValue = ThisMeme.Cells[3].Text;
                AddEditPopup.TargetControlID = "MemeGrid";
                AddEditPopup.Show();
            }
        }

        protected void DeleteButton_Click(object sender, ImageClickEventArgs e)
        {
            SqlParameter MemeID;
            SqlConnection MemeDBConnection = new SqlConnection("Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;");
            string MemeDBCall = "DeleteMeme";
            SqlCommand MemeDBScript = new SqlCommand(MemeDBCall, MemeDBConnection);
            MemeDBScript.CommandType = CommandType.StoredProcedure;
            MemeDBConnection.Open();
            using (DataGridItem ThisMeme = (DataGridItem)((ImageButton)sender).Parent.Parent)
            {
                MemeID = new SqlParameter("@MemeCollectionID", SqlDbType.Int);
                MemeID.Value = int.Parse(ThisMeme.Cells[0].Text);
            }
            MemeDBScript.Parameters.Add(MemeID);
            MemeDBScript.ExecuteNonQuery();

            LoadUserMemeList();
            ResetGrid();
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            SqlParameter MemeDBID;
            SqlParameter MemeDBTitle;
            SqlParameter MemeDBUser;
            SqlParameter MemeDBURL;
            SqlParameter MemeDBDescription;
            SqlParameter MemeDBCategory;
            string MemeDBCall;
            SqlCommand MemeDBScript;
            SqlConnection MemeDBConnection = new SqlConnection("Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;");

            MemeDBID = new SqlParameter("@MemeCollectionID", SqlDbType.Int);
            MemeDBID.Value = SelectedMemeID;

            MemeDBUser = new SqlParameter("@MemeUserID", SqlDbType.Int);
            MemeDBUser.Value = UserId;

            MemeDBTitle = new SqlParameter("@Title", SqlDbType.NVarChar, 50);
            MemeDBTitle.Value = MemeTitle.Text;

            MemeDBURL = new SqlParameter("@ImageURL", SqlDbType.NVarChar, 250);
            MemeDBURL.Value = MemeURL.Text;

            MemeDBDescription = new SqlParameter("@MemeDescription", SqlDbType.NVarChar, 1000);
            MemeDBDescription.Value = MemeDescription.Text;

            MemeDBCategory = new SqlParameter("@MemeCategoryID", SqlDbType.Int);
            MemeDBCategory.Value = int.Parse(AddEditCategories.SelectedValue);
            
            if (MemeURL.ReadOnly)
            {
                MemeDBCall = "UpdateMeme";
                MemeDBScript = new SqlCommand(MemeDBCall, MemeDBConnection);
                MemeDBScript.CommandType = CommandType.StoredProcedure;
                MemeDBScript.Parameters.Add(MemeDBID);
            }
            else
            {
                MemeDBCall = "InsertMeme";
                MemeDBScript = new SqlCommand(MemeDBCall, MemeDBConnection);
                MemeDBScript.CommandType = CommandType.StoredProcedure;
                MemeDBScript.Parameters.Add(MemeDBUser);
                MemeDBScript.Parameters.Add(MemeDBURL);

            }
            MemeDBScript.Parameters.Add(MemeDBTitle);
            MemeDBScript.Parameters.Add(MemeDBDescription);
            MemeDBScript.Parameters.Add(MemeDBCategory);

            MemeDBConnection.Open();
            MemeDBScript.ExecuteNonQuery();

            LoadUserMemeList();
            ResetGrid();
        }

        protected void GenreSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            ResetGrid();
        }

        protected void NewEntry_Click(object sender, EventArgs e)
        {
            MemeURL.ReadOnly = false;
            AddEditLabel.Text = "Add New Meme";
            SelectedMemeID = 0;
            Session["LastMeme"] = SelectedMemeID;
            MemeTitle.Text = string.Empty;
            MemeDescription.Text = string.Empty;
            MemeURL.Text = string.Empty;
            AddEditPopup.TargetControlID = "NewEntry";
            AddEditPopup.Show();
        }
    }
}