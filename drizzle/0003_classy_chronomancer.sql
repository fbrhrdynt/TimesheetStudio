CREATE TABLE `activity_codes` (
	`code` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`kind` text NOT NULL,
	`unit` text NOT NULL,
	`created_by` text NOT NULL,
	`created` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `security_notices` (
	`user_id` text PRIMARY KEY NOT NULL,
	`version` integer NOT NULL,
	`seen_at` integer NOT NULL
);
