-- --------------------------------------------------------
-- Histeria v1.2.0
-- --------------------------------------------------------

-- Listage de la structure de table moi_c_nishi. histeria_ban
CREATE TABLE IF NOT EXISTS `histeria_ban` (
  `identifier` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `banid` varchar(50) DEFAULT NULL,
  `date` int DEFAULT NULL,
  `endate` int DEFAULT NULL,
  `author` varchar(50) NOT NULL
)

-- Listage de la structure de table moi_c_nishi. histeria_histoban
CREATE TABLE IF NOT EXISTS `histeria_histoban` (
  `identifier` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `message` longtext,
  `banid` varchar(50) DEFAULT NULL,
  `timeban` longtext,
  `author` varchar(50) DEFAULT NULL,
  `username` longtext
)
