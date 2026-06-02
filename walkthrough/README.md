# Support Material and Walkthrough Hub

This directory acts as the central archive for all agent-generated guides, examples, standalone templates, and specifications. It is structured into distinct categories to organize different types of technical help files.

> [!IMPORTANT]
> **Strict Code Boundaries**: No files in this walkthrough tree are part of the production execution environment. They are purely educational guides, seeds, and design specs to assist in manual implementation.

---

## 📂 Folder Structure

```text
walkthrough/
├── database/          # Database DDLs, schema structure, seeds, and migrations templates
├── networking/        # Networking protocols, serialization guides, socket examples
├── architecture/      # Clean architecture guidelines, layer patterns, UML/structure specs
└── testing/           # Make / CMake guides, CTest suites, unit testing templates
```

---

## 💾 1. Database (`walkthrough/database/`)
Contains SQL templates and schemas to configure PostgreSQL:
* **[01_schema.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/01_schema.sql)**: Production-ready core database schema definitions.
* **[02_seed_core_data.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/02_seed_core_data.sql)**: Lookup tables seed (classes, core decks).
* **[03_seed_cards.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/03_seed_cards.sql)**: Default encounter, treasure, equipment, curse, and AI cards.
* **[04_seed_achievements.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/04_seed_achievements.sql)**: Core achievement lookup seeds.

---

## 🌐 2. Networking (`walkthrough/networking/`)
Reserved for packet layouts, binary protocol guidelines, and socket programming support documents:
* *(Future guides on custom binary packet layouts, socket state machines, and serialization snippets go here)*

---

## 📐 3. Architecture (`walkthrough/architecture/`)
Reserved for domain separation diagrams, Clean Architecture tutorials, and coupling rules:
* *(Future UML diagrams, layer-to-layer dependency graphs, and design guides go here)*

---

## 🧪 4. Testing & Build (`walkthrough/testing/`)
Reserved for unit testing templates, Make/CMake setup guides, and environment scripts:
* *(Future CTest examples, Makefile configuration patterns, and run scripts go here)*
