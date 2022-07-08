# xuzpgroup

codes for growth and TDDFT irradiation simulations in low-dimensional materials.


(1) Growth dynamics in low-dimensional materials, including

1-phasefield-graphene: simulation for six-symmetry morphologies with both rectangular and hexagonal boxes versions;
<!-- Ref: Pattern evolution characterizes the mechanism and eﬀiciency of CVD graphene growth. Carbon, 141, 316-322 (2019) -->

1-phasefield-TMDs: simulation for three-symmetry morphologies, with especially the covering zone treatment;
<!-- Ref: Structure evolution of hBN grown on molten Cu by regulating precursor flux during chemical vapor deposition. 2D Materials, 9, 015004 (2022). -->

1-levelset-1DGNRs: simulation for 1D morphology of graphene nanoribbons;
<!--Ref: In situ growth of large-area and self-aligned graphene nanoribbon arrays on liquid metal. National Science Review, 8(12), nwaa298 (2021) -->

1-diffusionreaction-hBN: simulation for coalescence of hBN islans;
<!-- Ref: Structure evolution of hBN grown on molten Cu by regulating precursor flux during chemical vapor deposition. 2D Materials, 9, 015004 (2022). -->

1-nucleationdensity-etching: simulated morphologies of etching patterns.
<!-- Ref: Oxygen-assisted anisotropic chemical etching of MoSe2 for enhanced phototransistors. Chemistry of Materials (2022). -->


(2) Irradiation tests and developed codes based on SIESTA using TDDFT, including

2-SummaryForSIESTA: rough summary of all functions;

2-timedependennt-ouput: add functions to output time-dependent charge density, Bader charge, DM matrix, DOS, or others;

2-sumDMfiles: for merged simulations systems;

2-compilelua: use LUA/flook;

2-NVT-TDDFT: using NVT in TDDFT, while all codes of TDDFT use NVE;

2-tensionscale-TDDFT: change cell and scale atoms in TDFFT, while all codes of TDDFT use NVE;

2-constantvelocity-TDDFT: this algorithm is commonly used for stopping power calculation;
