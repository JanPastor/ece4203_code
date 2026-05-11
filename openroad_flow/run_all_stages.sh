#!/bin/bash
# ==============================================================================
# ECE 4203 - Pipelined 64-bit Adder - OpenROAD Sweep Script
# Runs implementation for STAGES = 2, 4, 8, 16, 32, 64
# CHUNK = 64 / STAGES
# ==============================================================================

VERILOG_FILE="designs/src/adder64_pipelined/adder64_pipelined.v"
RESULTS_BASE="results/sky130hd/adder64_pipelined/base"
REPORTS_BASE="reports/sky130hd/adder64_pipelined/base"

# Output summary file
SUMMARY_FILE="stage_sweep_summary.txt"

# Clear previous summary
echo "=============================================" > $SUMMARY_FILE
echo "ECE 4203 - Pipelined 64-bit Adder Results" >> $SUMMARY_FILE
echo "=============================================" >> $SUMMARY_FILE
echo "" >> $SUMMARY_FILE

# Configurations: STAGES CHUNK
CONFIGS=(
  "2 32"
  "4 16"
  "8 8"
  "16 4"
  "32 2"
  "64 1"
)

for config in "${CONFIGS[@]}"; do
  read -r STAGES CHUNK <<< "$config"

  echo ""
  echo "========================================================"
  echo "  Running STAGES=$STAGES, CHUNK=$CHUNK"
  echo "========================================================"
  echo ""

  # 1. Modify the Verilog file — update STAGES and CHUNK parameters
  sed -i "s/localparam STAGES = [0-9]\+;/localparam STAGES = ${STAGES};/" "$VERILOG_FILE"
  sed -i "s/localparam CHUNK = [0-9]\+;/localparam CHUNK = ${CHUNK};/" "$VERILOG_FILE"

  echo "Updated $VERILOG_FILE:"
  grep "localparam STAGES" "$VERILOG_FILE"
  grep "localparam CHUNK" "$VERILOG_FILE"

  # 2. Clean all previous results
  make clean_all

  # 3. Run the full OpenROAD flow
  make

  # 4. Check if the report was generated
  REPORT_FILE="${REPORTS_BASE}/6_finish.rpt"
  if [ ! -f "$REPORT_FILE" ]; then
    echo "ERROR: $REPORT_FILE not found for STAGES=$STAGES!"
    echo "STAGES=$STAGES: FAILED" >> $SUMMARY_FILE
    continue
  fi

  # 5. Copy the report file for archival
  mkdir -p "saved_reports"
  cp "$REPORT_FILE" "saved_reports/6_finish_stages${STAGES}.rpt"
  echo "Report saved to saved_reports/6_finish_stages${STAGES}.rpt"

  # 6. Extract key metrics from the report
  echo "" >> $SUMMARY_FILE
  echo "========================================" >> $SUMMARY_FILE
  echo "STAGES = $STAGES, CHUNK = $CHUNK" >> $SUMMARY_FILE
  echo "========================================" >> $SUMMARY_FILE

  echo "--- Full Report ---" >> $SUMMARY_FILE
  cat "$REPORT_FILE" >> $SUMMARY_FILE
  echo "" >> $SUMMARY_FILE

  # Extract specific values
  echo "--- Key Metrics ---" >> $SUMMARY_FILE

  # Area
  AREA=$(grep -i "Design area" "$REPORT_FILE" | head -1)
  echo "Area: $AREA" >> $SUMMARY_FILE

  # Worst setup slack
  SLACK=$(grep -i "worst slack" "$REPORT_FILE" | head -1)
  if [ -z "$SLACK" ]; then
    SLACK=$(grep -i "wns" "$REPORT_FILE" | head -1)
  fi
  echo "Worst Setup Slack: $SLACK" >> $SUMMARY_FILE

  # Power
  POWER=$(grep -i "Total" "$REPORT_FILE" | grep -i "power" | head -3)
  echo "Power Info:" >> $SUMMARY_FILE
  echo "$POWER" >> $SUMMARY_FILE

  echo "" >> $SUMMARY_FILE

  echo "Done with STAGES=$STAGES"
  echo ""
done

echo ""
echo "========================================================"
echo "  ALL RUNS COMPLETE"
echo "========================================================"
echo ""
echo "Summary saved to: $SUMMARY_FILE"
echo "Individual reports in: saved_reports/"
echo ""
echo "To view final layouts, run for each stage:"
echo "  make gui_final"
echo "(after setting the appropriate STAGES/CHUNK in the Verilog file)"
