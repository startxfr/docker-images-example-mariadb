# add SQL queries to execute when configuring the database
# see /bin/sx-mariadb usage to activate this feature

DROP TABLE IF EXISTS `sample`;
CREATE TABLE `sample` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(128) NOT NULL DEFAULT '',
  `val` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
