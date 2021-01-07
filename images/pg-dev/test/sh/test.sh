
podman kill pg-dev || true
podman rm pg-dev || true

podman run --name pg-dev -d "$IMAGE"

sleep 10

podman exec pg-dev psql -U postgres template1 -c 'select 1'

podman exec pg-dev bash -c 'which pgcli'

podman kill pg-dev
