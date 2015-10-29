using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Conditinals
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("What is your age? ");
            string ageAsString = Console.ReadLine();
            int age = int.Parse(ageAsString);

            if (age > 65)
            {
                Console.WriteLine("Your are an senior citizen");
            }
            else if ( age >= 21 )
            {
                Console.WriteLine("You are a legal adult");
            }
            else
            {
                Console.WriteLine("You are not a legal adult");
            }
        }
    }
}
