export PGPASSWORD:=odoo
up:
	docker-compose up -d --build

down:
	docker-compose down

addon_scaffold:
	docker exec -it --user root web /usr/bin/odoo scaffold $(ADDON_NAME) /mnt/extra-addons

rebuild:
	docker-compose down
	docker-compose up -d --build

generate_local_coverage_report:
	# docker exec -it web pytest -r -s --odoo-database=db_test --junitxml=coverage/local/junit.xml /mnt/addons/
	docker exec -it web pytest -r -s --odoo-database=db_test --resultlog=coverage/local/report.log /mnt/addons/
	docker cp web:/coverage/local coverage

generate_coverage_report:
	-docker exec -it -u root web coverage run /usr/bin/odoo -d db_test --test-enable -p 8001 --stop-after-init --log-level=test
	docker exec -it -u root web coverage html -d /coverage/all
	docker cp web:/coverage/all coverage

init_test_db:
	docker stop web
	docker exec -t db psql -U odoo -d postgres -c "DROP DATABASE IF EXISTS db_test"
	docker exec -t db psql -U odoo -d postgres -c "CREATE DATABASE db_test"
	docker start web
	docker exec -u root -t web odoo -i contract_sequence -d db_test --stop-after-init --no-http

cat_report:
	cat coverage/junit.xml