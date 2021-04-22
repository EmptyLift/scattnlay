import mpmath as mp
import numpy as np
complex_arguments = [
    # // x, [Re(m), Im(m)], Qext, Qsca, test_name
    # [10000, [1.33,1e-5], 2.004089, 1.723857, 'f'],
    # [10000, [1.5, 1],    2.004368, 1.236574, 'j'],
    # [10000, [10,  10],   2.005914, 1.795393, 'm'],
    # [80, [1.05,  1],   0, 0, 'Yang'],
    # [0.099, [0.75,0], 7.417859e-06, 7.417859e-06, 'a'],
    # [0.101, [0.75,0], 8.033538e-06, 8.033538e-06, 'b'],
    # [10,    [0.75,0],     2.232265, 2.232265, 'c'],
    # [1000,  [0.75,0],     1.997908, 1.997908, 'd'],
    [100,   [1.33,1e-5], 2.101321, 2.096594, 'e'],
    # [0.055, [1.5, 1],    0.101491, 1.131687e-05, 'g'],
    # [0.056, [1.5, 1],   0.1033467, 1.216311e-05, 'h'],
    # [100,   [1.5, 1],    2.097502, 1.283697, 'i'],
    # [1,     [10,  10],   2.532993, 2.049405, 'k'],
    # [100,   [10,  10,],  2.071124, 1.836785, 'l'],
    # [1, [mp.pi,  1],   0, 0, 'pi'],
    # [1, [mp.pi,  -1],   0, 0, 'pi'],
    # [1, [mp.pi,  mp.pi],   0, 0, 'pi'],
    # [1, [2*mp.pi,  -1],   0, 0, 'pi'],
    # [1, [2*mp.pi,  mp.pi],   0, 0, 'pi'],
    # [1, [2*mp.pi,  1],   0, 0, 'pi'],
    # [1, [mp.pi,  0],   0, 0, 'pi'],
    # [1, [np.pi,  0],   0, 0, 'pi'],
    # [2.03575204,[1.4558642,0.20503704],1.952484, 0.9391477, 'water r=1mkm scattnlay 2020/04/22']

]
