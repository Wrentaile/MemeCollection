<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEdit.aspx.cs" Inherits="MemeCollector.AddEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table>
        <asp:SqlDataSource runat="server" ID="GenreList" DataSourceMode="DataReader"
                        ConnectionString="Data Source=localhost;Initial Catalog=MemeCollector;Integrated Security=True;" 
                        SelectCommand="SELECT MemeCategoryID, CategoryName FROM MemeCategory WHERE ActiveRecord = 1 AND MemeCategoryID <> 0"/>
        <tr>
            <td>
                <p> Meme Title:</p>
            </td>
            <td>
                <asp:TextBox runat="server" ID="MemeTitrl"/>
            </td>
        </tr>
        <tr>
            <td>
                <p> Meme Description:</p>
            </td>
            <td>
                <asp:TextBox runat="server" ID="MemeDescription"/>
            </td>
        </tr>        
        <tr>
            <td>
                <p> Meme URL:</p>
            </td>
            <td>
                <asp:TextBox runat="server" ID="MemeURL"/>
            </td>
        </tr>
        <tr><td>
                <p> Meme Genre:</p>
            </td>
            <td>
            <asp:DropDownList runat="server" ID="GenreSelect" DataSourceID="GenreList"
                            DataValueField="MemeCategoryID" DataTextField="CategoryName"
                            OnSelectedIndexChanged="GenreSelect_SelectedIndexChanged" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button runat="server" ID="SaveButton" OnClick="SaveButton_Click" Text="Save" />
            </td>
            <td>
                <asp:Button runat="server" ID="CancelButton" OnClientClick="" Text="Cancel" />
            </td>
        </tr>
        </table>                
    </div>
    </form>
</body>
</html>
