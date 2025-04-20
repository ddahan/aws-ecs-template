# Variables
COMPOSE_FILE=docker-compose.local.yml

# Default help target
.PHONY: help
help:
	@echo ""
	@echo "Available commands:"
	@echo "  make up           → Start all services with build"
	@echo "  make down         → Stop and remove all services"
	@echo "  make build        → Build Docker images"
	@echo "  make restart      → Rebuild and restart everything"
	@echo "  make logs         → Tail logs from all services"
	@echo "  make sh-back      → Open a shell in the backend container"
	@echo "  make sh-front     → Open a shell in the frontend container"
	@echo "  make reset-db     → Stop everything and delete the database volume"
	@echo ""

up:
	docker compose -f $(COMPOSE_FILE) up

down:
	docker compose -f $(COMPOSE_FILE) down

build:
	docker compose -f $(COMPOSE_FILE) build

restart: down up

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

sh-back:
	docker compose -f $(COMPOSE_FILE) exec back sh

sh-front:
	docker compose -f $(COMPOSE_FILE) exec front sh

reset-db:
	docker compose -f $(COMPOSE_FILE) down -v