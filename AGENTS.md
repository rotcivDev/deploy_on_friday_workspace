# Agent and Mentorship Hub (AGENTS.md)

Welcome to the **Deploy on Friday** Agent Hub. This file acts as a central registry and organizer for all agent configurations, workspace skills, and agent-generated support files (documentation, guides, specs, templates).

---

## 🛠️ Strict Boundaries (Mentorship Rules)
To keep the learning experience hands-on and ensure code quality, the following rules apply to all AI agents:

> [!IMPORTANT]
> **1. Tech Project Source Tree Is Read-Only**: Agents **cannot** write or modify files in the main production codebase (`domain/`, `application/`, `infrastructure/`, `server/`, `client/`, or `shared/`) directly.
> **2. Project-Level Docs Are Writable**: Agents may freely create and update repository-level documentation and support artifacts outside the protected source tree, including root README files, `docs/`, `walkthrough/`, plans, guides, templates, and diagram files such as `.html`, `.drawio`, `.puml`, and `.mermaid`.
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

### Non-Negotiable TDD And Observability

All development policy in this workspace assumes test-driven development and observability from the first slice. No production behavior is accepted without a prior failing check and observable evidence that explains what happened, which actor/session initiated it, which command/result path executed, which state changed, and how the behavior can be replayed or audited.

Observability means structured domain/application events, command results, correlation identifiers, actor or session identifiers, replay seeds, quota/cooldown decisions, typed errors, transcripts, logs, and release artifacts. It is not just future monitoring dashboards. Operational control must be privacy-aware: collect the facts required for debugging, support, abuse prevention, demo quota enforcement, abandoned-match cooldowns, replay reconstruction, and product control; do not collect unrelated personal data.

