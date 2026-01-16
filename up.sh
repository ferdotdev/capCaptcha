#!/bin/bash

printf "¿You like to deploy or down the container? (deploy/down): "
read -r ans

if [[ "$ans" == "deploy" ]]; then
	docker compose -f docker/dev/compose.yaml up -d
	printf "Shipped\n"
else
	docker compose -f docker/dev/compose.yaml down
	printf "Removed\n"
fi