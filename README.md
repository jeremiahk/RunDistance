# Run Distance

This application has been sitting on my computer for a while, so I decided to rework it with some new concepts. It is very simple, and has not UI work, but it allows me to work with some new concepts.

1. SwiftUI - I have used UIKit in all my and it will be some time till I am able to use it in production, but I feel its something I should start to spend more time with. 
2. The reducer pattern - The reducer pattern is very common in React Native. I really like the separation between UI and state manipulation. Our UI is a function of state. So moving state manipulation out of the UI makes a lot of sense.
3. Testing - Moving state manipulation out of the UI makes the testing much simpler. There are still many questions on how we should test SwiftUI views. I have seen some snap shot test libraries, but I have not had a chance to use them. I feel they would fit in very well with this application architecture. 
   
This is a very simple version. It doesn't support actions with side effects. You can see this issue in the "Get distance ran" button. It should just call an action in the reducer and pass that result back into the reducer as a new action. It also doesn't support composition of state or actions. Once state needs to exist beyond one screen, a pullback function would allow us to pull smaller state from a larger state and relate how local actions can effect the larger state. You can see a related idea in the `send<LocalValue>(event:bind)` function. It allows us to pull local state using a keypath and return actions when given a new value.