Prerequisites
Before starting the migration process, ensure you have the following:

*Access to the Kubernetes cluster where MySQL pods are running.
*MySQL root credentials for accessing the pods.
*The CSV file containing migration details for each database and user.


*Locate the corresponding pod and note down the namespace (<namespace>) and pod name (<pod>)*

bash
Copy code
kubectl get pods --all-namespaces | grep "<name>"

*Retrieve MySQL Root Password*

Extract the MySQL root password (<ROOT_PASSWORD>) from the pod's secret:
bash
Copy code
echo "<pod>" | grep -o '.*mysql'
kubectl get secret "<secret_name>" -n "<namespace>" -o yaml | grep "mysql-root-password:" | awk -F ': ' '{print $2}' | base64 -d

*Dump the database into a sample.sql file using the mysqldump command within the MySQL pod:*

bash
Copy code
kubectl exec -it "<pod>" -n "<namespace>" -- mysqldump --databases "<DATABASE>" -u root -p"<ROOT_PASSWORD>" --hex-blob --single-transaction --set-gtid-purged=OFF --default-character-set=utf8mb4 > <DUMP_FILE_NAME>.sql

*Copying the dump file into kubernetes pod:*

bash
Copy code
sed -i '1d' <DUMP_FILE_NAME>.sql
kubectl cp sample.sql "<pod>:/<DUMP_FILE_NAME>.sql" -n "<namespace>"


*execute inside the pod > log into mysql  and create DB,create User,import the DB,assigning privilages to user:*

executing inside pod:
bash
Copy code
kubectl exec -it "<pod>" -n "<namespace>" bash

Logging into the cloud sql:
bash
Copy code
mysql -h <SQL-IP> -u root -p

Running these commnad to perform required actions:
sql
Copy code
CREATE DATABASE IF NOT EXISTS '<DATABASE>';
USE '<DATABASE>';
SHOW DATABASES;
SOURCE s<DUMP_FILE_NAME>.sql;
CREATE USER '<NEW_USER>'@'%' IDENTIFIED WITH mysql_native_password BY '<NEW_USER_PASSWORD>';
REVOKE 'cloudsqlsuperuser'@'%' FROM '<NEW_USER>'@'%';
GRANT ALL PRIVILEGES ON '<DATABASE>.*' TO '<NEW_USER>'@'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR '<NEW_USER>'@'%';
Dump Database to sample.sql



*Validation changes:*

login inside the cloud sql instance:
bash
Copy code
gcloud sql connect helpr-test-db --user=root --quiet

Validating the table and data:
sql
Copy code
SHOW DATABASES;
USE '<DATABASE>';
SHOW TABLES;
