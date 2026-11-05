herdr_core_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$herdr_core_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <herdr_core_version> <build_version> [architecture]"
    echo "Example: $0 0.1.14 1 arm64"
    echo "Example: $0 0.1.14 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Debian architecture to the upstream tarball name
get_herdr_core_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "herdr-core-linux-x86_64"
            ;;
        "arm64")
            echo "herdr-core-linux-aarch64"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local herdr_core_release

    herdr_core_release=$(get_herdr_core_release "$build_arch")
    if [ -z "$herdr_core_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $herdr_core_release"

    # Clean up any previous builds for this architecture
    rm -rf "$herdr_core_release" || true
    rm -f "${herdr_core_release}.tar.gz" || true

    # Upstream publishes its builds on releases.herdr.dev, not on GitHub Releases
    if ! wget "https://releases.herdr.dev/core/${herdr_core_VERSION}/${herdr_core_release}.tar.gz"; then
        echo "❌ Failed to download herdr-core for $build_arch"
        return 1
    fi

    # The tarball holds only the static herdr-core binary, at its top level
    mkdir -p "$herdr_core_release"
    if ! tar -xzf "${herdr_core_release}.tar.gz" -C "$herdr_core_release"; then
        echo "❌ Failed to extract herdr-core for $build_arch"
        return 1
    fi

    rm -f "${herdr_core_release}.tar.gz"

    if [ ! -f "$herdr_core_release/herdr-core" ]; then
        echo "❌ Unexpected tarball layout: $herdr_core_release/herdr-core not found"
        return 1
    fi

    # One package for every suite: upstream ships one binary per architecture,
    # so only the old ~<suite> version suffix ever differed. The fixed ~gaofn
    # keeps it below the distro's own build of the same version.
    FULL_VERSION="$herdr_core_VERSION-${BUILD_VERSION}~gaofn_${build_arch}"
    echo "  Building $FULL_VERSION"

    if ! docker build . -t "herdr-core-$build_arch" \
        --build-arg herdr_core_VERSION="$herdr_core_VERSION" \
        --build-arg BUILD_VERSION="$BUILD_VERSION" \
        --build-arg FULL_VERSION="$FULL_VERSION" \
        --build-arg ARCH="$build_arch" \
        --build-arg HERDR_CORE_RELEASE="$herdr_core_release"; then
        echo "❌ Failed to build Docker image for $build_arch"
        return 1
    fi

    id="$(docker create "herdr-core-$build_arch")"
    if ! docker cp "$id:/herdr-core_$FULL_VERSION.deb" - > "./herdr-core_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb package for $build_arch"
        return 1
    fi

    if ! tar -xf "./herdr-core_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb contents for $build_arch"
        return 1
    fi

    # Clean up extracted directory
    rm -rf "$herdr_core_release" || true

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building herdr-core $herdr_core_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures (upstream publishes amd64 and arm64 only)
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la herdr-core_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi
