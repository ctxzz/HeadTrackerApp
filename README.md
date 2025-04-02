# HeadTrackerApp

A Swift iOS application that visualizes head orientation data from AirPods Pro using CoreMotion's CMHeadphoneMotionManager.

## Features

- Real-time head orientation tracking with AirPods Pro
- 3D visual representation of head position
- Displays pitch, roll, and yaw values with intuitive visualizations
- Automatic connection detection for AirPods Pro
- Works with AirPods Pro connected before or after app launch
- Debug information for troubleshooting connections

## Requirements

- iOS 17.0+
- Xcode 15.0+
- AirPods Pro (1st or 2nd generation)
- iPhone compatible with AirPods Pro

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ctxzz/HeadTrackerApp.git
```

2. Open the project with Xcode:
```bash
cd HeadTrackerApp
xcodegen  # Generate the Xcode project from project.yml
open HeadTrackerApp.xcodeproj
```

3. Build and run the app on your iOS device

## Usage

1. Connect your AirPods Pro to your iPhone
2. Launch the app
3. The app will automatically detect your AirPods Pro
4. Once connected, you'll see a 3D face that rotates to match your head movements
5. The numerical values for pitch, roll, and yaw will be displayed below the visualization

If your AirPods Pro aren't detected automatically, you can tap the "Retry Connection" button.

## Understanding Head Orientation

- **Pitch**: Up and down movements (nodding "yes")
- **Roll**: Side-to-side tilt (tilting your head toward your shoulders)
- **Yaw**: Left and right rotation (shaking your head "no")

## Troubleshooting

If the app doesn't detect your AirPods Pro:

1. Make sure your AirPods Pro are connected to your iPhone via Bluetooth
2. Check that your AirPods Pro have sufficient battery
3. Try tapping the "Retry Connection" button
4. Toggle the debug info (tap the info icon in the bottom right) to see connection status

## Technologies Used

- Swift
- SwiftUI
- CoreMotion
- Combine

## License

[MIT License](LICENSE)

## Acknowledgments

- Built using CMHeadphoneMotionManager for AirPods Pro motion data
- SwiftUI for the user interface
- Project structure generated using XcodeGen