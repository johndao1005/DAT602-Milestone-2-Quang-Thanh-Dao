using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace DAT602_A2
{
    class DataAccess
    {
        private static string connectionString
        {
            get { return "Server=localhost;Port=3306;Database=foodiedb;Uid=root;password=Hoalong986;"; }

        }

        private static MySqlConnection _mySqlConnection = null;
        public static MySqlConnection mySqlConnection
        {
            get
            {
                if (_mySqlConnection == null)
                {
                    _mySqlConnection = new MySqlConnection(connectionString);
                }

                return _mySqlConnection;

            }
        }

/*
        create DB*/
        public string CREATEDB()
        {
            
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "CREATEDB()");

            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        /*        User*/
        public string AuthUser(string inputEmail, string inputPassword)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputEmail", MySqlDbType.VarChar, 255);
            aP.Value = inputEmail;
            p.Add(aP);
            var aP2 = new MySqlParameter("@inputPassword", MySqlDbType.VarChar, 255);
            aP2.Value = inputPassword;
            p.Add(aP2);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AuthUser(@inputEmail,@inputPassword)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        public string LogoutUser(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "LogoutUser(@inputID)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }


        public string DeleteUser(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "DeleteUser(@inputID)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        public string CreateUser(string inputEmail, string inputUserName,string inputPassword)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputEmail", MySqlDbType.VarChar, 255);
            aP.Value = inputEmail;
            p.Add(aP);
            var aP1 = new MySqlParameter("@inputUserName", MySqlDbType.VarChar, 255);
            aP1.Value = inputUserName;
            p.Add(aP1);
            var aP2 = new MySqlParameter("@inputPassword", MySqlDbType.VarChar, 255);
            aP2.Value = inputPassword;
            p.Add(aP2);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "CreateUser(@inputEmail,@inputUserName,@inputPassword)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }
        public string EditUser(int inputID,string inputEmail, string inputUserName, string inputPassword)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aP1 = new MySqlParameter("@inputUserName", MySqlDbType.VarChar, 255);
            aP1.Value = inputUserName;
            p.Add(aP1);
            var aP2 = new MySqlParameter("@inputEmail", MySqlDbType.VarChar, 255);
            aP2.Value = inputEmail;
            p.Add(aP2);
            var aP3 = new MySqlParameter("@inputPassword", MySqlDbType.VarChar, 255);
            aP3.Value = inputPassword;
            p.Add(aP3);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "EditUser(@inputID,@inputUserName,@inputEmail,@inputPassword)", p.ToArray());
            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        /*        Character*/
        public string CreateCharacter(int inputID, string inputName)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aP2 = new MySqlParameter("@inputName", MySqlDbType.VarChar, 255);
            aP2.Value = inputName;
            p.Add(aP2);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "CreateCharacter(@inputID,@inputName)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        public string ResetCharacter(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "ResetCharacter(@inputID)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }
        /*Game Session*/
        public string CreateSession(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "CreateSession(@inputID)", p.ToArray());

            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        public string JoinSession(int inputID, int inputSessionID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aP1 = new MySqlParameter("@inputSessionID", MySqlDbType.Int32);
            aP1.Value = inputSessionID;
            p.Add(aP1);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "JoinSession(@inputID,@inputSessionID)", p.ToArray());


            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

        public string MovePosition(string inputDirection, int inputID, string mapName)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP1 = new MySqlParameter("@inputDirection", MySqlDbType.VarChar, 255);
            aP1.Value = inputDirection;
            p.Add(aP1);
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aP2 = new MySqlParameter("@mapName", MySqlDbType.VarChar, 255);
            aP2.Value = mapName;
            p.Add(aP2);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "MovePosition(@inputDirection,@inputID,@mapName)", p.ToArray());
            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }
        public string FinishGame(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "FinishGame(@inputID)", p.ToArray());

            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }
        public string RemoveSession(int inputID)
        {
            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@inputID", MySqlDbType.Int32);
            aP.Value = inputID;
            p.Add(aP);
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "RemoveSession(@inputID)", p.ToArray());

            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["message"].ToString();
        }

/*

        public string AddUserName(string pUserName)
        {

            List<MySqlParameter> p = new List<MySqlParameter>();
            var aP = new MySqlParameter("@UserName", MySqlDbType.VarChar, 50);
            aP.Value = pUserName;
            p.Add(aP);


            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AddUserName(@UserName)", p.ToArray());

            // expecting one table with one row
            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        public List<Player> GetAllPlayers()
        {
            List<Player> lcPlayers = new List<Player>();

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "call GetAllPlayers()");
            lcPlayers = (from aResult in
                                    System.Data.DataTableExtensions.AsEnumerable(aDataSet.Tables[0])
                         select
                            new Player
                            {
                                UserName = aResult["UserName"].ToString(),
                                Strength = Convert.ToInt32(aResult["Strength"]),
                                X = Convert.ToInt32(aResult["x"]),
                                Y = Convert.ToInt32(aResult["y"])
                            }).ToList();
            return lcPlayers;
        }*/
    }
}
