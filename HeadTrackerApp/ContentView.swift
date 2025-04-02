import SwiftUI
import CoreMotion
import Combine

struct ContentView: View {
    @StateObject private var headphoneMotionManager = HeadphoneMotionManager()
    @State private var connectionAttempts = 0
    @State private var showDebugInfo = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("AirPods Pro Head Tracking")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                if headphoneMotionManager.isDeviceConnected {
                    // Visual head tracker
                    HeadVisualization(
                        pitch: headphoneMotionManager.pitch,
                        roll: headphoneMotionManager.roll,
                        yaw: headphoneMotionManager.yaw
                    )
                    .frame(height: 180)
                    .padding(.vertical, 10)
                    
                    // Numerical data
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Head Orientation")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Divider()
                        
                        OrientationRow(label: "Pitch", value: headphoneMotionManager.pitch, description: "Up/Down")
                        OrientationRow(label: "Roll", value: headphoneMotionManager.roll, description: "Tilt Left/Right")
                        OrientationRow(label: "Yaw", value: headphoneMotionManager.yaw, description: "Turn Left/Right")
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                } else {
                    Spacer()
                    
                    VStack(spacing: 25) {
                        Image(systemName: "airpodspro")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Waiting for AirPods Pro...")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            connectionAttempts += 1
                            headphoneMotionManager.restart()
                        }) {
                            Text("Retry Connection")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        if showDebugInfo {
                            Text("Connection Status: \(headphoneMotionManager.connectionStatus)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 10)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 1)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                
                Spacer()
                
                // Debug info footer
                HStack {
                    if showDebugInfo {
                        Text("Attempts: \(connectionAttempts)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showDebugInfo.toggle()
                    }) {
                        Image(systemName: showDebugInfo ? "info.circle.fill" : "info.circle")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .padding(.horizontal, 5)
        }
        .onAppear {
            headphoneMotionManager.start()
        }
        .onDisappear {
            headphoneMotionManager.stop()
        }
    }
}

struct HeadVisualization: View {
    let pitch: Double
    let roll: Double
    let yaw: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Direction indicators
            DirectionIndicators()
                .foregroundColor(.gray.opacity(0.7))
            
            // Head outline and face
            ZStack {
                // Head outline
                Circle()
                    .stroke(Color.gray, lineWidth: 1.5)
                    .frame(width: 120, height: 120)
                
                // Face representation
                HeadShape()
                    .fill(Color.blue.opacity(0.5))
                    .frame(width: 110, height: 110)
                    .rotation3DEffect(
                        .degrees(pitch),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )
                    .rotation3DEffect(
                        .degrees(roll),
                        axis: (x: 0.0, y: 0.0, z: 1.0)
                    )
                    .rotation3DEffect(
                        .degrees(yaw),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                isAnimating = true
            }
        }
    }
}

struct DirectionIndicators: View {
    var body: some View {
        ZStack {
            // Horizontal line
            Rectangle()
                .frame(width: 180, height: 1)
                .opacity(0.3)
            
            // Vertical line
            Rectangle()
                .frame(width: 1, height: 180)
                .opacity(0.3)
            
            // Direction labels
            VStack {
                Text("Front")
                    .font(.system(size: 11))
                    .padding(.bottom, 160)
                
                HStack {
                    Text("Left")
                        .font(.system(size: 11))
                        .padding(.trailing, 160)
                    
                    Text("Right")
                        .font(.system(size: 11))
                        .padding(.leading, 160)
                }
                
                Text("Back")
                    .font(.system(size: 11))
                    .padding(.top, 160)
            }
        }
    }
}

struct HeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Head shape
        path.addEllipse(in: rect)
        
        // Eyes
        let eyeWidth = width * 0.12
        let eyeHeight = height * 0.08
        let eyeY = height * 0.35
        
        let leftEyeX = width * 0.3
        let rightEyeX = width * 0.7 - eyeWidth
        
        path.addEllipse(in: CGRect(x: leftEyeX, y: eyeY, width: eyeWidth, height: eyeHeight))
        path.addEllipse(in: CGRect(x: rightEyeX, y: eyeY, width: eyeWidth, height: eyeHeight))
        
        // Nose
        let noseWidth = width * 0.07
        let noseHeight = height * 0.15
        let noseX = width / 2 - noseWidth / 2
        let noseY = height * 0.45
        
        path.move(to: CGPoint(x: noseX, y: noseY))
        path.addLine(to: CGPoint(x: noseX + noseWidth, y: noseY))
        path.addLine(to: CGPoint(x: noseX + noseWidth / 2, y: noseY + noseHeight))
        path.addLine(to: CGPoint(x: noseX, y: noseY))
        
        // Mouth
        let mouthWidth = width * 0.4
        let mouthHeight = height * 0.05
        let mouthX = width / 2 - mouthWidth / 2
        let mouthY = height * 0.65
        
        path.move(to: CGPoint(x: mouthX, y: mouthY))
        path.addQuadCurve(
            to: CGPoint(x: mouthX + mouthWidth, y: mouthY),
            control: CGPoint(x: mouthX + mouthWidth / 2, y: mouthY + mouthHeight)
        )
        
        return path
    }
}

