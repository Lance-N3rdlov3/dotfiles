#!/bin/bash
# Simple smoke test for the dotfiles installer

set -e

echo "=== Dotfiles Installer Smoke Test ==="
echo ""

# Test 1: Binary exists
echo "[TEST 1] Checking if binary exists..."
if [ ! -f "dotfiles-installer" ]; then
    echo "❌ FAIL: Binary not found. Run 'go build -o dotfiles-installer main.go' first."
    exit 1
fi
echo "✓ PASS: Binary exists"

# Test 2: Binary is executable
echo "[TEST 2] Checking if binary is executable..."
if [ ! -x "dotfiles-installer" ]; then
    echo "❌ FAIL: Binary is not executable"
    exit 1
fi
echo "✓ PASS: Binary is executable"

# Test 3: Source files exist
echo "[TEST 3] Checking source files..."
for file in "main.go" "go.mod" "README.md" ".gitignore"; do
    if [ ! -f "$file" ]; then
        echo "❌ FAIL: $file not found"
        exit 1
    fi
done
echo "✓ PASS: All source files exist"

# Test 4: Go code compiles
echo "[TEST 4] Testing Go compilation..."
go build -o test-installer main.go
if [ $? -ne 0 ]; then
    echo "❌ FAIL: Go compilation failed"
    exit 1
fi
rm -f test-installer
echo "✓ PASS: Code compiles successfully"

# Test 5: Check for security issues with go vet
echo "[TEST 5] Running go vet..."
go vet ./...
if [ $? -ne 0 ]; then
    echo "❌ FAIL: go vet found issues"
    exit 1
fi
echo "✓ PASS: No issues found by go vet"

# Test 6: Check formatting
echo "[TEST 6] Checking code formatting..."
if [ -n "$(gofmt -l main.go)" ]; then
    echo "⚠️  WARNING: Code is not formatted. Run 'gofmt -w main.go'"
else
    echo "✓ PASS: Code is properly formatted"
fi

echo ""
echo "=== All Tests Passed ==="
echo ""
echo "To run the installer interactively, execute:"
echo "  ./dotfiles-installer"
echo ""
echo "Note: The installer requires sudo privileges to install system packages."
