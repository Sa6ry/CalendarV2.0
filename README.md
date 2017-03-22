# Calendar
Calendar, an iOS app aims to replicate the Calendar functionality at Microsoft Outlook iOS App


# Official App
## Log
- I really wished to have access to the log files, in order to know the frequency of the features being used to assist in giving more accurate critique

## Critique -
- The current selected day is not always visible, I find this very confusing and different from the iOS Native Calendar App. And what makes it worse is that the currently selected day cannot be observed from anywhere. Also when the user try to add new event the date is defaulted to the selected day which the user might lose track of it!
- Tapping the title bar switch between month and day view (tapping the title bar is not so common for the iOS users) but this is OK since the user can achieve this other ways
- I can only create an event (plus or minus) 2 years from now! (this is a limitation) I remember one day a friend chanagled me to achieve something within 5 years. and he created a new event 5 years later so he can come back to me then :)
- The agenda view displays days which has empty events! I find this a waste. I'd rather hide empty days to provide the user with more information
- It is very annoying switching between 1 month & 2 weeks view. having views scrolling with different speed is a little bit strange
- Jumping back to today through the shown up arrow (in the lower right corner) is not that straightforward. even having it rotated while scrolling to indicate moving away from today is not obvious! I would rather replace it with an icon with the current date on it
- Tapping the status bar (on the system clock) for example doesn't scroll to today or the selected day
- Day & 3-Days view style are not that practical, you keep scrolling left and right. I'd love to check the logs in order to know if they are being used on the iPhone or not

## Bugs
- While in 2 weeks view, scrolling down using the Agenda view (the first day in the second week never got auto selected!)
- Sometimes more than one cell is being selected in the Calendar view (can't find a repro scenario)

## Suggestions
- Instead of having only one dot under the day in the calendar view indicating that the day is busy, we might display number of dots representing the number of events in this day


# Current Attempt
## Data Classes
todo

## UI Classes
todo

## Utility Classes
todo

## Installation
The Code is known to work best with iOS 9.0 on iPhone devices, it haven't been tested on earlier iOS versions
