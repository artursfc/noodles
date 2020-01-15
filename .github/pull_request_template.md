# Pull Request Review
## Description
Describe your changes to the code base. If your commit's title and body contains all the information necessary to complete this review, leave this section empty.

## Kind of change
**Do not open PRs for several features at once or for multiple purpose. Each PR should have only one kind of change.**
- [ ] New feature.
- [ ] Bugfix.
- [ ] Structural change.

## Checklist
To complete the following checklist make use of the following sentence: "This Pull Request *checklist item*". If the resulting sentence is true, put an ```X``` in the corresponding checkbox.
- [ ] Does not have hard coded navigation in ViewControllers. Navigation should be done through Coordinators.
- [ ] Does not have ViewModels with access to data from Core Data and/or Cloudkit directly. Data should be provided through Interactors.
- [ ] Has Views, ViewModels and Coordinators working only with Structs of models. Interactors have to translate from Core Data and/or Cloudkit to Structs of models.
- [ ] Does not add commented code.
- [ ] Does not add code with ```print```
- [ ] Has Datasources and Delegates that are implemented outside ViewControllers.
- [ ] Has weak IBOutlets and Delegates to avoid retain cycles.
- [ ] Does not have Views manipulating data. Data should be manipulated/validated in the ViewModel.
- [ ] Does have ViewModels using Protocols and Delegates for communication between Views and ViewModels.

## Comments
Comment here if necessary.
