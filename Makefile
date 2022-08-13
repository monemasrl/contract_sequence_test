

init:
	@docker-compose up -d --build


test:
	mkdir -p ./tmp/test-results
	@docker-compose exec web odoo -i contract_sequence --stop-after-init --test-tags contract_sequence --http-port=8090 --config /etc/odoo/odoo-test.conf |tee ./tmp/test-results/output.txt
