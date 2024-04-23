// // Add this method inside the Questionnaire class
// void calculateResults() {
//   // Placeholder for your calculation logic
//   // This could be a simple tally or a complex algorithm

//   // For demonstration purposes, let's just print the answers
//   print(answers.value);

//   // Here you could navigate to a new page with the results or
//   // display the results in a dialog, etc.
//   // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResultsPage(results: results)));
// }

// // Call calculateResults() when the questionnaire is completed
// void nextQuestion(String answer) {
//   answers.value[questions[currentPage.value].text] = answer;
//   if (currentPage.value < questions.length - 1) {
//     currentPage.value++;
//   } else {
//     calculateResults();
//   }
// }