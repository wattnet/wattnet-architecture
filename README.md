<div align="left">
  <picture>
    <source media="(prefers-color-scheme: dark)"
            srcset="https://github.com/wattnet/.github/raw/main/images/wattnet-logo-full-dark-transparent-cropped.png" />
    <source media="(prefers-color-scheme: light)"
            srcset="https://github.com/wattnet/.github/raw/main/images/wattnet-logo-full-light-transparent-cropped.png" />
    <img src="https://github.com/wattnet/.github/raw/main/images/wattnet-logo-full-light-transparent-cropped.png"
         alt="Wattnet Logo"
         width="300" />
  </picture>
</div>

# Platform Architecture

C4 model of the Wattnet platform architecture. This repository contains diagrams and code (Structurizr DSL) that document the system’s structure, components, and interactions across multiple levels of abstraction.

## Overview

The architecture is organized into four main levels:

1. **Context Diagram**: Provides a high-level view of the system and its interactions with external entities.
2. **Container Diagram**: Breaks down the system into its main containers (applications, services, databases, etc.) and shows how they interact.
3. **Component Diagram**: Details the internal structure of each container, showing the components and their relationships.
4. **Code Diagram**: Provides a detailed view of the code structure, including classes, interfaces, and their interactions. _(Not included in this repository)_

The diagrams are created using the C4 model, which emphasizes clarity and simplicity in representing software architecture. The Structurizr DSL code allows for easy maintenance and updates to the diagrams as the system evolves.

## Viewing the diagrams

The diagrams can be viewed and edited interactively using [Structurizr Lite](https://docs.structurizr.com/lite). From the root of the repository, run:

```bash
docker run -it --rm \
  -p 8080:8080 \
  -v "$(pwd)/dsl:/usr/local/structurizr" \
  structurizr/lite:2024.12.07
```

Then open [http://localhost:8080](http://localhost:8080) in your browser. Structurizr Lite watches `dsl/workspace.dsl` for changes and keeps `dsl/workspace.json` in sync automatically.

## Repository structure

- `/diagrams`: Contains the generated diagrams in various formats (PNG, SVG, etc.).
- `/dsl`: Contains the Structurizr DSL code used to generate the diagrams.
- `/docs`: Contains documentation on architectural decisions, design fundamentals, and other relevant information.

## License

This repository is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

See the [LICENSE](LICENSE) file for more details.

## Funding and Acknowledgments

This work was developed within the [GreenDIGIT](https://greendigit-project.eu/) project, funded by the European Union's Horizon Europe research and innovation programme under grant agreement No. [101131207](https://cordis.europa.eu/project/id/101131207), and by the Swiss State Secretariat for Education, Research and Innovation (SERI).

<img src="https://github.com/wattnet/.github/raw/main/images/GreenDIGIT logo color horizontal2.png" alt="GreenDIGIT Logo" width="230" align="right"/>
<img src="https://github.com/wattnet/.github/raw/main/images/EN_FundedbytheEU_RGB_POS.png" alt="EU Funded Logo" width="260" align="left"/>
<img src="https://github.com/wattnet/.github/raw/main/images/Flag_of_Switzerland.svg" alt="Swiss State Secretariat for Education, Research and Innovation (SERI)" height="50" align="left"/>
<br clear="all"/>

##### © 2026 Spanish National Research Council (CSIC). All rights reserved.
