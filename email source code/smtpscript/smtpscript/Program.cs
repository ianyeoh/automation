using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

/* 
 *  Sends a simple email (subject + body) using SmtpClient (System.Net.Mail)
 *  Variables pulled from App.config file to allow for easier modification and application to different tasks.
 * 
 * 
 *  Written by Ian Yeoh, last updated 19/03/2021
 */

namespace SMTPEmailClient
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                CheckConfigFileIsPresent();

                MailMessage mailMessage = new MailMessage();

                Console.WriteLine("Configuration Settings: ");
                Console.WriteLine();

                // Pulling variables from config file, running basic check if null:
                string FromAddress = CheckIfNull("FromAddress");
                string ToAddress = CheckIfNull("ToAddress");
                string EmailSubject = CheckIfNull("EmailSubject");
                string EmailBody = CheckIfNull("EmailBody");
                string ServerAddress = CheckIfNull("ServerAddress");

                // Defaults port setting to 25 (string, will be int.Parsed)
                string Port = GetValue("Port");
                if(IsNullOrEmpty(Port))
                {
                    Port = "25";
                }

                Console.WriteLine();
                Console.WriteLine("Status: ");
                Console.WriteLine();

                // Configuring to and from email addresses and building message body and subject: 
                mailMessage.From = new MailAddress(FromAddress);
                mailMessage.To.Add(new MailAddress(ToAddress));
                mailMessage.Subject = EmailSubject;
                mailMessage.Body = EmailBody;

                // Optional carbon copy: 
                string cc = GetValue("CCAddress");
                if (cc != null & !string.IsNullOrEmpty(cc))
                {
                    // Parsing of comma-delimited list of recipients
                    string[] ccAddress = cc.Split(',');
                    Console.WriteLine("Carbon Copy Recipients: ");
                    foreach (string address in ccAddress)
                    {
                        mailMessage.CC.Add(new MailAddress(address));
                        Console.WriteLine(address);
                    }
                }

                // Configuring SMTP server address and port: 
                SmtpClient client = new SmtpClient();
                client.Host = ServerAddress;
                client.Port = int.Parse(Port);

                client.Send(mailMessage);
                Console.WriteLine("Email sent successfully.");

            }
            catch (FileNotFoundException e) 
            {
                Console.WriteLine(e.Message);
                Console.ReadLine();
                Environment.Exit(0);
            }
            catch (ArgumentNullException e)
            {
                // Thrown from method CheckIfNull() if required configuration setting is missing/empty
                Console.WriteLine("REQUIRED VALUE EMPTY OR MISSING IN CONFIG FILE");
                Console.WriteLine(e.Message);
            }
            catch (FormatException e)
            {
                // Thrown from MailAdrress() class if input string is of a valid email address scheme
                Console.WriteLine("ADDRESS FORMATTING ERROR");
                Console.WriteLine(e.Message);
            }
            catch (InvalidOperationException e)
            {
                // Thrown from SmtpClient.Send if SmtpClient.Port is set to an invalid port
                Console.WriteLine("INVALID PORT CONFIGURATION");
                Console.WriteLine(e.Message);
            }
            catch (SmtpException e) 
            {
                // Thrown from SmtpClient.Send if the mail server does not respond with success code
                // Can result from a variety of errors, i.e. invalid server address, closed port, network issue 
                Console.WriteLine("MAIL SERVER OR RELAY CANNOT BE REACHED");
                Console.WriteLine(e.Message);
            }
            finally
            {
                // If PauseOnComplete = true, pauses console on program completion for debugging purposes
                if (GetValue("PauseOnComplete").ToLower() == "true")
                {
                    Console.ReadLine();
                }
            }
        }

        public static void CheckConfigFileIsPresent()
        {
            if (!File.Exists(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile))
            {
                throw new FileNotFoundException("CONFIGURATION FILE NOT FOUND");
            }
        }

        // Used for required config settings, will throw ArgumentNullException if null
        public static string CheckIfNull(string key)
        {
            string value = GetValue(key);
            if (IsNullOrEmpty(value)) 
            {
                throw new ArgumentNullException(key);
            }
            else
            {
                // Console debug output:
                Console.WriteLine(key + " = " + value);

                return value;
            }
        }

        // Returns value of key-value pair in app.config file
        public static string GetValue(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }

        public static bool IsNullOrEmpty(string value)
        {
            if (value == null || string.IsNullOrEmpty(value))
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
