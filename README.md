# Home Server

## Useful Commands

### Container Management
- `docker logs {CONTAINER_NAME}`  
  Check logs of a running container

- `docker exec -it {CONTAINER_SERVICE_NAME} id`  
  Check which user is running inside a container

### Configuration
- `getent passwd 1000`  
  Lists user accounts on the system matching UID 1000
  
- `sudo chown -R 1000:1000 {FOLDER_PATH}`  
  Ensure mounted volume on host is owned by UID/GID 1000, matching the user in Docker Compose settings. Useful to fix permission issues from container services writting files from shared volumes with the host.

### Recyclarr
- Use templates from [guide-configs](https://recyclarr.dev/wiki/guide-configs/). For balanced Quality and broad compatibility of devices use the next templates:
  - Radarr: HD Bluray + WEB
  - Sonarr: WEB-1080p
- An example of current profiles used is included in the repo: `recyclarr.yml`. You can use it as the main config file found in `recyclarr/config` path.
- Use of secrets: [Link](https://recyclarr.dev/wiki/yaml/secrets-reference/).
