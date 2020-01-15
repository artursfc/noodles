# Pull Request Review
## Checklist
[] Views/ViewControllers do not have hard coded navigation. Navigation should be done through Coordinators.
[] ViewModels do not access data from Core Data and/or Cloudkit directly. Data should be provided through Interactors.
[] Views, ViewModels and Coordinators work only with Structs of models. Interactors shou
