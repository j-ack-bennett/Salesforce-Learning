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
