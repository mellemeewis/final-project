# Report QuitMeat

## Short Description
QuitMeat is an application that helps user consume less meat by giving insight about the amount of water, co2 and animals they save by their reduced meat consumption. A social environments helps friend stimulate each other to reduces their meat consumption even further.

## Design
### Work Flow
The below image is a visualization of the flow within the application. All the screen and are presented, how they can be reached is indicated by arrows.  
  
<img src="/doc/WorkFlow.png"/>

### Data Structure
Below, a diagram can be found which show the link between the seperate screens and the datastructure used in the application.
<img src="/doc/DataStructureDiagram.png"/>

Firebase Realtime Database is used for the storing of data and the authentication of users. The data on the database is structured in JSON format.

### Code Structure
Every view in this application is backed by it's own viewcontroller. The [viewcontrollers](https://github.com/mellemeewis/final-project/tree/master/QuitMeat/QuitMeat/Code/Classes/View%20Controllers) are sorted by the envirnonment in which they exist: 
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
