<script lang="ts">
	import type Departure from '$lib/entities/departure';
	import { getDepartures } from '$lib/sl_service';

	let trains = $state(new Array<Departure>());

	getDepartures().then((departures: void | Departure[]) => {
		if (departures) trains = departures;
	});
</script>

<h1>Next train! 123</h1>
<h2>Vällingby -> Centrum</h2>

{#each trains as train (train)}
	<p>{train.destination} - {train.departure_time.toGMTString()} - {train.empty_train}</p>
{/each}
