
for version in 9.3 10 11; do

	docker build -t aghost7/pg-dev:"$version" .

	docker run --name pg-dev -d aghost7/pg-dev:"$version"

	sleep 5

	docker exec pg-dev psql -U postgres template1 -c 'select 1'

	docker exec -ti pg-dev bash -c 'which pgcli'

	docker kill pg-dev
	docker rm pg-dev
done