The detailed policy is maintained in [walkthrough/architecture/tdd_observability_policy.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/tdd_observability_policy.html).

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
*   **[README.html](file:///home/msratso/workspaces/c_dev/README.html)**: Root workspace overview for Deploy on Friday, including modular deck direction and technical project map.
*   **[PRODUCT.html](file:///home/msratso/workspaces/c_dev/PRODUCT.html)**: Complete product vision, main deck plus extension model, roadmap, risks, and near-term backlog themes.
*   **[deploy_on_friday/README.md](file:///home/msratso/workspaces/c_dev/deploy_on_friday/README.md)**: Original project overview, game mechanics, and lore.
*   **[deploy_on_friday_prompt.md](file:///home/msratso/workspaces/c_dev/deploy_on_friday_prompt.md)**: Codex-ready project prompt and mentor operating brief.
*   **[walkthrough/product/modular_deck_strategy.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/modular_deck_strategy.html)**: Product Owner, game engineer, and architecture lead alignment for the modular main deck plus extension-pack strategy.
*   **[walkthrough/product/market_research_response.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/market_research_response.html)**: Cross-mentor response to MARKET_RESEARCH.txt, including market positioning, commercial strategy, signature mechanics, roadmap adjustments, and clarification questions.
*   **[walkthrough/product/extension_punch_card_era.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/extension_punch_card_era.html)**: Patch outline for The Punch Card Era extension.
*   **[walkthrough/product/extension_dot_com_bubble.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/extension_dot_com_bubble.html)**: Patch outline for The .com Bubble extension.
*   **[walkthrough/product/extension_im_a_developer.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/extension_im_a_developer.html)**: Patch outline for the I'm a Developer extension.
*   **[walkthrough/product/extension_saas_bubble.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/extension_saas_bubble.html)**: Patch outline for The SaaS Bubble extension.
*   **[walkthrough/product/extension_ai_new_era.html](file:///home/msratso/workspaces/c_dev/walkthrough/product/extension_ai_new_era.html)**: Patch outline for The AI New Era extension.
*   **[walkthrough/architecture/kickoff_backlog.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/kickoff_backlog.html)**: Product backlog for the v0.1 Root Prototype, compiled last by the Project Manager / Product Owner.
*   **[walkthrough/architecture/software_engineering_principles.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/software_engineering_principles.html)**: Source-of-truth engineering principle: domain understanding before tactical structure.
*   **[walkthrough/architecture/lead_architecture_refinement_guide.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/lead_architecture_refinement_guide.html)**: Lead architecture synthesis of team backlog refinements, dependency boundaries, and unified increment order.
*   **[walkthrough/architecture/t01_cycle_boundary_review.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/t01_cycle_boundary_review.html)**: Lead Architect completion evidence for XP task T01, confirming v0.1 cycle boundary, deferred scope, and traceability gates.
*   **[walkthrough/architecture/technical_naming_policy.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/technical_naming_policy.html)**: Architecture and systems policy decoupling public product names from C symbols, build targets, database names, protocol constants, and service identifiers.
*   **[walkthrough/architecture/tdd_observability_policy.html](file:///home/msratso/workspaces/c_dev/walkthrough/architecture/tdd_observability_policy.html)**: Lead Architect and XP Principal Engineer policy making TDD and observability non-negotiable from the first implementation slice.
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
*   **[walkthrough/xp/t02_layered_build_skeleton_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t02_layered_build_skeleton_plan.html)**: Multi-mentor handoff plan for the human implementing T02, including CMake, Make, C17 smoke tests, and boundary review examples.
*   **[walkthrough/xp/t03_local_workflow_docker_bootstrap_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t03_local_workflow_docker_bootstrap_plan.html)**: XP T03 Local Workflow and Docker Bootstrap.
*   **[walkthrough/xp/t04_validate_seeded_content_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t04_validate_seeded_content_plan.html)**: XP T04 Validate Seeded Content.
*   **[walkthrough/xp/t05_deck_membership_seed_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t05_deck_membership_seed_plan.html)**: XP T05 Deck Membership Seed.
*   **[walkthrough/xp/t06_deterministic_rng_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t06_deterministic_rng_plan.html)**: XP T06 Deterministic RNG.
*   **[walkthrough/xp/t07_encounter_deck_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t07_encounter_deck_plan.html)**: XP T07 Encounter Deck.
*   **[walkthrough/xp/t08_treasure_deck_equipment_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t08_treasure_deck_equipment_plan.html)**: XP T08 Treasure Deck and Equipment.
*   **[walkthrough/xp/t09_match_starting_state_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t09_match_starting_state_plan.html)**: XP T09 Match Starting State.
*   **[walkthrough/xp/t10_power_level_invariants_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t10_power_level_invariants_plan.html)**: XP T10 Power and Level Invariants.
*   **[walkthrough/xp/t11_first_combat_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t11_first_combat_plan.html)**: XP T11 Resolve First Combat.
*   **[walkthrough/xp/t12_first_curses_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t12_first_curses_plan.html)**: XP T12 Resolve First Curses.
*   **[walkthrough/xp/t13_command_results_events_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t13_command_results_events_plan.html)**: XP T13 Shape Command Results and Events.
*   **[walkthrough/xp/t14_application_command_boundary_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t14_application_command_boundary_plan.html)**: XP T14 Add Application Command Boundary.
*   **[walkthrough/xp/t15_deterministic_bot_baseline_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t15_deterministic_bot_baseline_plan.html)**: XP T15 Add Deterministic Bot Baseline.
*   **[walkthrough/xp/t16_full_match_simulation_transcript_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t16_full_match_simulation_transcript_plan.html)**: XP T16 Produce Full-Match Simulation Transcript.
*   **[walkthrough/xp/t17_terminal_snapshot_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t17_terminal_snapshot_plan.html)**: XP T17 Define Snapshot for Terminal Rendering.
*   **[walkthrough/xp/t18_ncurses_static_smoke_path_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t18_ncurses_static_smoke_path_plan.html)**: XP T18 Add NCurses Static Smoke Path.
*   **[walkthrough/xp/t19_local_playtest_loop_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t19_local_playtest_loop_plan.html)**: XP T19 Integrate The Local Playtest Loop.
*   **[walkthrough/xp/t20_release_candidate_gate_plan.html](file:///home/msratso/workspaces/c_dev/walkthrough/xp/t20_release_candidate_gate_plan.html)**: XP T20 Run Release Candidate Gate.
*   *(Add future programming guides or standalone code examples here)*

---

## 💡 How to Interact with Mentors

1. **Viewing Skills**: You or other agents can review these instructions at any time by executing a file read on the respective `SKILL.md` file with the `IsSkillFile: true` option.
2. **Assigning Tasks**: When you assign a task to a subagent, they will read their corresponding skill to guide their response, ensuring they only produce specifications, examples, or mentorship instructions instead of writing code directly.
