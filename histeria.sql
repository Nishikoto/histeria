-- --------------------------------------------------------
-- Histeria v1.2.0
-- --------------------------------------------------------

-- Listage de la structure de table enginerp. histeria_ban
CREATE TABLE IF NOT EXISTS `histeria_ban` (
  `identifier` longtext,
  `message` longtext,
  `banid` longtext,
  `date` int DEFAULT NULL,
  `endate` int DEFAULT NULL,
  `author` longtext
);

-- Listage de la structure de table enginerp. histeria_histoban
CREATE TABLE IF NOT EXISTS `histeria_histoban` (
  `identifier` longtext,
  `message` longtext,
  `banid` longtext,
  `timeban` longtext,
  `author` longtext,
  `username` longtext
);
