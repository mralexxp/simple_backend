APP_NAME=homemeshnet
BUILD_PATH=./build
TARGET=linux_amd64
REMOTE_PATH=/tmp

# Получение IP из аргумента или переменной окружения:
# make deploy RUN_IP=192.168.1.2
# make run RUN_IP=192.168.1.2
.PHONY: all build clean deploy run deploy-run

build:
	mkdir -p $(BUILD_PATH)
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(BUILD_PATH)/$(APP_NAME) .

clean:
	rm -rf $(BUILD_PATH)

deploy:
ifndef RUN_IP
	$(error RUN_IP is not set. Use: make deploy RUN_IP=192.168.1.2)
endif
	scp -O $(BUILD_PATH)/$(APP_NAME) root@$(RUN_IP):$(REMOTE_PATH)/

run:
ifndef RUN_IP
	$(error RUN_IP is not set. Use: make run RUN_IP=192.168.1.2)
endif
	ssh root@$(RUN_IP) 'chmod +x $(REMOTE_PATH)/$(APP_NAME) && $(REMOTE_PATH)/$(APP_NAME)'

stop:
ifndef RUN_IP
	$(error RUN_IP is not set. Use: make stop RUN_IP=192.168.1.2)
endif
	ssh root@$(RUN_IP) 'killall -q $(APP_NAME) || true'

# Вариант: деплой и сразу запуск в одну команду
deploy-run: build deploy run

