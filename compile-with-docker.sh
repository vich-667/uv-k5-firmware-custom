#!/bin/sh

IMAGE_NAME="uvk5"

# -------------------- PREPARE DOCKER ----------------

prepare () {
    # Clean up old Docker artifacts
    echo "🧽 Cleaning up old Docker artifacts..."
    docker system prune -f --volumes >/dev/null 2>&1 || true

    # Always rebuild the Docker image to ensure latest code changes
    echo "⚙️ Rebuilding Docker image '$IMAGE_NAME' (base=${BASE})..."
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
    if ! docker build --pull -t "$IMAGE_NAME" .; then
        echo "❌ Failed to build docker image"
        exit 1
    fi
}

# -------------------- CLEAN ALL ---------------------

clean() {
    echo "🧽 Cleaning all"
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
    docker buildx prune -f || true
    # Optional: if you use buildx history tooling
    if command -v docker >/dev/null 2>&1 && docker buildx help history >/dev/null 2>&1; then
      docker buildx history ls | awk 'NR>1 {print $1}' | xargs docker buildx history rm || true
    fi
    make clean || true
}

# ------------------ BUILD VARIANTS ------------------

run() {
    echo "🔧 Running command \"$*\"..."
    docker run -v "$PWD:/app" -w "/app" "$IMAGE_NAME" /bin/bash -c "$*"
}

# ------------------ MENU ------------------

case "$1" in
    prepare) prepare ;;
    clean) clean ;;
    build) run make ;;
    help)
        echo "Usage: $0 {prepare|clean|build|\"cmd\"}"
        exit 1
        ;;
    *)
        run $*
        ;;
esac
