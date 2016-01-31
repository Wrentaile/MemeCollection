<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Collector.aspx.cs" Inherits="MemeCollector.Collector" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="/Content/Site.css" />
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server" ID="MemeCatalogScripts" />
    <script type="text/javascript" language="javascript">
        function DisplayFullImage() {
        
            var image = document.getElementById('<%= ShowImage.ClientID %>').value;

            var txtCode = "<HTML><HEAD></HEAD><BODY TOPMARGIN=0 LEFTMARGIN=0 MARGINHEIGHT=0 MARGINWIDTH=0><CENTER>" +  
                          "<IMG src='" + image + "' BORDER=0 NAME=FullImage onload='window.resizeTo(document.FullImage.width,document.FullImage.height)'>"  +
                          "</CENTER></BODY></HTML>";

            var memeWindow = window.open  ('','image',  'toolbar=0,location=0,menuBar=0,scrollbars=0,resizable=0,width=1,height=1'); 
            memeWindow.document.open();
            memeWindow.document.write(txtCode);
            memeWindow.document.close();
        }
    </script>
    <asp:UpdatePanel runat="server" ID="Ajaxifier" >
    <ContentTemplate>
    <div align="center">
        <asp:Label runat="server" ID="HeaderLabel" Text="Internet Meme Catalog" CssClass="catalogHead" />
        <asp:HiddenField runat="server" ID="ShowImage" />
        <br />
        <br />
    </div>
    <div>
         <table>
             <tr>
                 <td width="70%">
                    <asp:Button runat="server" ID="NewEntry" Text="New Meme" OnClick="NewEntry_Click" />
                 </td>
                 <td> 
                     <asp:Label runat="server" ID="GenrePrompt" Text="Select Genre:" />          
                 </td>
                 <td>
                     <asp:SqlDataSource runat="server" ID="GenreList" DataSourceMode="DataReader"
                                        ConnectionString="Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;" 
                                        SelectCommand="SELECT MemeCategoryID, CategoryName FROM MemeCategory WHERE ActiveRecord = 1"/>
                     <%-- TODO Wire up Data source to web.config --%>
                     <asp:DropDownList runat="server" ID="GenreSelect" DataSourceID="GenreList" AutoPostBack="true"
                                       DataValueField="MemeCategoryID" DataTextField="CategoryName"
                                       OnSelectedIndexChanged="GenreSelect_SelectedIndexChanged" />
                 </td>
             </tr>
         </table>
        
    </div>
    <div align="center">
        <%-- TODO Add button to view deleted Memes and switch 'delete' to 'restore' --%>
        <asp:DataGrid runat="server" ID="MemeGrid" Width="95%" AutoGenerateColumns="false" DataKeyField="MemeCollectionID"
                      AlternatingItemStyle-BackColor="WhiteSmoke" HeaderStyle-BackColor="LightSlateGray" 
                      HeaderStyle-Font-Bold ="true" AllowPaging="true" PageSize="16">
            <Columns>
                <asp:BoundColumn DataField="MemeCollectionID" HeaderText="MemeID" Visible="false"/>
                <asp:BoundColumn DataField="MemeUserID" HeaderText="UserID" Visible="false"/>
                <asp:BoundColumn DataField="ImageURL" HeaderText="MemeURL" Visible="false"/>
                <asp:BoundColumn DataField="MemeCategoryID" HeaderText="CategoryID" Visible="false"/>
                <asp:BoundColumn DataField="Title" HeaderText="Title" Visible="true"/>
                <asp:BoundColumn DataField="MemeDescription" HeaderText="Meme Description" Visible="true"/>
                <asp:BoundColumn DataField="MemeCategory" HeaderText="Genre" Visible="true"/>
                <asp:TemplateColumn HeaderText="View" HeaderStyle-Width="50px">
                    <ItemTemplate>
                        <asp:ImageButton ID="ViewButton" runat="server" ImageUrl="/Content/View.png" OnClick="ViewButton_Click"/>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Edit" HeaderStyle-Width="50px">
                    <ItemTemplate>
                        <asp:ImageButton ID="EditButton" runat="server" ImageUrl="/Content/Edit.png" OnClick="EditButton_Click" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Delete" HeaderStyle-Width="50px">
                    <ItemTemplate>
                        <asp:ImageButton ID="DeleteButton" runat="server" ImageUrl="/Content/Delete.png" OnClick="DeleteButton_Click" />
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
        </asp:DataGrid>
        <asp:Panel runat="server" ID="AddEditMemePanel" CssClass="pnlBackGround" style="display:none">
            <table>
            <asp:Label runat="server" ID="AddEditLabel" Text="Add New Meme" Font-Size="Larger" Font-Bold="true" />
            <asp:SqlDataSource runat="server" ID="SqlDataSource1" DataSourceMode="DataReader"
                            ConnectionString="Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;" 
                            SelectCommand="SELECT MemeCategoryID, CategoryName FROM MemeCategory WHERE ActiveRecord = 1 AND MemeCategoryID <> 0"/>
            <%-- TODO Wire up Data source to web.config --%>
            <tr>
                <td>
                    <p> Meme Title:</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="MemeTitle" MaxLength="50" Width="300px"/>
                </td>
            </tr>
            <tr>
                <td>
                    <p> Meme Description:</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="MemeDescription" MaxLength="250" Width="300px"/>
                </td>
            </tr>        
            <tr>
                <td>
                    <p> Meme URL:</p>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="MemeURL" MaxLength="1000" Width="300px"/>
                    <%-- TODO Add button to verify URL --%>
                </td>
            </tr>
            <tr><td>
                    <p> Meme Genre:</p>
                </td>
                <td>
                <asp:DropDownList runat="server" ID="AddEditCategories" DataSourceID="GenreList"
                                DataValueField="MemeCategoryID" DataTextField="CategoryName"
                                OnSelectedIndexChanged="GenreSelect_SelectedIndexChanged" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button runat="server" ID="SaveButton" OnClick="SaveButton_Click" Text="Save" />
                </td>
                <td>
                    <asp:Button runat="server" ID="CancelButton" Text="Cancel" />
                </td>
            </tr>
            </table>      
        </asp:Panel>
        <act:ModalPopupExtender runat="server" ID="AddEditPopup" PopupControlID="AddEditMemePanel" DropShadow="true" 
                                TargetControlID="PopupPlaceholder" BackgroundCssClass="modalBackground" />
        <asp:LinkButton runat="server" ID="PopupPlaceholder" Visible="false" />
    </div>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID = "MemeGrid" />
        <asp:AsyncPostBackTrigger ControlID = "NewEntry" />
        <asp:AsyncPostBackTrigger ControlID = "GenreSelect" />
        <asp:AsyncPostBackTrigger ControlID = "SaveButton" />
    </Triggers>
    </asp:UpdatePanel>
    </form>
</body>
</html>
