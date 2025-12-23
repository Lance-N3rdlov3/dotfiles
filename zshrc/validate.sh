#!/bin/bash
#
# Basic validation script for Zsh configuration
# This script checks syntax and basic functionality without requiring Zsh to be installed
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Zsh Configuration Validation ==="
echo

# Check if files exist
echo "✓ Checking file existence..."
for file in .zshenv .zprofile .zshrc; do
    if [[ -f "$file" ]]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing!"
        exit 1
    fi
done
echo

# Check for basic syntax issues
echo "✓ Checking for common syntax issues..."

# Check for unmatched quotes
for file in .zshenv .zprofile .zshrc; do
    if grep -n "[^\\]\"[^\"]*$" "$file" | grep -v "^[[:space:]]*#"; then
        echo "  ⚠ Possible unmatched quotes in $file"
    fi
done

# Check for undefined variables used in conditionals
echo "  ✓ Checking OS detection variables..."
if grep -q "IS_LINUX\|IS_MACOS\|IS_HYDE" .zshrc; then
    if grep -q "export IS_LINUX\|export IS_MACOS\|export IS_HYDE" .zshenv; then
        echo "    ✓ OS detection variables defined in .zshenv"
    else
        echo "    ✗ OS detection variables used but not defined!"
        exit 1
    fi
fi
echo

# Check for source statements
echo "✓ Checking source statements..."
if grep -q 'source.*\.zshenv' .zshrc; then
    echo "  ✓ .zshrc sources .zshenv"
fi
if grep -q 'source.*\.zshenv' .zprofile; then
    echo "  ✓ .zprofile sources .zshenv"
fi
echo

# Check for duplicate PATH exports
echo "✓ Checking for proper PATH handling..."
path_count=$(grep -c "export PATH=" .zshenv || true)
if [[ $path_count -gt 3 ]]; then
    echo "  ⚠ Multiple PATH exports found in .zshenv (count: $path_count)"
    echo "    This might be intentional, but verify PATH is built correctly"
fi
echo

# Verify key sections exist
echo "✓ Checking for key configuration sections..."
sections=(
    "Shell Options"
    "History Configuration"
    "Completion System"
    "Key Bindings"
    "Prompt Configuration"
    "Plugins"
    "Aliases"
)

for section in "${sections[@]}"; do
    if grep -q "# $section" .zshrc; then
        echo "  ✓ $section section present"
    else
        echo "  ⚠ $section section not found"
    fi
done
echo

# Check for OS-specific conditionals
echo "✓ Checking OS-specific configurations..."
if grep -q "if \[\[ \$IS_LINUX -eq 1 \]\]" .zshrc; then
    echo "  ✓ Linux-specific configuration present"
fi
if grep -q "if \[\[ \$IS_MACOS -eq 1 \]\]" .zshrc; then
    echo "  ✓ macOS-specific configuration present"
fi
echo

echo "=== Validation Complete ==="
echo
echo "Note: This script performs basic checks only."
echo "For full validation, test the configuration in an actual Zsh shell."
echo
echo "To test:"
echo "  1. Install Zsh if not already installed"
echo "  2. Create symlinks to the configuration files"
echo "  3. Start a new Zsh shell"
echo "  4. Verify plugins and aliases work as expected"
