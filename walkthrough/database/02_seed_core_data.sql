INSERT INTO card_types(name)
VALUES
('MONSTER'),
('TREASURE'),
('CURSE'),
('EVENT'),
('EQUIPMENT'),
('PVP'),
('AI');

-- Classes
INSERT INTO classes
(name, description, base_power_bonus)
VALUES

(
'Backend Developer',
'+2 against API related bugs',
2
),

(
'Frontend Developer',
'Can reroll UI encounters',
2
),

(
'DevOps Engineer',
'+3 against infrastructure incidents',
3
),

(
'QA Engineer',
'May reveal top card',
2
),

(
'Security Engineer',
'+4 against vulnerabilities',
4
),

(
'AI Engineer',
'Draw extra card after victories',
3
);

-- Decks
INSERT INTO decks
(name, description)
VALUES

(
'Core Monster Deck',
'Main encounter deck'
),

(
'Treasure Deck',
'Equipment and rewards'
),

(
'Curse Deck',
'Technical debt and disasters'
),

(
'AI Chaos Deck',
'AI related encounters'
);
