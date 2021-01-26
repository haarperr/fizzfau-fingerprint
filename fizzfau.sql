ALTER TABLE `users` 
	ADD	`fingerprint` LONGTEXT NULL DEFAULT substr(md5(rand()),1,16) COLLATE 'utf8mb4_general_ci',
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;