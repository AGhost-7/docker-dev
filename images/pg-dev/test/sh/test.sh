
for version in 9.6 10 11 12; do

	docker kill pg-dev || true
	docker rm pg-dev || true

	docker run --name pg-dev -d aghost7/pg-dev:"$version"

	sleep 10

	docker exec pg-dev psql -U postgres template1 -c 'select 1'

	docker exec pg-dev bash -c 'which pgcli'

	docker kill pg-dev
done
