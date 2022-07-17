FRONT_END_BINARY=frontApp
BROKER_BINARY=brokerApp
AUTH_BINARY=authApp
LOGGER_BINARY=loggerServiceApp
MAILER_BINARY=mailApp
LISTENER_BINARY=listenerApp

## up: starts all containers in the background without forcing build
up:
	@echo "Starting Docker images..."
	docker-compose up -d
	@echo "Docker images started!"

## up_build: stops docker-compose (if running), builds all projects and starts docker compose
up_build: build_front build_broker build_auth build_logger build_mailer build_listener
	@echo "Stopping docker images (if running...)"
	docker-compose down
	@echo "Building (when required) and starting docker images..."
	docker-compose up --build -d
	@echo "Docker images built and started!"

## down: stop docker compose
down:
	@echo "Stopping docker compose..."
	docker-compose down
	@echo "Done!"

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo "Building broker binary..."
	cd ../broker-service && env GOOS=linux CGO_ENABLED=0 go build -o ${BROKER_BINARY} ./cmd/api
	@echo "Done!"

## build_mailer: builds the build_mailer binary as a linux executable
build_mailer:
	@echo "Building mailer binary..."
	cd ../mail-service && env GOOS=linux CGO_ENABLED=0 go build -o ${MAILER_BINARY} ./cmd/api
	@echo "Done!"

## logger: builds the logger binary as a linux executable
build_logger:
	@echo "Building logger binary..."
	cd ../logger-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LOGGER_BINARY} ./cmd/api
	@echo "Done!"

## listener: builds the listener binary as a linux executable
build_listener:
	@echo "Building listener binary..."
	cd ../listener-service && env GOOS=linux CGO_ENABLED=0 go build -o ${LISTENER_BINARY} main.go
	@echo "Done!"

## build_auth: builds the auth binary as a linux executable
build_auth:
	@echo "Building auth binary..."
	cd ../authentication-service && env GOOS=linux CGO_ENABLED=0 go build -o ${AUTH_BINARY} ./cmd/api
	@echo "Done!"

## build_front: builds the frone end binary
build_front:
	@echo "Building front end binary..."
	cd ../front-end && env GOOS=linux CGO_ENABLED=0 go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo "Done!"

## start: starts the front end
start: build_front
	@echo "Starting front end"
	cd ../front-end && ./${FRONT_END_BINARY} &

## stop: stop the front end
stop:
	@echo "Stopping front end..."
	@-pkill -SIGTERM -f "./${FRONT_END_BINARY}"
	@echo "Stopped front end!"

install-protobuf-and-grpc:
	sudo apt install -y protobuf-compiler golang-goprotobuf-dev
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

build-protobuf:
	cd ../logger-service/logs && protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative logs.proto
	cd ../broker-service/logs && protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative logs.proto

build-and-push-images:
	cd caddy && docker image build -t maxkaemmerer/caddy:1.0.0 -f caddy.Dockerfile .
	cd caddy && docker image build -t maxkaemmerer/caddy-production:1.0.1 -f caddy.production.Dockerfile .
	cd ../front-end && docker image build -t maxkaemmerer/frontend:1.0.1 -f frontend.Dockerfile .
	cd ../mail-service && docker image build -t maxkaemmerer/mail-service:1.0.0 -f mail-service.Dockerfile .
	cd ../logger-service && docker image build -t maxkaemmerer/logger-service:1.0.1 -f logger-service.Dockerfile .
	cd ../broker-service && docker image build -t maxkaemmerer/broker-service:1.0.3 -f broker-service.Dockerfile .
	cd ../authentication-service && docker image build -t maxkaemmerer/auth-service:1.0.0 -f authentication-service.Dockerfile .
	cd ../listener-service && docker image build -t maxkaemmerer/listener-service:1.0.0 -f listener-service.Dockerfile .
	docker image push maxkaemmerer/caddy:1.0.0
	docker image push maxkaemmerer/caddy-production:1.0.1
	docker image push maxkaemmerer/frontend:1.0.1
	docker image push maxkaemmerer/logger-service:1.0.1
	docker image push maxkaemmerer/mail-service:1.0.0
	docker image push maxkaemmerer/broker-service:1.0.3
	docker image push maxkaemmerer/auth-service:1.0.0
	docker image push maxkaemmerer/listener-service:1.0.0