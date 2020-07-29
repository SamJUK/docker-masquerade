# Docker Masquerade
Docker image files for Masquerade

## Example usage
```sh
docker run samjuk/masquerade run --platform=magento2  --host=127.0.0.1 --prefix=client_ --database=client_anonymised --username=client --password=client --locale=en_GB
```

## Run locally self-contained
```sh
sh ./anonimize.sh /path/to/sql/file.sql
```
