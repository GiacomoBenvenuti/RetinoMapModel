# RetinoMapModel

This repository contains a Matlab function to generate a retinotopic model (**RetinoModel.m**),
and a function to fit the model to a real retinotopic map (**FitRetino.m**).
To see how these two functions work, I provided a Demo script (DEMO.m) and some "real" test data (**/testdata**).

In order to run the fit, you need to add to the Matlab path a library called "bads" (Bayesian minimization algorithm).
You can download this free library [here](https://github.com/lacerbi/bads).

Here you can see a preview of the figures that you will be able to generate with the demo.
* First, the projection of a grid in the visual space to the retinotopic map. The colors of the lines in the left panels correspond to the
colors in the right panels. Please notice that the right hemisphere is represented on the left of the black line (2nd and 4th panels) and the left
one on the right. For both hemispheres the fovea is at X = 0 and Y = 0.
![DemoGrid](./figures/DemoGrid.png)

* Second, a visualization of the real retinotopic data provided.
![RealRetino](./figures/RealRetino.png)

* Third, the results of the fit of this data with the model
![RealRetino](./figures/FitRetino.png)

* Now that we have "calibrated" the model by estimating the good set of parameters to reproduce the data, we can generate any stimulus we like over the two hemispheres.
If you want to see how to project visual stimuli to the retinotopic map check this other repository.

## More about the model
This model takes cartesian visual coordinates as an input and returns cartesian retinotopic coordinates as an output.
