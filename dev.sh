#!/usr/bin/env bash

while :; do
	read -erp "Do you want to deploy or bring down the container? (deploy/down): " ans
	
	case "$ans" in
		deploy)
			docker compose -f docker/dev/compose.yaml up -d
			printf '%s\n' "Shipped"
			;;
		down)
			docker compose -f docker/dev/compose.yaml down
			printf '%s\n' "Removed"
			;;
		*)
			printf '%s\n' "Invalid option!"
			printf '%s\n' "Please enter 'deploy' or 'down'"
			;;
	esac
done