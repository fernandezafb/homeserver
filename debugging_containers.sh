BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' #no color

deploy_containers() {
    echo -e "${BLUE}🐳 Deploying containers...${NC}"
    
    # Get list of services from compose file
    local services
    services=$(sudo docker compose -f /docker/docker-compose.yml config --services 2>/dev/null)
    if [ $? -ne 0 ] || [ -z "$services" ]; then
        echo -e "${RED}❌ Failed to get services list from compose file${NC}" >&2
        return 1
    fi

    # Pull each image individually
    local pull_errors=0
    for service in $services; do
        echo -e "${BLUE}⬇️ Pulling image for $service...${NC}"
        if ! sudo docker compose -f /docker/docker-compose.yml pull "$service"; then
            echo -e "${RED}❌ Failed to pull image for $service${NC}" >&2
            ((pull_errors++))
            continue
        fi
        echo -e "${GREEN}✔ Successfully pulled image for $service${NC}"
    done

    if [ $pull_errors -gt 0 ]; then
        echo -e "${YELLOW}⚠ $pull_errors service(s) had pull errors${NC}" >&2
    fi

    # Start containers with error reporting
    echo -e "${BLUE}🚀 Starting containers...${NC}"
    local start_errors=0
    for service in $services; do
        echo -e "${BLUE}🔁 Starting $service...${NC}"
        if ! sudo docker compose -f /docker/docker-compose.yml up -d --no-deps "$service"; then
            echo -e "${RED}❌ Failed to start $service${NC}" >&2
            ((start_errors++))
            # Show container logs if available
            if sudo docker compose -f /docker/docker-compose.yml ps "$service" | grep -q "Up"; then
                echo -e "${YELLOW}⚠ Showing logs for $service:${NC}"
                sudo docker compose -f /docker/docker-compose.yml logs --tail=20 "$service"
            fi
            continue
        fi
        echo -e "${GREEN}✔ Successfully started $service${NC}"
    done

    if [ $start_errors -gt 0 ]; then
        echo -e "${RED}❌ $start_errors service(s) failed to start${NC}" >&2
        return 1
    fi

    # Cleanup and final status
    echo -e "${BLUE}🧹 Cleaning up unused images...${NC}"
    sudo docker image prune -f
    echo -e "${GREEN}✔ Container deployment complete${NC}"
    
    # Show final status
    echo -e "\n${BLUE}📊 Final container status:${NC}"
    sudo docker compose -f /docker/docker-compose.yml ps
}