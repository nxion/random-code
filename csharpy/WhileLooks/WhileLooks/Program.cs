using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WhileLooks
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("How old are you? ");
            int age = int.Parse(Console.ReadLine());

            do
            {
                Console.WriteLine("Happy Brithday ");
                age--;
            } while (age > 0);

            Console.WriteLine("\nTADA!!");
        }

    }
}
