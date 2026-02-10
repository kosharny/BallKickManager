import SwiftUI

struct OnboardingViewModeBK: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @State private var currenStep = 0
    
    // Form States
    @State private var dominantLeg: String = "Right"
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var goal: String = "Technique"
    
    let legs = ["Right", "Left", "Both"]
    let goals = ["Technique", "Power", "Accuracy", "Stamina"]
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient.ignoresSafeArea()
            
            VStack {
                // Progress
                HStack {
                    ForEach(0..<3) { index in
                        Capsule()
                            .fill(index <= currenStep ? viewModel.currentTheme.mainColor : Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .padding(.top, 40)
                
                Spacer()
                
                // Content based on step
                VStack(spacing: 30) {
                    if currenStep == 0 {
                        LegSelectionView(selectedLeg: $dominantLeg, legs: legs)
                    } else if currenStep == 1 {
                        BodyStatsView(height: $height, weight: $weight)
                    } else {
                        GoalSelectionView(selectedGoal: $goal, goals: goals)
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                
                Spacer()
                
                // Navigation Buttons
                Button(action: nextStep) {
                    Text(currenStep < 2 ? "NEXT" : "START TRAINING")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(isFormValid() ? viewModel.currentTheme.mainColor : Color.gray)
                        )
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
                .disabled(!isFormValid())
            }
        }
    }
    
    func nextStep() {
        withAnimation {
            if currenStep < 2 {
                currenStep += 1
            } else {
                saveAndFinish()
            }
        }
    }
    
    func isFormValid() -> Bool {
        if currenStep == 1 {
            return !height.isEmpty && !weight.isEmpty
        }
        return true
    }
    
    func saveAndFinish() {
        viewModel.userDominantLeg = dominantLeg
        viewModel.userHeight = height
        viewModel.userWeight = weight
        viewModel.userGoal = goal
        viewModel.completeOnboarding()
    }
}

// Subviews
struct LegSelectionView: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @Binding var selectedLeg: String
    let legs: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            if let _ = UIImage(named: "onboarding_leg") {
                Image("onboarding_leg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(color: viewModel.currentTheme.mainColor, radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
            } else {
                Image(systemName: "figure.soccer")
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.currentTheme.mainColor)
            }
            
            Text("DOMINANT LEG")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            ForEach(legs, id: \.self) { leg in
                Button(action: { selectedLeg = leg }) {
                    HStack {
                        Text(leg)
                            .fontWeight(.bold)
                        Spacer()
                        if selectedLeg == leg {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .foregroundColor(selectedLeg == leg ? .black : .white)
                    .padding()
                    .background(selectedLeg == leg ? viewModel.currentTheme.mainColor : Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

struct BodyStatsView: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @Binding var height: String
    @Binding var weight: String
    
    var body: some View {
        VStack(spacing: 20) {
            if let _ = UIImage(named: "onboarding_stats") {
                Image("onboarding_stats")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(color: viewModel.currentTheme.mainColor, radius: 10, x: 0, y: 5)
            } else {
                Image(systemName: "ruler.fill")
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.currentTheme.mainColor)
            }
            
            Text("BODY STATS")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            CustomTextField(placeholder: "Height (cm)", text: $height)
            CustomTextField(placeholder: "Weight (kg)", text: $weight)
        }
        .padding(.horizontal, 40)
    }
}

struct GoalSelectionView: View {
    @EnvironmentObject var viewModel: MainViewModelModeBK
    @Binding var selectedGoal: String
    let goals: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            if let _ = UIImage(named: "onboarding_goal") {
                Image("onboarding_goal")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(color: viewModel.currentTheme.mainColor, radius: 10, x: 0, y: 5)
            } else {
                Image(systemName: "target")
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.currentTheme.mainColor)
            }
            
            Text("YOUR MAIN GOAL")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            ForEach(goals, id: \.self) { goal in
                Button(action: { selectedGoal = goal }) {
                    HStack {
                        Text(goal)
                            .fontWeight(.bold)
                        Spacer()
                        if selectedGoal == goal {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .foregroundColor(selectedGoal == goal ? .black : .white)
                    .padding()
                    .background(selectedGoal == goal ? viewModel.currentTheme.mainColor : Color.white.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeholder).foregroundColor(.gray)
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            .keyboardType(.numberPad)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
