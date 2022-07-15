![Pub](https://img.shields.io/pub/v/playable_menu_flutter)

# playable_toolbar_flutter

Playable toolbar package is a beautiful animated menu(toolbar) which you can customize as much as you want.

## Installation 

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  playable_toolbar_flutter: ^latest_version
```
2. Import the package and use it in your Flutter App.
```dart
import 'package:playable_toolbar_flutter/playable_toolbar_flutter.dart';
```

## Screenshots
<table>
<tr>
<td>

![Preview1](https://user-images.githubusercontent.com/31685655/179196963-02331466-594b-42f7-8ede-b73ff7311409.gif)
</td>
<td>

![Preview2](https://user-images.githubusercontent.com/31685655/179197138-65a85201-d2a0-44f4-869c-dda08b39e3d4.gif)
</td>
</table>


## Example
There are a number of properties that you can modify.
Customize them as you want:

 - List of items 📝See example below.
 - Height & Width 👉🏻  ``` toolbarHeight & toolbarWidth ```
 - Items Gutter 👉🏻 ``` itemsGutter ```
 - Items Offset 👉🏻 ``` itemsOffset ```
 - Background color 👉🏻 ``` toolbarBackgroundColor ```
 - Shadow under the toolbar 👉🏻 ``` toolbarShadow ```
 - Toolbar Radius 👉🏻 ``` toolbarBackgroundRadius ```
 - Horizontal padding 👉🏻 ``` toolbarHorizontalPadding ```
 - Animation duration (will be added in future updates)
 - Animation curve (will be added in future updates)

### List Items
✔ You can create list items like below.
<br>
1) First import list_item_model like this: 

```dart
import 'package:playable_toolbar_flutter/list_item_model.dart';
```

2) Then create your items like this:
<table>
<tr>
<td>

```dart
ListItemModel(
  onTap: () => print("Edit is tapped."),
  title: 'Edit',
  color: Colors.pinkAccent,
  icon: Icons.edit,
),
```
</td>
<td>

![editICon](https://user-images.githubusercontent.com/31685655/179207030-60561a6f-0a68-409f-83f2-4ea16ceed1e2.png)

</td>
</tr>
</table>

3) Then create list of your items and pass it to ```playable_menu_flutter``` widget:

```dart
List<ListItemModel> someToolbarItems = [
  ListItemModel(
    onTap: () => print("Edit is tapped."),
    title: 'Edit',
    color: Colors.pinkAccent,
    icon: Icons.edit,
  ),
  ListItemModel(
    onTap: () => print("Delete is tapped."),
    title: 'Delete',
    color: Colors.lightBlueAccent,
    icon: Icons.delete,
  ),
  ListItemModel(
    onTap: () => print("Comment is tapped."),
    title: 'Comment',
    color: Colors.cyan,
    icon: Icons.comment,
  ),
];
```
#### main.dart
```dart 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'playable_toolbar_flutter test App',
      home: Scaffold(
        body: PlayableToolbarWidget(
          toolbarItems: someToolbarItems,
        ),
      ),
    );
  }
}
```

## Support

You can support me by following me on  <a href="https://instagram.com/mr_tz.dev/"><img src="https://img.shields.io/badge/Instagram-E4405F?style=flat-square&logo=instagram&logoColor=white"></a> and GitHub <a href="https://github.com/SalehTZ"><img src="https://img.shields.io/github/followers/SalehTZ?logo=github&style=flat-square"></a>

And also don't forget to star this package on GitHub <a href="https://github.com/SalehTZ/playable_menu_flutter"><img src="https://img.shields.io/github/stars/SalehTZ/playable_menu_flutter?logo=github&style=flat-square"></a>


 
