-- Monsters
INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Null Pointer Exception',
'Classic runtime disaster',
2,
0,
1
FROM card_types ct
WHERE ct.name='MONSTER';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Legacy Monolith',
'Nobody wants to touch it',
10,
1,
2
FROM card_types ct
WHERE ct.name='MONSTER';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Production Outage',
'Everything is on fire',
22,
2,
3
FROM card_types ct
WHERE ct.name='MONSTER';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'The Singularity',
'Nobody knows what happens next',
50,
3,
5
FROM card_types ct
WHERE ct.name='MONSTER';

-- Equipment
INSERT INTO card_definitions
(
card_type_id,
name,
description,
power_bonus
)

SELECT
ct.id,
'ThinkPad',
'+2 power',
2
FROM card_types ct
WHERE ct.name='EQUIPMENT';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
power_bonus
)

SELECT
ct.id,
'Linux Mastery',
'+3 power',
3
FROM card_types ct
WHERE ct.name='EQUIPMENT';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
power_bonus
)

SELECT
ct.id,
'PostgreSQL Expertise',
'+4 power',
4
FROM card_types ct
WHERE ct.name='EQUIPMENT';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
power_bonus
)

SELECT
ct.id,
'Emacs Mastery',
'+6 power',
6
FROM card_types ct
WHERE ct.name='EQUIPMENT';

-- AI Cards
INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Hallucinated Function',
'The code compiles. Nothing works.',
12,
1,
2
FROM card_types ct
WHERE ct.name='AI';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Infinite Agent Loop',
'Keeps thinking forever.',
15,
1,
2
FROM card_types ct
WHERE ct.name='AI';

INSERT INTO card_definitions
(
card_type_id,
name,
description,
monster_power,
reward_levels,
reward_treasures
)

SELECT
ct.id,
'Autonomous Junior Developer',
'Generated 14000 lines and 31 bugs.',
22,
2,
2
FROM card_types ct
WHERE ct.name='AI';

-- Curses
INSERT INTO card_definitions
(
card_type_id,
name,
description
)

SELECT
ct.id,
'Broken CI',
'Skip next combat.'
FROM card_types ct
WHERE ct.name='CURSE';

INSERT INTO card_definitions
(
card_type_id,
name,
description
)

SELECT
ct.id,
'Scope Creep',
'Next monster gains +5 power.'
FROM card_types ct
WHERE ct.name='CURSE';

INSERT INTO card_definitions
(
card_type_id,
name,
description
)

SELECT
ct.id,
'Context Window Exceeded',
'Discard half your hand.'
FROM card_types ct
WHERE ct.name='CURSE';
