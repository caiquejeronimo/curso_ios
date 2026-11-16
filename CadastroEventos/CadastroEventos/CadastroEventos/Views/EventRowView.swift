import SwiftUI

struct EventRowView: View {

    let event: Event

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            dateCard

            eventInformation

            Spacer()
        }
        .padding(.vertical, 5)
    }


    private var dateCard: some View {
        VStack(spacing: 2) {
            Text(
                event.date,
                format: .dateTime.day()
            )
            .font(.title2)
            .bold()

            Text(
                event.date,
                format: .dateTime.month(.abbreviated)
            )
            .font(.caption)
            .textCase(.uppercase)
        }
        .foregroundStyle(.white)
        .frame(width: 56, height: 66)
        .background(.blue.gradient)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }

    private var eventInformation: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(event.title)
                .font(.headline)

            Label(
                event.place,
                systemImage: "mappin.and.ellipse"
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Label {
                Text(
                    event.date,
                    format: .dateTime
                        .hour()
                        .minute()
                )
            } icon: {
                Image(systemName: "clock")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Text(event.desc)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}
