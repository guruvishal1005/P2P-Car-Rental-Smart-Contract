module MyModule::CarRental {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a car rental agreement
    struct Rental has store, key {
        owner: address,      // Car owner
        renter: address,     // Person renting the car
        price: u64,          // Rental price
        active: bool,        // Rental status
    }

    /// Create a new car rental listing
    public fun create_rental(owner: &signer, price: u64) {
        let rental = Rental {
            owner: signer::address_of(owner),
            renter: @0x0,
            price,
            active: true,
        };
        move_to(owner, rental);
    }

    /// Rent the car by paying the rental price
    public fun rent_car(renter: &signer, car_owner: address) acquires Rental {
        let rental = borrow_global_mut<Rental>(car_owner);

        let payment = coin::withdraw<AptosCoin>(renter, rental.price);
        coin::deposit<AptosCoin>(rental.owner, payment);

        rental.renter = signer::address_of(renter);
        rental.active = false;
    }
}
