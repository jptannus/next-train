class Departure {
	destination: string;
	departure_time: Date;
	empty_train: boolean;

	constructor(destination: string, departure_time: Date) {
		this.destination = destination;
		this.departure_time = departure_time;
		this.empty_train = false;
	}
}

export default Departure;
