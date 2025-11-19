# wattnet C4 Components

## Component: Metrics Repository Adapter

**Responsibility:**  
Bridges domain-specific objects and the generic metrics storage layer.

---

### Description

The **Metrics Repository Adapter** acts as a translation layer between the domain model (e.g., _Zone_, _Generation_, _Footprint_, _Demand_) and the generic `Metric` format used by the storage subsystem.  
It ensures that domain objects can be persisted and retrieved independently of the underlying storage technology, by converting them into storage-agnostic metrics enriched with metadata for filtering, validation, and status prioritization.

When reading, the adapter maps raw `Metric` instances obtained from the storage repository back into domain-specific API or core representations.

This component enables a clean separation of concerns:

-   The **domain layer** never depends on storage implementation details.
-   The **storage layer** remains completely unaware of domain concepts.
-   The **API layer** receives domain-level objects instead of raw metrics.

The adapter is the key integration point that maintains **consistency**, **correctness**, and **extensibility** across the architecture.

---

### Primary Responsibilities

-   Convert **domain objects → Metric** for persistence.
-   Convert **Metric → domain/API objects** when reading.
-   Enrich metrics with domain metadata (zone, type, status, source, validity).
-   Support extensible mappings for different types (generation, footprint, demand, etc.).
-   Act as the unified interface that modules use to interact with the metrics repository.

---

### Motivation in Architecture

Without this adapter, domain logic would leak into the storage layer or vice-versa, breaking modularity.  
The adapter makes the system **storage-agnostic**, **domain-safe**, and **future-proof**.
