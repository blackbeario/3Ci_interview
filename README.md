### Overview
You will be creating a two screen application that fetches information from the MockApiService and displaying the results. The results will contain a "id", "name" and "description" field. You will allow editing of the description field and saving the result.

We will be running application in web output of Flutter or something local to your device if you have macOS, Windows, iOS or Android environments setup.

### Requirements
 - You are allowed to code within `lib/content` but must use the name `DisplayWidget` as your root widget.
 - You are not allowed to use 3rd party libraries from pub.
 - You will create a list view of the results obtained from `MockApiService`
    - Display a loading indicator to the user while the list is being loaded.
    - You must use the `ResultViewWidget` from `main.dart` to display the individual results.
 - You will add a callback onto `ResultViewWidget` that pushes the user to another screen that allows the user to edit the Description of the Result.
    - If the user wants to exit mid-edit, you must compensate for that.
 - You will handle saving the result from the user's input using the same `MockApiService`. 
    - Be aware that there is a chance the `MockApiService.patch` method may fail, emulating a failed call to the API.
- The user should receive a success or failure indication
- You will update the result list with the new result
