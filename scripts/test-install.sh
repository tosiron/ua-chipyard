#!/usr/bin/env bash

set -e

echo
echo "======================================"
echo "ECE 462/562 Chipyard Environment Test"
echo "======================================"
echo

cd /workspace/chipyard

echo "[1/4] Loading Chipyard environment..."
source env.sh

echo "[2/4] Checking RISC-V compiler..."
command -v riscv64-unknown-elf-gcc >/dev/null
echo "      PASS"

echo "[3/4] Checking CourseRocketConfig..."
cd sims/verilato

if [ ! -f simulator-chipyard.harness-CourseRocketConfig ]; then
    echo "      Simulator not yet built."
    echo "      Building CourseRocketConfig..."
    make CONFIG=CourseRocketConfig
fi

echo "[4/4] Running RISC-V ISA sanity test..."

./simulator-chipyard.harness-CourseRocketConfig \
    "$RISCV/riscv64-unknown-elf/share/riscv-tests/isa/rv64ui-p-simple"

echo
echo "======================================"
echo "Environment: PASS"
echo "======================================"