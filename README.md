# Skejul

Skejul is a scheduling application that allows user to create diagrams of their schedules with blocks and interchangeable features. Schedules can be saved and loaded using .essen files, and users can capture screenshots of their schedules.


## Features

- **Save/Load System**: Persist schedules using the custom .essen file format
- **Screenshot Capture**: Export visual representations of your schedules
- **Draggable Blocks**: Easily rearrange schedule elements
- **Text Editing**: Add and modify text within schedule blocks
- **Customizable Interface**: Tailor the scheduling experience to your needs (still limited)

## Getting Started

To use Skejul, simply run the application and begin creating your schedule by adding blocks, text, and other modular elements. Save your work frequently using the save function, and load previously saved schedules with the load function.

## File Format

Skejul uses the .essen file format for saving and loading schedules. This format preserves all schedule elements including positions, text content, and block configurations.

## Technology Stack

- **Engine**: Godot 4.x
- **Language**: GDScript
- **File Format**: Custom .essen format for schedule persistence
- **Assets**: Custom fonts, icons, and UI elements

## Project Structure

- `script/` - Contains all GDScript components (main, save/load, screenshot, UI elements)
- `prefabs/` - Reusable scenes (draggable blocks, text blocks, main interface)
- `assets/` - Fonts, icons, images, and other resources
- `test/` - Compiled executables for Windows platform

## Usage Tips

1. Use the add button to create new schedule elements
2. Drag blocks to rearrange your schedule layout
3. Double-click text blocks to edit content
4. Use save/load functions to persist your work
5. Use screenshot function to export your schedule as an image
