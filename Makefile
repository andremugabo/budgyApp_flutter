REGISTRY ?= ghcr.io/your-org
BN_IMAGE ?= $(REGISTRY)/budgy-backend
FN_IMAGE ?= $(REGISTRY)/budgy-frontend
TAG ?= latest

.PHONY: build up down logs push push-bn push-fn

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

push: push-bn push-fn

push-bn:
	docker build -t $(BN_IMAGE):$(TAG) ./BN/Budgy
	docker push $(BN_IMAGE):$(TAG)

push-fn:
	docker build -t $(FN_IMAGE):$(TAG) --build-arg BUDGY_API_BASE_URL=http://backend:8080 ./FN
	docker push $(FN_IMAGE):$(TAG)



