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


// Creates an sObject variable type of Account and assigns to a new account with the name Acme
// This is also how you assign fields using the constructor method
Account acct = new Account(Name='Acme');

// Alternatively you can assign fields using dot notation
Account acct = new Account();
acct.Name = 'Acme';
acct.Phone = '(415)555-1212';
acct.NumberOfEmployees = 100;


// Casting generic sObjects to specific sObjects using dot notation:
// Cast a generic sObject to an Account
Account acct = (Account)myGenericSObject;
// Now, you can use the dot notation to access fields on Account
String name = acct.Name;
String phone = acct.Phone;

// The fields of a generic sObject can be accessed only through the put() and get() methods
// Generic sObjects can be created only through the newSObject() method
// To save sObjects as a record (among other things), use Data Manipulation Language (DML)
// To retrieve a record, use Salesforce Object Query Language (SOQL)


// Adding Acme Account to Salesforce using DML:
// Create the account sObject 
Account acct = new Account(Name='Acme', Phone='(415)555-1212', NumberOfEmployees=100);
// Insert the account by using DML
insert acct;
// When inserting records, the system assigns an ID for each record
// Get the new ID on the inserted sObject argument
ID acctID = acct.Id;
// Display this ID in the debug log
System.debug('ID = ' + acctID);
// Debug log result (the ID will be different in your case)
// DEBUG|ID = 001D000000JmKkeIAF

// DML statements: insert, update, delete, undelete, upsert and merge (both particular to Salesforce)
// Each DML statement accepts either a single sObject or a list (or array) of sObjects
// Operating on a list of sObjects is a more efficient way for processing records


// Bulk DML operation:
// Performing a DML operation on a list of sObjects counts as one DML statement, 
// not as one statement for each sObject
// Create a list of contacts
List<Contact> conList = new List<Contact> {
  new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
    new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
    new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
    new Contact(FirstName='Kim',LastName='Shain',Department='Education')};
            
// Bulk insert all contacts with one DML call
insert conList;
// List to hold the new contacts to update
List<Contact> listToUpdate = new List<Contact>();
// Iterate through the list and add a title only
//   if the department is Finance
for(Contact con : conList) {
  if (con.Department == 'Finance') {
    con.Title = 'Financial analyst';
    // Add updated contact sObject to the list.
    listToUpdate.add(con);
  }
}
// Bulk update all contacts with one DML call
update listToUpdate;


// upsert syntax:
// upsert sObject | sObject[]​​ field
// *field is optional*
upsert sObjectList Account.Fields.MyExternalId;

// Upsert uses the sObject record's primary key (the ID), an idLookup field, 
// or an external ID field to determine whether it should create a new record or update an existing one:
// - If the key is not matched, a new object record is created
// - If the key is matched once, the existing object record is updated
// - If the key is matched multiple times, an error is generated and the object record is neither inserted or updated


// This example shows how upsert updates an existing contact record and inserts a new contact in one call.
// This upsert call updates the existing Josh contact and inserts a new contact, Kathy
// Insert the Josh contact
Contact josh = new Contact(FirstName='Josh',LastName='Kaplan',Department='Finance');       
insert josh;
// Josh's record has been inserted
//   so the variable josh has now an ID
//   which will be used to match the records by upsert
josh.Description = 'Josh\'s record has been updated by the upsert operation.';
// Create the Kathy contact, but don't persist it in the database
Contact kathy = new Contact(FirstName='Kathy',LastName='Brown',Department='Technology');
// List to hold the new contacts to upsert
List<Contact> contacts = new List<Contact> { josh, kathy };
// Call upsert
upsert contacts;
// Result: Josh is updated and Kathy is created.


// Example using a specific field on matching records:
Contact jane = new Contact(
  FirstName='Jane',
  LastName='Smith',
  Email='jane.smith@example.com',
  Description='Contact of the day'
);
insert jane;
// 1. Upsert using an idLookup field
// Create a second sObject variable.
// This variable doesn’t have any ID set.
Contact jane2 = new Contact(
  FirstName='Jane',
  LastName='Smith',  
  Email='jane.smith@example.com',
  Description='Prefers to be contacted by email.'
);
// Upsert the contact by using the idLookup field for matching.
upsert jane2 Contact.fields.Email;
// Verify that the contact has been updated
System.assertEquals('Prefers to be contacted by email.',
  [SELECT Description FROM Contact WHERE Id=:jane.Id].Description);


// Deleting records for all contacts with the last name Smith:
Contact[] contactsDel = [SELECT Id FROM Contact WHERE LastName='Smith']; 
delete contactsDel;
// Deleted records stay in a recycle bin for 15 days before being deleted permanently


// If a DML operation fails, it returns an exception of type DmlException:
try {
  // This causes an exception because 
  // the required Name field is not provided.
  Account acct = new Account();
  // Insert the account 
  insert acct;
} catch (DmlException e) {
  System.debug('A DML exception has occurred: ' + e.getMessage());
}


// Database methods:
// Database.insert()
// Database.update()
// Database.upsert()
// Database.delete()
// Database.undelete()
// Database.merge()
// Database methods have an optional allOrNone parameter that allows you to specify whether the operation 
// should partially succeed. When this parameter is set to false, if errors occur on a partial set of records, 
// the successful records will be committed and errors will be returned for the failed records. 
// Also, no exceptions are thrown with the partial success option.

// Insert method with allOrNone set to false:
Database.insert(recordList, false);

// The Database methods return result objects containing success or failure information for each record. 
// For example, insert and update operations each return an array of Database.SaveResult objects.
Database.SaveResult[] results = Database.insert(recordList, false);
// Upsert returns Database.UpsertResult objects, and delete returns Database.DeleteResult objects.