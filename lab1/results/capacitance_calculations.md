# Capacitance Calculations for netlist_8_1.v

This document outlines the capacitance calculations based on the power analysis reported in `sta_w8p1.log`.

## Known Variables
From the timing and power logs (`sta_w8p1.log` and `sta_w8p1.tcl`):
* **Switching Power ($P_{switch}$)** = $1.78 \times 10^{-4}$ W 
* **Voltage ($V_{dd}$)** = $1.8$ V (Operating voltage from `sky130_fd_sc_hd__tt_025C_1v80.lib`)
* **Frequency ($f$)** = $1$ GHz (Derived from the $1.0$ ns clock period observed in the path delays)

---

## Method 1: Using the simplified formula ($P = \frac{1}{2} \cdot \alpha \cdot C \cdot V^2 \cdot f$)

In this method, we use the standard dynamic power equation and assume the activity factor ($\alpha$) is **1** to simplify the math. 

$$P_{switch} = \frac{1}{2} \cdot \alpha \cdot C \cdot V_{dd}^2 \cdot f$$

By setting $\alpha = 1$, the equation becomes:
$$P_{switch} = \frac{1}{2} \cdot C \cdot V_{dd}^2 \cdot f$$

**Solving for C**:
$$C = \frac{2 \times P_{switch}}{V_{dd}^2 \times f}$$

**Plugging in the values**:
$$C = \frac{2 \times (1.78 \times 10^{-4} \text{ W})}{(1.8\text{ V})^2 \times (1 \times 10^9 \text{ Hz})}$$

$$C = \frac{3.56 \times 10^{-4}}{3.24 \times 10^9}$$

**Result**:
$$C \approx 109.87 \text{ fF}$$

Under these assumptions, the total effective capacitance of the given architecture is **$109.87 \text{ fF}$**.

---

## Method 2: Physical Capacitance of the Worst-Case Path

Alternatively, if you strictly need the combined lumped capacitance along the critical worst-case path observed during static timing analysis, we can sum the capacitance values directly from the node list.

The critical path traverses the following net capacitances:
* `b_r[0]`: $0.027$ pF
* `_060_`: $0.010$ pF  
* `_065_`: $0.016$ pF
* `_068_`: $0.014$ pF
* `_079_`: $0.020$ pF
* `_091_`: $0.008$ pF
* `_108_`: $0.002$ pF 
* `_119_`: $0.002$ pF 

**Result**: 
Sum of Path Capacitance = $0.099$ pF = **$99 \text{ fF}$**
