require "rails_helper"

RSpec.describe "Flights Index Page" do
  before(:each) do
    @airline_1 = Airline.create!(name: "Southwest")
    @airline_2 = Airline.create!(name: "Delta")

    @flight_1 = @airline_1.flights.create!(number: "123", date: "01/01/23", departure_city: "Denver", arrival_city: "Las Vegas")
    @flight_2 = @airline_1.flights.create!(number: "456", date: "01/05/23", departure_city: "Denver", arrival_city: "St Louis")
    @flight_3 = @airline_2.flights.create!(number: "789", date: "01/02/23", departure_city: "Chicago", arrival_city: "New York")

    @passenger_1 = Passenger.create!(name: "Michael", age: 9) 
    @passenger_2 = Passenger.create!(name: "Meg", age: 17)
    @passenger_3 = Passenger.create!(name: "Hector", age: 29)
    @passenger_4 = Passenger.create!(name: "Linda", age: 39)
    @passenger_5 = Passenger.create!(name: "Sally", age: 81)
    @passenger_6 = Passenger.create!(name: "Bob", age: 4)

    @fp_1 = FlightPassenger.create!(flight: @flight_1, passenger: @passenger_1)
    @fp_2 = FlightPassenger.create!(flight: @flight_1, passenger: @passenger_2)
    @fp_3 = FlightPassenger.create!(flight: @flight_1, passenger: @passenger_3)
    @fp_4 = FlightPassenger.create!(flight: @flight_2, passenger: @passenger_4)
    @fp_5 = FlightPassenger.create!(flight: @flight_2, passenger: @passenger_1)
    @fp_6 = FlightPassenger.create!(flight: @flight_3, passenger: @passenger_5)
    @fp_7 = FlightPassenger.create!(flight: @flight_3, passenger: @passenger_6)
    @fp_8 = FlightPassenger.create!(flight: @flight_3, passenger: @passenger_4)
  end

  # User Story 1
  it "displays a list of all flight numbers and the name of the airline next to it" do
    visit flights_path

    expect(page).to have_content("#{@flight_1.number} - #{@flight_1.airline.name}")
    expect(page).to have_content("#{@flight_2.number} - #{@flight_2.airline.name}")
    expect(page).to have_content("#{@flight_3.number} - #{@flight_3.airline.name}")
  end

  it "displays the names of all passengers on each flight" do
    visit flights_path

    within("#flight-#{@flight_1.id}") do
      expect(page).to have_content(@passenger_1.name)
      expect(page).to have_content(@passenger_2.name)
      expect(page).to have_content(@passenger_3.name)
      expect(page).to_not have_content(@passenger_4.name)
    end

    within("#flight-#{@flight_2.id}") do
      expect(page).to have_content(@passenger_4.name)
      expect(page).to have_content(@passenger_1.name)
      expect(page).to_not have_content(@passenger_2.name)
    end

    within("#flight-#{@flight_3.id}") do
      expect(page).to have_content(@passenger_5.name)
      expect(page).to have_content(@passenger_6.name)
      expect(page).to have_content(@passenger_4.name)
      expect(page).to_not have_content(@passenger_1.name)
    end
  end

  # User Story 2
  it "displays a button next to each passengers name to remove them from that flight" do
    visit flights_path

    within("#flight-#{@flight_1.id}") do
      expect(page).to have_content(@passenger_1.name)
      expect(page).to have_content(@passenger_2.name)
      expect(page).to have_content(@passenger_3.name)

      expect(page).to have_button("Remove Passenger")
      click_button("Remove Passenger", match: :first)

      expect(page).to have_current_path(flights_path)
      expect(page).to_not have_content(@passenger_1.name)
    end

    within("#flight-#{@flight_2.id}") do
      expect(page).to have_content(@passenger_1.name) # Passenger_1 on flight_2 is unaffected by removing him from flight_1
    end
  end
end