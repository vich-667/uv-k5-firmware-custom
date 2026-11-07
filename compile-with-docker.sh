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
    make clean || true
    docker rmi "$IMAGE_NAME" 2>/dev/null || true
}

# ------------------ BUILD VARIANTS ------------------

run() {
    echo "🔧 Running command \"$*\"..."
    docker run -v "$PWD:/app" -w "/app" "$IMAGE_NAME" /bin/bash -c "$*"
}

# ------------------ MENU ------------------

case "$1" in
    dockerprepare) prepare ;;
    dockerclean) clean ;;
    build) run make ;;
    clean) run make clean ;;
    help)
        echo "Usage: $0 {prepare|clean|build|\"cmd\"}"
        exit 1
        ;;
    *)
        run $*
esac
