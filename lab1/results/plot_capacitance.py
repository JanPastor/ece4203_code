import matplotlib.pyplot as plt
import os

# Widths from the assignment
widths = [8, 16, 32, 64]

# Extracted Total Power (Watts) from P=4 logs (assuming testing frequency is 250 MHz)
# W=8: 3.36e-04, W=16: 6.54e-04, W=32: 1.30e-03, W=64: 2.58e-03
P_total = [3.36e-4, 6.54e-4, 1.30e-3, 2.58e-3]

# Extracted Switching Power (Watts) from P=4 logs
P_switch = [2.65e-5, 5.68e-5, 1.18e-4, 2.46e-4]

# Constants
V_dd = 1.8  # Volts
f = 250e6   # 250 MHz (from P = 4 ns)

# Calculate Capacitance using P = 1/2 * C * V^2 * f  => C = 2P / (V^2 * f)
# Convert to picofarads (pF = 1e-12 F)
C_switch_pF = [ (2 * p) / ((V_dd**2) * f) * 1e12 for p in P_switch ]
C_total_pF = [ (2 * p) / ((V_dd**2) * f) * 1e12 for p in P_total ]

plt.figure(figsize=(9, 6))

# Plot Total Node Capacitance (Derived from Switching Power)
plt.plot(widths, C_switch_pF, marker='o', linestyle='-', color='forestgreen', markersize=8, linewidth=2, label='Capacitance (from Switching Power)')

# Plot Total Dynamic Node Capacitance (Derived from Total Power)
plt.plot(widths, C_total_pF, marker='s', linestyle='--', color='teal', markersize=8, linewidth=2, label='Capacitance (from Total Power)')

# Annotations (Switching)
for i, txt in enumerate(C_switch_pF):
    plt.annotate(f"{txt:.2f} pF", (widths[i], C_switch_pF[i]), textcoords="offset points", xytext=(0,10), ha='center', fontsize=9)

# Annotations (Total)
for i, txt in enumerate(C_total_pF):
    plt.annotate(f"{txt:.2f} pF", (widths[i], C_total_pF[i]), textcoords="offset points", xytext=(0,-15), ha='center', fontsize=9)

plt.title('Approximate Node Capacitance vs. Adder Bit Width\n(Assuming $\\alpha=1, V=1.8V, f=250MHz$)', fontsize=14, pad=15)
plt.xlabel('Register Bit Width (bits)', fontsize=12)
plt.ylabel('Capacitance (pF)', fontsize=12)
plt.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
plt.xticks(widths)
plt.legend(loc='upper left')
plt.tight_layout()

# Save
out_dir = r'C:\Users\janne-laptop\.gemini\antigravity\brain\92783bfa-a99b-43c9-bae4-b5176ef4c7f3\scratch'
os.makedirs(out_dir, exist_ok=True)
plt.savefig(os.path.join(out_dir, 'capacitance_vs_width.png'), dpi=150)
plt.savefig('lab1/results/capacitance_vs_width.png', dpi=150)
print("Capacitance plot successfully generated and saved.")
