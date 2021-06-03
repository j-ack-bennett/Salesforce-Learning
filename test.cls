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

// By default, the allOrNone parameter is true, which means that the Database method behaves like its 
// DML statement counterpart and will throw an exception if a failure is encountered.
Database.insert(recordList); && 
Database.insert(recordList, true); 
// are both the same


// Inserting records with partial success:
// Create a list of contacts
List<Contact> conList = new List<Contact> {
  new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
  new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
  new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
  new Contact()};
            
// Bulk insert all contacts with one DML call
Database.SaveResult[] srList = Database.insert(conList, false);
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
  if (sr.isSuccess()) {
    // Operation was successful, so get the ID of the record that was processed
    System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
  } else {
    // Operation failed, so get all errors
    for(Database.Error err : sr.getErrors()) {
      System.debug('The following error has occurred.');
      System.debug(err.getStatusCode() + ': ' + err.getMessage());
      System.debug('Contact fields that affected this error: ' + err.getFields());
	  }
  }
}
// One failure will show in debug console and three successful insertions

// Should You Use DML Statements or Database Methods?
// Use DML statements if you want any error that occurs during bulk DML processing to be thrown as an 
// Apex exception that immediately interrupts control flow (by using try. . .catch blocks). 
// This behavior is similar to the way exceptions are handled in most database procedural languages.

// Use Database class methods if you want to allow partial success of a bulk DML operation—if a record fails, 
// the remainder of the DML operation can still succeed. Your application can then inspect the rejected records 
// and possibly retry the operation. When using this form, you can write code that never throws DML exception errors. 
// Instead, your code can use the appropriate results array to judge success or failure. 
// Note that Database methods also include a syntax that supports thrown exceptions, similar to DML statements.


// This example shows how to add a contact to an account (the related record) by setting the AccountId field 
// on the contact. Contact and Account are linked through a lookup relationship.
Account acct = new Account(Name='SFDC Account');
insert acct;
// Once the account is inserted, the sObject will be 
// populated with an ID.
// Get this ID.
ID acctID = acct.ID;
// Add a contact to this account.
Contact mario = new Contact(
  FirstName='Mario',
  LastName='Ruiz',
  Phone='415.555.1212',
  AccountId=acctID);
insert mario;


// Updating related records:
// Query for the contact, which has been associated with an account.
Contact queriedContact = [SELECT Account.Name 
                          FROM Contact 
                          WHERE FirstName = 'Mario' AND LastName='Ruiz'
                          LIMIT 1];
// Update the contact's phone number
queriedContact.Phone = '(415)555-1213';
// Update the related account industry
queriedContact.Account.Industry = 'Technology';
// Make two separate calls 
// 1. This call is to update the contact's phone.
update queriedContact;
// 2. This call is to update the related account's Industry field.
update queriedContact.Account; 


// Deleting related records:
// The delete operation supports cascading deletions. If you delete a parent object, you delete its 
// children automatically, as long as each child record can be deleted.
Account[] queriedAccounts = [SELECT Id FROM Account WHERE Name='SFDC Account'];
delete queriedAccounts;


// A SOQL query included in apex code: 
// SOQL statement must be wrapped in [], which will return a value in an array
// of sObjects. This example returns an array of Account sObjects with two fields, name and phone.
Account[] accts = [SELECT Name,Phone FROM Account];


// Syntax for a basic SOQL query, the WHERE clause is optional
SELECT fields FROM ObjectName [WHERE Condition]
// This example retrieves accounts and gets name and phone for each account
SELECT Name,Phone FROM Account
// 1. SELECT Name,Phone: This part lists the fields that you would like to retrieve. 
// The fields are specified after the SELECT keyword in a comma-delimited list. 
// Or you can specify only one field, in which case no comma is necessary (e.g. SELECT Phone)
// 2. FROM Account: This part specifies the standard or custom object that you want to retrieve. 
// In this example, it’s Account. For a custom object called Invoice_Statement, it is Invoice_Statement__c.

// Unlike other SQL languages, you can’t specify * for all fields. You must specify every field you 
// want to get explicitly. If you try to access a field you haven’t specified in the SELECT clause, 
// you’ll get an error because the field hasn’t been retrieved.

// To specify a single account when querying, you put the info into the where condition:
SELECT Name,Phone FROM Account WHERE Name='SFDC Computing'
// To query with more condtions, use parentheses with AND, OR operators:
SELECT Name,Phone FROM Account WHERE (Name='SFDC Computing' AND NumberOfEmployees>25)
// This query returns all SFDC Computing accounts, or all accounts with more than 25 employees 
// whose billing city is Los Angeles.
SELECT Name,Phone FROM Account WHERE (Name='SFDC Computing' OR (NumberOfEmployees>25 AND BillingCity='Los Angeles'))