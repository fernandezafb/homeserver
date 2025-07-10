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
