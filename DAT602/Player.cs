using System;
using System.Collections.Generic;
using System.Text;

namespace DAT602_A2
{
    class Player
    {
        public static Player CurrentPlayer { get; set; }
        public string UserName { get; set; }
        public int Strength { get; set; }
        public int X { get; set; }
        public int Y { get; set; }
    }
}