struct OrientationRow: View {
    let label: String
    let value: Double
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(String(format: "%.1f°", value))
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
            
            // Progress bar visualization
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                    
                    // Value indicator
                    let normalizedValue = ((value + 180) / 360).clamped(to: 0...1)
                    let width = normalizedValue * geometry.size.width
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: max(0, width), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

class HeadphoneMotionManager: ObservableObject {
    private let motionManager = CMHeadphoneMotionManager()
    private var timer: Timer?
    private var availabilityTimer: Timer?
    private var updateTimer: Timer?
    private var lastMotionData: CMDeviceMotion?
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0
    @Published var isDeviceConnected: Bool = false
    @Published var connectionStatus: String = "Not started"
    
    func start() {
        connectionStatus = "Starting headphone motion tracking"
        
        // Attempt immediate connection (for already connected AirPods)
        immediateConnectionAttempt()
        
        // Set up polling to check for connections periodically (for AirPods connected later)
        availabilityTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkDeviceAvailability()
        }
    }
    
    private func immediateConnectionAttempt() {
        // Check if device is already connected
        if motionManager.isDeviceMotionAvailable {
            connectionStatus = "Device already connected at launch"
            startMotionUpdates()
        } else {
            connectionStatus = "No device connected at launch - waiting"
        }
    }
    
    private func checkDeviceAvailability() {
        if motionManager.isDeviceMotionAvailable && !motionManager.isDeviceMotionActive {
            connectionStatus = "Device motion available"
            startMotionUpdates()
        } else if !motionManager.isDeviceMotionAvailable && isDeviceConnected {
            // Device was connected but is now disconnected
            connectionStatus = "Device disconnected"
            isDeviceConnected = false
        }
    }
    
    func restart() {
        stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.start()
        }
    }
    
    private func startMotionUpdates() {
        connectionStatus = "Starting motion updates"
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self else { return }
            
            if let error = error {
                self.connectionStatus = "Error: \(error.localizedDescription)"
                self.isDeviceConnected = false
                return
            }
            
            if let motion = motion {
                self.lastMotionData = motion
                self.isDeviceConnected = true
                
                // Update UI with motion data
                self.updateMotionData(motion)
            }
        }
        
        // Set up a backup timer to check if we're still getting data
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if !self.motionManager.isDeviceMotionAvailable {
                self.connectionStatus = "Device no longer available"
                self.isDeviceConnected = false
            } else if !self.motionManager.isDeviceMotionActive {
                self.connectionStatus = "Motion updates stopped unexpectedly"
                self.startMotionUpdates() // Restart updates
            }
        }
    }
    
    private func updateMotionData(_ motion: CMDeviceMotion) {
        // Convert radians to degrees
        self.pitch = motion.attitude.pitch * 180 / .pi
        self.roll = motion.attitude.roll * 180 / .pi
        self.yaw = motion.attitude.yaw * 180 / .pi
        
        if !isDeviceConnected {
            connectionStatus = "Receiving motion data"
        }
        
        isDeviceConnected = true
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        
        availabilityTimer?.invalidate()
        availabilityTimer = nil
        
        updateTimer?.invalidate()
        updateTimer = nil
        
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
            connectionStatus = "Motion updates stopped"
        }
    }
    
    deinit {
        stop()
    }
}