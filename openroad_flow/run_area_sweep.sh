#!/bin/bash
# ECE 4203 - Area + Screenshot sweep
# Runs all 6 configs, extracts area, pauses for screenshots

VFILE="designs/src/adder64_pipelined/adder64_pipelined.v"

echo "=== AREA RESULTS ===" > area_results.txt

for S in 2 4 8 16 32 64; do
  C=$((64 / S))
  echo ""
  echo "=============================="
  echo "  STAGES=$S  CHUNK=$C"
  echo "=============================="

  sed -i -E "s/localparam STAGES = [0-9]+;/localparam STAGES = ${S};/" "$VFILE"
  sed -i -E "s/localparam CHUNK = [0-9]+;/localparam CHUNK = ${C};/" "$VFILE"

  grep "localparam" "$VFILE" | head -2

  make clean_all
  make

  AREA=$(grep -r "Design area" logs/sky130hd/adder64_pipelined/base/ 2>/dev/null | head -1)
  echo "STAGES=$S: $AREA" | tee -a area_results.txt

  echo ""
  echo ">>> Opening GUI for screenshot. Close GUI when done. <<<"
  make gui_final

  echo "STAGES=$S done."
  echo ""
done

echo ""
echo "=== ALL DONE ==="
echo ""
cat area_results.txt
echo ""
echo "Results saved to area_results.txt"
