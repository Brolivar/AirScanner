# AirScanner

Small app that displays the current air quality of Munich, as well as a forecast grouped by date, using OpenWeatherApp API.


## Remarks, ideas and concerns

- Overall I tried to make the structure as maintainable and scalable as possible, as well as dividing (and isolating) the responsibility accordingly. This might add a small layer of 
complexity, but in the end it was for trying to face it like a product in a real environment.

- For the structure, I've used a simple version of MVVM. However, and because of time constraints, I wasn't able to implement a system to handle the app navigation (i.e Navigator or Coordinator) to handle segues and inject required modules, which would definitely enhance modularisation, data encapsulation and reusability, as well as reducing the size/responsibility of ViewControllers.

- Currently the data retrieved from the API is quite lightweight since it's mostly text, but in the future if the app were to download and process much heavier data 
(such as images) the introduction of pagination on the Forecast list would be highly desirable, to optimise the usage of user's data.

- As the API data was so lightweight I didn't add any caching or persistence method, but if it were to grow the introduction of a native system (f.e UserDetaults, CoreData)
or third-party (f.e Kingfisher for images) would be a good improvement.

- Finally, and more specifically, an improvement on the ForecastDetailsView I would make: Instead of "hardcoding" on the Interface the air quality components (such as O2, NH3..)
I would add these components to an enum (containing things like name to display on the table, measurement used..) while also creating a TableView that iterates over it, making it more scalable
and easy to modify for the future (f.e in case of removing a property, it wouldn't be necessary to modify the UI and constraints, just the code). 

Those are the main improvements that I would make given more time, though as I coded the app, I was adding comments with things I would improve/change.

Reach me out if you have any questions, or issues regarding the project. I’m looking forward to seeing what the iOS Devs think :)
