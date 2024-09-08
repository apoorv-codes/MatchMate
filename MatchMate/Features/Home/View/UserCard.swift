//
//  UserCard.swift
//  MatchMate
//
//  Created by Apoorv Verma on 9/7/24.
//
import SwiftUI
import NukeUI


struct UserCard: View {
    var user: UserDataModel?
    let action: (String, UserAction) -> Void
    var listWidth: Int
    
    var actionLabel: String {
        switch user?.action {
        case .accepted:
            return "Accepted"
        case .declined:
            return "Declined"
        default: return ""
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            LazyImage(url: .init(string: user?.picture?.large ?? "")) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.gray)
                }
            }
            .frame(width: CGFloat(listWidth - 16), height: CGFloat(listWidth - 16), alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text("\(user?.name?.first ?? "") \(user?.name?.first ?? "") \(user?.name?.last ?? "")")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(.accent)
            
            Text("\(user?.dob?.age ?? 0), \(user?.location?.city ?? "")")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(.gray)
            
            if user?.action == .pending {
                HStack {
                    Spacer()
                    ActionButton(for: .declined)
                    Spacer()
                    ActionButton(for: .accepted)
                    Spacer()
                }
                .padding(.vertical, 8)
            } else {
                Text(actionLabel)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: CGFloat(listWidth))
                    .padding(.vertical, 12)
                    .background(Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 8)
        .background(
            GeometryReader { geometry in
                Color.cardBackground
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    func ActionButton(for type: UserAction) -> some View {
        Image(systemName: type == .accepted ? "checkmark.circle" : "xmark.circle")
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.palette)
            .foregroundStyle(.gray, .accent)
            .frame(height: 60)
            .onTapGesture {
                if let user = user?.id?.v {
                    action(user, type)
                }
            }
    }
}
#Preview {

}
