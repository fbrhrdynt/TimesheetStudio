CREATE TABLE `activity_overrides` (
	`code` text PRIMARY KEY NOT NULL,
	`json` text NOT NULL,
	`deleted` integer DEFAULT 0 NOT NULL,
	`revision` integer DEFAULT 1 NOT NULL,
	`updated` integer NOT NULL
);
