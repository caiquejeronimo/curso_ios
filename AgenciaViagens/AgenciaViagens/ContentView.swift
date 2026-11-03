import SwiftUI

struct TravelPackage: Identifiable {

    let id = UUID()

    let title: String
    let nights: Int
    let location: String

    let departureDate: String
    let returnDate: String

    let hotelInfo: String
    let imageName: String

    let price: Double

    var isFavorite: Bool = false
}

struct ContentView: View {
    
    @State private var packages: [TravelPackage] = [
        
        TravelPackage(
            title: "Rio de Janeiro",
            nights: 5,
            location: "Rio de Janeiro",
            departureDate: "10/12/2026",
            returnDate: "15/12/2026",
            hotelInfo: "Hotel Copacabana Palace",
            imageName: "riodejaneiro",
            price: 2499.90
        ),
        
        TravelPackage(
            title: "Paris",
            nights: 7,
            location: "Paris, França",
            departureDate: "05/01/2027",
            returnDate: "12/01/2027",
            hotelInfo: "Hotel próximo à Torre Eiffel",
            imageName: "paris",
            price: 11499.90
        ),
        
        TravelPackage(
            title: "Orlando Adventure",
            nights: 10,
            location: "Orlando, EUA",
            departureDate: "20/02/2027",
            returnDate: "02/03/2027",
            hotelInfo: "Resort Disney",
            imageName: "orlando",
            price: 14999.90
        ),
        
        TravelPackage(
            title: "Gramado Experience",
            nights: 4,
            location: "Gramado, RS",
            departureDate: "10/07/2027",
            returnDate: "14/07/2027",
            hotelInfo: "Hotel no Centro",
            imageName: "gramado",
            price: 1899.90
        )
    ]
    
    var favoriteCount: Int {
        packages.filter { $0.isFavorite }.count
    }
    
    var favoritePackages: [TravelPackage] {
        packages.filter { $0.isFavorite }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(packages.indices, id: \.self) { index in
                        NavigationLink {
                            PackageDetailView(package: $packages[index])
                            
                        } label: {
                            
                            VStack {
                                TravelCardView(package: $packages[index])
                            }
                            
                        }
                        .background(.thinMaterial)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 20
                            )
                        )
                    }
                }
            }
            .padding()
            .navigationTitle("Explorar Viagens")
            .toolbar {
                NavigationLink {
                    
                    ScrollView {
                        
                        if favoritePackages.isEmpty {
                            
                            ContentUnavailableView(
                                "Nenhum Favorito",
                                systemImage: "heart.slash",
                                description:
                                    Text(
                                        "Adicione pacotes para visualizá-los aqui."
                                    )
                            )
                            
                        } else {
                            
                            LazyVStack(spacing: 20) {
                                
                                ForEach(favoritePackages) { package in
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Image(package.imageName)
                                            .resizable()
                                            .scaledToFit()
                                        
                                        VStack(alignment: .leading, spacing: 12) {
                                            
                                            Text(package.title)
                                                .font(.headline)
                                                .bold()
                                            
                                            Text(package.location)
                                                .font(.caption)
                                            
                                            Text(
                                                "R$ \(package.price, specifier: "%.2f")"
                                            )
                                            .bold()
                                            
                                        }
                                        .padding()
                                        
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(.thinMaterial)
                                    .clipShape(
                                        RoundedRectangle(
                                            cornerRadius: 20
                                        )
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                    .navigationTitle("Meus Favoritos")
                } label: {
        
                    ZStack {
                        Image(systemName: "heart.fill")
                        
                        if favoriteCount > 0 {
                            Text("\(favoriteCount)")
                                .font(.caption2)
                                .bold()
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                }
            }
        }
    }
}
    

struct DetailRow: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {

        HStack {

            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading) {

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
    }
}

struct ToolbarView: View {
    
    @Binding var package: TravelPackage
    
    var body: some View {
        
    }
}

struct TravelCardView: View {
    
    @Binding var package: TravelPackage
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            
            Image(package.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(package.title)
                    .font(.headline)
                
                
                Label(
                    package.location,
                    systemImage: "location.fill"
                )
                
                
                Text("\(package.nights) diárias")
                
                HStack {
                    Text(
                        "R$ \(package.price, specifier: "%.2f")"
                    )
                    .font(.title3)
                    .bold()
                
                    Spacer()
                
                    Button {
                        package.isFavorite.toggle()
                    
                    } label: {
                        
                        
                        Image(
                            systemName:
                                package.isFavorite
                            ? "heart.fill"
                            : "heart"
                        )
                        .font(.title2)
                        .foregroundStyle(
                            package.isFavorite
                            ? .red
                            : .gray
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct PackageDetailView: View {

    @Binding var package: TravelPackage

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Image(package.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                    
                VStack(alignment: .leading, spacing: 8) {

                    Text(package.title)
                        .font(.largeTitle)
                        .bold()

                    Label(
                        package.location,
                        systemImage: "location.fill"
                    )
                    
                }
                .padding()

                Divider()

                VStack(spacing: 16) {

                    DetailRow(
                        icon: "airplane.departure",
                        title: "Partida",
                        value: package.departureDate
                    )

                    DetailRow(
                        icon: "moon.fill",
                        title: "Diárias",
                        value: "\(package.nights) noites"
                    )

                    DetailRow(
                        icon: "airplane.arrival",
                        title: "Retorno",
                        value: package.returnDate
                    )
                }
                .padding()

                Divider()

                VStack(alignment: .leading, spacing: 10) {

                    Label(
                        "Hospedagem",
                        systemImage: "building.2.fill"
                    )
                    .font(.headline)

                    Text(package.hotelInfo)
                }.padding()

                Divider()

                VStack(alignment: .leading, spacing: 10) {

                    Text("Valor do pacote")
                        .font(.headline)

                    Text(
                        package.price.formatted(
                            .currency(code: "BRL")
                        )
                    )
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                }
                .padding()

                Button {

                    package.isFavorite.toggle()

                } label: {

                    Label(
                        package.isFavorite
                        ? "Remover dos favoritos"
                        : "Adicionar aos favoritos",
                        systemImage:
                            package.isFavorite
                            ? "heart.fill"
                            : "heart"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        package.isFavorite
                        ? .red.opacity(0.15)
                        : .blue.opacity(0.15)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 14)
                    )
                    .padding()
                }
                
                Button(action: {
                    
                }) {
                    Label("Reservar pacote", systemImage: "cart.fill")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                .padding()
                
            }
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
