import matplotlib.pyplot as plt
import os

widths = [8, 16, 32, 64]

# Smallest possible clock period based on actual slack values for P=4 constraint that passed
# T_min = Period - Slack = 4.0 - Slack
t_min_p4 = [4.0 - 1.97, 4.0 - 1.76, 4.0 - 1.07, 4.0 - 0.24]
freq_p4 = [1000 / t for t in t_min_p4]  # Hz -> MHz

# For comparison, aggressive synthesis (P=1) resulting minimum periods
# T_min = 1.0 - Slack
t_min_p1 = [1.0 - (-0.34), 1.0 - (-0.61), 1.0 - (-0.97), 1.0 - (-1.26)]
freq_p1 = [1000 / t for t in t_min_p1]

plt.figure(figsize=(9, 6))
plt.plot(widths, freq_p4, marker='s', linestyle='-', color='dodgerblue', markersize=8, linewidth=2, label='Max Frequency (Standard Passing Netlist)')
plt.plot(widths, freq_p1, marker='o', linestyle='--', color='tomato', markersize=8, linewidth=2, label='Theoretical Max Freq (Aggressive Synthesis)')

# Annotate points for passing netlist
for i, txt in enumerate(freq_p4):
    plt.annotate(f"{txt:.1f} MHz", (widths[i], freq_p4[i]), textcoords="offset points", xytext=(0,-15), ha='center', fontsize=9)

for i, txt in enumerate(freq_p1):
    plt.annotate(f"{txt:.1f} MHz", (widths[i], freq_p1[i]), textcoords="offset points", xytext=(0,10), ha='center', fontsize=9)

plt.title('Maximum Operating Frequency vs. Adder Bit Width', fontsize=14, pad=15)
plt.xlabel('Register Bit Width (bits)', fontsize=12)
plt.ylabel('Maximum Frequency (MHz)', fontsize=12)
plt.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
plt.xticks(widths)
plt.legend(loc='best')
plt.tight_layout()

# Save locally to project results and specifically to the Artifacts directory
os.makedirs(r'C:\Users\janne-laptop\.gemini\antigravity\brain\92783bfa-a99b-43c9-bae4-b5176ef4c7f3\scratch', exist_ok=True)
plt.savefig(r'C:\Users\janne-laptop\.gemini\antigravity\brain\92783bfa-a99b-43c9-bae4-b5176ef4c7f3\scratch\max_freq_vs_width.png', dpi=150)
plt.savefig('lab1/results/max_freq_vs_width.png', dpi=150)
print("Plot successfully generated and saved.")
