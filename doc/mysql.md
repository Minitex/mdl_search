# MySQL

While the catalog data is stored within Solr, there is some additional data that resides in MySQL. We use the database primarily for [Spotlight's](https://github.com/projectblacklight/spotlight) CMS-like features, but there are a few other things stored there as well, such as admin user accounts, archive download requests, background job info, etc.

It runs on the same server as the web app and Solr. The server hostnames are as follows

| Environment | Hostname
|-------------|----------
| QA          | mtx-reflectqa-qat2.oit.umn.edu
| Production  | mtx-reflection-prd.oit.umn.edu

MySQL is not under the supervision of Systemd, so if the server is restarted or the process otherwise dies, it will need to be manually restarted. To start MySQL, SSH to the host server and run:

```bash
sudo mysqld_safe &
```
