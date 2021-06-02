// Two ways of declaring a list for a colors variable:
List<String> colors = new List<String>();
String[] colors = new List<String>();
// It's easier to create a list rather than an array, as lists require 
// you to determine ahead of time how many elements you need to alocate


// Adding elements:
// Create a list and add elements to it in one step
List<String> colors = new List<String> { 'red', 'green', 'blue' };
// Add elements to a list after it has been created
List<String> moreColors = new List<String>();
moreColors.add('orange');
moreColors.add('purple');


// Get elements from a list, using two equivalent ways:
String color1 = moreColors.get(0);
String color2 = moreColors[0];
System.assertEquals(color1, color2);
// Iterate over a list to read elements
for(Integer i=0;i<colors.size();i++) {
  // Write value to the debug log
  System.debug(colors[i]);
}


// Class to create an email manager for sending emails
public class EmailManager {
  // Public method, uses built-in messaging methods from apex class library
  // Added static so it can be called directly on the class name
  public static void sendMail(String address, String subject, String body) {
    // Create an email message object
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {address};
    mail.setToAddresses(toAddresses);
    mail.setSubject(subject);
    mail.setPlainTextBody(body);
    // Pass this email message to the built-in sendEmail method 
    // of the Messaging class
    Messaging.SendEmailResult[] results = Messaging.sendEmail(
      new Messaging.SingleEmailMessage[] { mail });
    
    // Call a helper method to inspect the returned results
    inspectResults(results);
  }
  
  // Helper method
  private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
    Boolean sendResult = true;
      
    // sendEmail returns an array of result objects.
    // Iterate through the list to inspect results. 
    // In this class, the methods send only one email, 
    // so we should have only one result.
    for (Messaging.SendEmailResult res : results) {
      if (res.isSuccess()) {
          System.debug('Email sent successfully');
      }
      else {
          sendResult = false;
          System.debug('The following errors occurred: ' + res.getErrors());                 
      }
    }
    return sendResult;
  }
}

// Use this to invoke the public method, using anonymous apex execution
EmailManager em = new EmailManager();
em.sendMail('Your email address', 'Trailhead Tutorial', '123 body');
// enter your email address, a subject and body

// Changes to this if sendMail is static
EmailManager.sendMail('Your email address', 'Trailhead Tutorial', '123 body');
