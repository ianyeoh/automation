using System;
using System.Collections.Generic;
using System.Configuration;
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
            MailMessage mailMessage = new MailMessage();

            // Building message body and subject, configuring to and from email addresses: 
            mailMessage.From = new MailAddress(ConfigurationManager.AppSettings["FromAddress"]);
            mailMessage.To.Add(new MailAddress(ConfigurationManager.AppSettings["ToAddress"]));
            mailMessage.Subject = ConfigurationManager.AppSettings["EmailSubject"];
            mailMessage.Body = ConfigurationManager.AppSettings["EmailBody"];

            // Configuring SMTP server address and port: 
            SmtpClient client = new SmtpClient();
            client.Host = ConfigurationManager.AppSettings["ServerAddress"];
            client.Port = int.Parse(ConfigurationManager.AppSettings["Port"]);

            client.Send(mailMessage);
        }
    }
}
