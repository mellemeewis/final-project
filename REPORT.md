# Report QuitMeat &nbsp;&nbsp;&nbsp;&nbsp; <img src="/doc/icon.png" width="8%" height="8%"/>

## Short Description
QuitMeat is an application that helps users consume less meat by giving insights about the amount of water, co2 and animals they save by their reduced meat consumption. A social environment allow friends to stimulate each other reducing their meat consumption even further.

## Design
### Work Flow
The below image is a visualization of the flow within the application. All the screen and are presented, the possible navigation between the views is indicated by the arrows.  
  
<img src="/doc/WorkFlow.png"/>

### Data Structure
Below, a diagram can be found which show the link between the views that rely on data and the datastructure used in the application.  
<img src="/doc/DataStructureDiagram.png"/>

Firebase Realtime Database is used for the storing of data and the authentication of users. The data on the database is structured in JSON format.

### Code Structure
Every view in this application is backed by it's own viewcontroller.  

The [HomeSreenViewController](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers/HomeScreenViewController.swift) works as the dashboard for the user; this is the location where all the relevant data is summerized and presented to the user. The user can get more detailed information by navigating to the lower level viewcontrollers.  

These [viewcontrollers](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers) are sorted by the envirnonment in which they exist: 
- [Authentication Environment](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers/Authentication%20Environment)
- [Challenges Environment](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers/Challenges%20Environment)
- [Social Environment](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers/Social%20Environment)
- [User Stops Environment](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers/User%20Stops%20Environment)

All the data that's retrieved form the database is stored in the [Session Controller](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Classes/SessionController.swift). For doing this, customized [structs](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Structs) are used: 
- [Challenge](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/Challenge.swift)
- [Event](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/Event.swift)
- [ProductType](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/ProductType.swift)
- [StopDetail](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/StopDetail.swift)
- [User](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/User.swift)
- [StoppedItem](https://github.com/mellemeewis/final-project/blob/master/QuitMeat/QuitMeat/Code/Structs/stoppedItem.swift)

[Custom Table View Cells](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/Custom%20UITableViewCells) were created for better representation of data within the different views.

## Challenges
### Retrieving Data
The first challenge in the creation of this application was the setup of Firebase as Authentication service and the Firebase Realtime Database. Since quite a lot of data needs to be stored in the database, it took some time to find the right structure for writing and retrieving the data in a need manner. A lot of small changes were made constantly but eventualy the database works and is fairly easy to use. 

One big flaw in the structure of this application is the fact that the functions for retrieving the data are located within the for that data relevant viewcontroller. This, in combination with the earlier metioned use of the homescreen as a dashboard containing all information, causes quite some overlap of code between the different viewcontrollers. This choice was made for two reasons. Firstly, this made it fairly easy to deal with the asynchronous retrieving of the data. The closure statement of the data retrieve function as location to command an update of the user interface offered an easy solution to this problem. Second, the fact that the implementation of, and dependence on, Firebase as database for this application was already reasonably large when warnings of the staff stated not to use Firebase as database made changing this imperfection less sensible. At least, using this 'ugly' solution, it was certain that the data would be retrieved and stored in the right way, while also allowing easy handling of asynchronous data retrieving, despite using the discouraged Firebase Realtime Database. This was extremely important considering the fact that the whole application relies heavily on data from the database. It would have been ideal to move all these data retrieving functions into a seperate 'DatabaseController' file. Unfortanetly, the available time was limited and therefore certainty about functionality was prioritized over code design. 

### Allowing users to create and participate in challenges.
The implementation of the functionality for users to create and particpate in challenges turned out to be way more complicated than anticipated. This was a result of the fact that a lot of data is needed for this functionality, coming from a lot of different parts of the database. The Friend ID's of the user, the created challegnes by each friend (only challenges created by user of friend are visible), the challenges the user already has completed, or currently participates in, and the information about each challenges are all stored in seperate parts of the database. This made retrieving and updating the data, for instance when the user accepts a challenge or when a challenge needs to be moved from current to completed, relativly complicated. This did not cause real problems, but the implementation of challenges took quite a bit longer than initially planned.

### Changes from [Design](https://github.com/mellemeewis/final-project/blob/master/DESIGN.md)
Looking back at the Design Document, no big changes were made to the initial idea. The final product has a bit more functionality than the original idea, this was done to create a better user experinece. One goal that was not achieved, but was not in the Design Document either because the idea emerged while developing, is the implentation of a chat function which allows users to communicate with each other. This turned out to be to much work to complete within the available time for this project. 
