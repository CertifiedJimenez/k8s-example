# K8s test setup
NAMESPACE := default

.PHONY: cluster-up cluster-down install uninstall reset run stop status

cluster-up:
	minikube start

cluster-down:
	minikube stop

install:
	helm upgrade --install backend ./charts/backend -n $(NAMESPACE) --wait --timeout 120s
	helm upgrade --install frontend ./charts/frontend -n $(NAMESPACE) --wait --timeout 120s

uninstall:
	helm uninstall frontend -n $(NAMESPACE) 2>/dev/null || true
	helm uninstall backend -n $(NAMESPACE) 2>/dev/null || true

reset: uninstall

run: cluster-up install
	minikube service frontend

stop:
	@echo "Run 'make uninstall' to remove releases, 'make cluster-down' to stop minikube"

status:
	kubectl get pods,svc -l 'app in (backend,frontend)'
