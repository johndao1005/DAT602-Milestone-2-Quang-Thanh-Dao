using System;

namespace DAT602_A2
{
    class Program
    {
        static void Main(string[] args)
        {
            DataAccess aDataAccess = new DataAccess();
            /*Start Database*/
            Console.WriteLine("Message is " + aDataAccess.CREATEDB());
            /*Register USer*/
            Console.WriteLine("Message is " + aDataAccess.CreateUser("john1@gamil.com", "hello", "hello"));
            Console.WriteLine("Message is " + aDataAccess.CreateUser("john2@gamil.com", "hi", "hi"));
            Console.WriteLine("Message is " + aDataAccess.CreateUser("john3@gamil.com", "hi", "hi"));
            Console.WriteLine("Message is " + aDataAccess.LogoutUser(1)); 
            Console.WriteLine("Message is " + aDataAccess.AuthUser("john1@gamil.com", "hello"));
            Console.WriteLine("Message is " + aDataAccess.EditUser(1, "hithere", "hi", "hi"));
            Console.WriteLine("Message is " + aDataAccess.DeleteUser(3));
            /*Select game*/
            Console.WriteLine("Message is " + aDataAccess.CreateCharacter(1, "character 1"));
            Console.WriteLine("Message is " + aDataAccess.CreateCharacter(1, "character 1"));
            Console.WriteLine("Message is " + aDataAccess.CreateSession(1));
            Console.WriteLine("Message is " + aDataAccess.JoinSession(2, 1));
            /*Live Game*/
            Console.WriteLine("Message is " + aDataAccess.MovePosition("Down",1, "Map12"));
            Console.WriteLine("Message is " + aDataAccess.MovePosition("Down", 1, "Map12"));
            Console.WriteLine("Message is " + aDataAccess.MovePosition("Left", 1, "Map12"));
            Console.WriteLine("Message is " + aDataAccess.MovePosition("Right", 1, "Map12"));
            Console.WriteLine("Message is " + aDataAccess.FinishGame(1));
            /*Admin*/
            Console.WriteLine("Message is " + aDataAccess.CreateSession(1));
            Console.WriteLine("Message is " + aDataAccess.JoinSession(2, 1));
            Console.WriteLine("Message is " + aDataAccess.RemoveSession(1));
            Console.WriteLine("Message is " + aDataAccess.ResetCharacter(1));
            Console.ReadLine();
        }
    }
}
