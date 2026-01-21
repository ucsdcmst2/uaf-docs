# Makefile for building MkDocs project

# Variables
MKDOCS = mkdocs
SOURCE_PATH = source
DOCS_DIR = docs
BUILD_DIR = ../../uaf

# Default target
all: build

# Build the MkDocs project
build:
	$(MKDOCS) build --clean --config-file $(SOURCE_PATH)/mkdocs.yml --site-dir $(BUILD_DIR)

# Serve the MkDocs project locally
serve:
	$(MKDOCS) serve

# Clean the build directory
clean:
	rm -rf $(BUILD_DIR)/*

# Phony targets
.PHONY: all build serve clean