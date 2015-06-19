

t = linspace(-2, 3, 4)

# !!! check k = 2 !!!
f = (t,k) -> k+k/2*t+(1-k/2)*t*t

k = slider "freq-slider"

plot "poly", [t+3, t], [f(t, k), f(t,1)]

abs = (u) -> Math.abs(u)

labels = [["A"],["B"],["C"]]
heights = [[abs(k)], [abs(k/2)], [abs(1-k/2)]]

#bar "coeffs", [[0],[0],[0]], heights #, labels
bar "coeffs", heights
#bar "coeffs", heights, ["W", "B"]
#bar "coeffs", [[0],[0],[0]], heights
#bar "coeffs", [[0]], heights
#bar "coeffs", [0], heights
#bar "coeffs", 0, heights
