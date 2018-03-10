# add SQL queries to execute when configuring the database
# see /bin/sx-mariadb usage to activate this feature

LOCK TABLES `user_iphoneConfig` WRITE;
INSERT INTO `sample` VALUES (1,'version','0.0.5');
UNLOCK TABLES;