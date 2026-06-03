# Agent and Mentorship Hub (AGENTS.md)

Welcome to the **Dungeon of Technical Debt** Agent Hub. This file acts as a central registry and organizer for all agent configurations, workspace skills, and agent-generated support files (documentation, guides, specs, templates).

---

## 🛠️ Strict Boundaries (Mentorship Rules)
To keep the learning experience hands-on and ensure code quality, the following rules apply to all AI agents:

> [!IMPORTANT]
> **1. Tech Project Source Tree Is Read-Only**: Agents **cannot** write or modify files in the main production codebase (`domain/`, `application/`, `infrastructure/`, `server/`, `client/`, or `shared/`) directly.
> **2. Project-Level Docs Are Writable**: Agents may freely create and update repository-level documentation and support artifacts outside the protected source tree, including root `README.md` files, `docs/`, `walkthrough/`, plans, guides, templates, and diagram files such as `.html`, `.drawio`, `.puml`, and `.mermaid`.
> **3. Designers & Architects**: Can create design specifications, documentation files, templates, creative descriptions, and diagrams.
> **4. Engineers (Systems, DB & DevOps)**: Can produce support materials, API guides, configuration templates, SQL templates, CI/CD templates, environment guides, deployment plans, test plans, standalone coding examples, and implementation walkthroughs, but must never modify the primary codebase files.

---

## Codex Workspace Operating Guide

This workspace is intended to work with Codex as a mentorship and design partner, not as an autonomous production-code implementer.

### Instruction Discovery

Codex reads this `AGENTS.md` before working in the workspace. Keep durable repository rules here, and put temporary task constraints in the user prompt.

Current local mentor profiles live in `.agent/skills/`. Codex's current repo skill discovery convention uses `.agents/skills/` with an `s`. Treat the existing `.agent/skills/` directory as the mentorship registry. If these mentor profiles should become automatically discoverable Codex skills, mirror or migrate them to `.agents/skills/` with the same `SKILL.md` files, or package them as a Codex plugin.

### Safe Codex Defaults

Recommended local Codex settings for this workspace:

```toml
model = "gpt-5.5"
sandbox_mode = "workspace-write"
approval_policy = "on-request"
```

Use `gpt-5.5` for architecture, C17 systems design, database design, documentation, reviews, and complex reasoning. Use `gpt-5.4-mini` for lightweight drafting, summarization, or parallel subagent-style support where cost and speed matter more than depth. Prefer the Responses API for new OpenAI API examples; avoid adding new Chat Completions examples unless the user explicitly asks for compatibility with an older integration.

### Allowed Codex Outputs

Codex may create or modify:

* Documentation and design specs.
* Walkthroughs, templates, and standalone examples.
* SQL schema or seed templates under support/documentation paths.
* Prompt files and mentor instructions.
* Git support files when acting as the Git Specialist.
* DevOps support files outside the protected source tree, such as CI/CD templates, environment guides, runbooks, deployment plans, and service topology diagrams.
* Guides, plans, and diagram files stored outside the protected source tree.

Human-facing documents under `walkthrough/` must be written as `.html` files instead of Markdown. These HTML walkthrough files may include inline CSS and small inline JavaScript snippets for local, dependency-free demonstrations such as filters, checklists, accordions, state diagrams, or event examples. Keep executable support files in their native formats, such as `.sql` for database seeds.

### Software Engineering Source Of Truth

All technical approaches and decisions in this workspace must follow the principle in [walkthrough/architecture/software_engineering_principles.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/software_engineering_principles.html): **the domain is the source of truth, and strategic understanding comes before tactical structure**.

Clean Architecture, tactical DDD patterns, Docker/Compose, CMake, database repositories, protocol layouts, and CI gates are implementation tools. Use them only when they clarify the domain, protect a domain boundary, improve deterministic feedback, or reduce delivery risk. Do not start from tactical patterns and force the game/product domain to fit them.

Codex must not directly write production implementation files in:

* `domain/`
* `application/`
* `infrastructure/`
* `server/`
* `client/`
* `shared/`

Treat the tech project source tree as read-only. When the user asks for implementation, provide a patch plan, pseudocode, standalone examples, diagrams, or step-by-step mentorship instead of editing those directories.

### Approval and Network Rules

Assume network access is disabled unless explicitly approved. Ask for approval before:

* Fetching current OpenAI documentation or other external references.
* Installing packages or downloading dependencies.
* Running commands outside the workspace sandbox.
* Performing destructive Git operations.

For OpenAI model or API guidance, verify current behavior against official OpenAI documentation when freshness matters.

### Review Guidelines

When reviewing code or specs, prioritize:

* Clean Architecture dependency violations.
* Client trust or server-authority regressions.
* Non-deterministic game-rule behavior.
* Unsafe C memory ownership or thread-safety assumptions.
* Binary protocol ambiguity.
* PostgreSQL schema integrity, indexing, and migration safety.
* Missing tests for serialization, combat rules, card effects, and persistence.

---

## 🧑‍💻 Registered Mentor Profiles (Workspace Skills)

