#!/usr/bin/env bash

printf "Do you want to deploy or bring down the container? (deploy/down): "
read -r ans

case "$ans" in
	deploy)
		docker compose -f docker/dev/compose.yaml up -d
		printf "Shipped\n"
		;;
	down)
		docker compose -f docker/dev/compose.yaml down
		printf "Removed\n"
		;;
	*)
		printf "Invalid option: %s. Please enter 'deploy' or 'down'.\n" "$ans"
		exit 1
		;;
esac