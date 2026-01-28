#!/usr/bin/env bash

while :; do
	read -erp "Do you want to deploy or bring down the container? (deploy/down): " ans
	
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
			;;
	esac
done