The following skills are placed in the project root [`.agent/skills/`](file:///home/msratso/workspaces/c_dev/.agent/skills/):

| Role | Skill Path | Focus Areas |
| :--- | :--- | :--- |
| **Lead Software Architect** | [`lead-architect`](file:///home/msratso/workspaces/c_dev/.agent/skills/lead-architect/SKILL.md) | Clean Architecture, coupling, dependency flows, interfaces. |
| **Senior Game Designer** | [`game-designer`](file:///home/msratso/workspaces/c_dev/.agent/skills/game-designer/SKILL.md) | Game balancing, cards, level milestones, lore, and engineering satire. |
| **Senior Systems Programmer** | [`systems-programmer`](file:///home/msratso/workspaces/c_dev/.agent/skills/systems-programmer/SKILL.md) | POSIX sockets, pthreads thread-safety, CMake builds, binary packet layouts. |
| **Extreme Programming Principal Engineer** | [`xp-principal-engineer`](file:///home/msratso/workspaces/c_dev/.agent/skills/xp-principal-engineer/SKILL.md) / [`Codex discovery mirror`](file:///home/msratso/workspaces/c_dev/.agents/skills/xp-principal-engineer/SKILL.md) | XP implementation stories, TDD task slices, pairing prompts, acceptance tests, and small-release planning. |
| **PostgreSQL Architect** | [`db-architect`](file:///home/msratso/workspaces/c_dev/.agent/skills/db-architect/SKILL.md) | Database tables, indexes, event logging using JSONB/GIN, DDL template migrations. |
| **Game Industry DevOps Principal Engineer** | [`devops-principal-engineer`](file:///home/msratso/workspaces/c_dev/.agent/skills/devops-principal-engineer/SKILL.md) | Local environments, CI/CD, runtime services, deployment topology, secrets, observability, release gates. |
| **Git Specialist** | [`git-specialist`](file:///home/msratso/workspaces/c_dev/.agent/skills/git-specialist/SKILL.md) | Git operations, branching strategy, Conventional Commits, ignore/attribute configurations. |
| **Project Manager / Product Owner** | [`project-manager-owner`](file:///home/msratso/workspaces/c_dev/.agent/skills/project-manager-owner/SKILL.md) | Discovery, phased roadmaps, backlog creation, MVP slicing, incremental releases, themed extensions. |

---

## 📂 Registry of Agent-Generated Support Files

When agents generate documents, specs, examples, or templates, they must be registered in the directory below for easy tracking:

### 🎨 Creative & Design Docs (Architects & Designers)
*   **[dungeons_and_devs/README.md](file:///home/msratso/workspaces/c_dev/dungeons_and_devs/README.md)**: Original project overview, game mechanics, and lore.
*   **[dungeons_and_devs_prompt.md](file:///home/msratso/workspaces/c_dev/dungeons_and_devs_prompt.md)**: Codex-ready project prompt and mentor operating brief.
*   **[walkthrough/architecture/kickoff_backlog.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/kickoff_backlog.html)**: Product backlog for the v0.1 Root Prototype, compiled last by the Project Manager / Product Owner.
*   **[walkthrough/architecture/software_engineering_principles.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/software_engineering_principles.html)**: Source-of-truth engineering principle: domain understanding before tactical structure.
*   **[walkthrough/architecture/lead_architecture_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/lead_architecture_refinement_guide.html)**: Lead architecture synthesis of team backlog refinements, dependency boundaries, and unified increment order.
*   **[walkthrough/architecture/t01_cycle_boundary_review.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/t01_cycle_boundary_review.html)**: Lead Architect completion evidence for XP task T01, confirming v0.1 cycle boundary, deferred scope, and traceability gates.
*   **[walkthrough/design/gameplay_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/design/gameplay_refinement_guide.html)**: Gameplay/content backlog refinement, v0.1 balance targets, bot behavior, and playtest plan.
*   *(Add future design files here)*

### 📝 Support Materials, Guides & Examples (Engineers)
*   **[walkthrough/database/01_schema.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/01_schema.sql)**: Core database schema template.
*   **[walkthrough/database/02_seed_core_data.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/02_seed_core_data.sql)**: Core lookup/metadata seed SQL.
*   **[walkthrough/database/03_seed_cards.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/03_seed_cards.sql)**: Card seed template.
*   **[walkthrough/database/04_seed_achievements.sql](file:///home/msratso/workspaces/c_dev/walkthrough/database/04_seed_achievements.sql)**: Achievements seed template.
*   **[walkthrough/database/db_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/database/db_refinement_guide.html)**: Database architecture design refinement spec for v0.1.
*   **[walkthrough/devops/devops_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/devops/devops_refinement_guide.html)**: DevOps refinement guide for local environment, Make workflow, CI gates, database lifecycle, runtime topology, and v0.1 release readiness.
*   **[walkthrough/git/git_workflow_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/git/git_workflow_refinement_guide.html)**: Git workflow and repository hygiene refinement guide for HTML walkthrough migration and v0.1 delivery.
*   **[walkthrough/testing/systems_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/testing/systems_refinement_guide.html)**: Systems architecture compile, run and tests guide for v0.1.
*   **[walkthrough/xp/v0_1_first_development_cycle_task_list.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/v0_1_first_development_cycle_task_list.html)**: XP task list for completing the proposed v0.1 development cycle, including TDD slices, pairing prompts, and release gates.
*   *(Add future programming guides or standalone code examples here)*

---

## 💡 How to Interact with Mentors

1. **Viewing Skills**: You or other agents can review these instructions at any time by executing a file read on the respective `SKILL.md` file with the `IsSkillFile: true` option.
2. **Assigning Tasks**: When you assign a task to a subagent, they will read their corresponding skill to guide their response, ensuring they only produce specifications, examples, or mentorship instructions instead of writing code directly.
