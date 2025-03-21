import Departure from './entities/departure';

const STATION_ID = 9103;
const PREVIOUS_STATION_ID = 9102;
const TRANSPORT = 'METRO';
const DIRECTION = 2;
const FORECAST = 30;
const DEPARTURES_URL = 'https://transport.integration.sl.se/v1/sites/${STATION_ID}/departures';
const DELAY_DIFFERENCE = 3600000;

export async function getDepartures(): Promise<void | Departure[]> {
	return Promise.all([
		getDeparturesFromStation(STATION_ID),
		getDeparturesFromStation(PREVIOUS_STATION_ID)
	]).then((results) => {
		const departures: Departure[] = [];
		const station_departures = results[0];
		const previous_stations = results[1];

		if (!station_departures) return [];

		for (const departure of station_departures) {
			departures.push(departure);
			if (!previous_stations) continue;

			for (const prev_departure of previous_stations) {
				departure.empty_train = !areDeparturesTheSame(departure, prev_departure);
			}
		}

		return departures;
	});
}

function areDeparturesTheSame(d1: Departure, d2: Departure): boolean {
	const diff = d1.departure_time.getTime() - d2.departure_time.getTime();
	if (d1.destination == d2.destination) {
		if (diff < DELAY_DIFFERENCE) {
			return true;
		} else {
			return false;
		}
	}
}

async function getDeparturesFromStation(station_id: number): Promise<void | Departure[]> {
	const params = new URLSearchParams();
	params.append('transport', TRANSPORT);
	params.append('direction', DIRECTION.toString());
	params.append('forecast', FORECAST.toString());

	const url = DEPARTURES_URL.replace('${STATION_ID}', station_id.toString());

	return fetch(`${url}?${params}`)
		.then((response) => response.json())
		.then((json) => {
			const result = new Array<Departure>();
			for (const departure of json.departures) {
				result.push(new Departure(departure.destination, new Date(departure.expected)));
			}
			return result;
		});
}
